// MIT License
//
// Copyright (c) 2017-present qazyn951230 qazyn951230@gmail.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import NIO
import NIOHTTP1

final class HttpClientResponseDecoder: ChannelInboundHandler, RemovableChannelHandler {
    typealias InboundIn = HTTPClientResponsePart
    typealias OutboundOut = HttpResponse

    /// Tracks `HttpClientHandler`'s state.
    enum ResponseState {
        /// Waiting to parse the next response.
        case ready
        /// Currently parsing the response's body.
        case parsingBody(HTTPResponseHead, ByteBuffer?)
    }

    var state: ResponseState = .ready

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let res = unwrapInboundIn(data)
        switch res {
        case let .head(head):
            switch state {
            case .ready:
                state = .parsingBody(head, nil)
            case .parsingBody:
                assert(false, "Unexpected HttpClientResponsePart.head when body was being parsed.")
            }
        case var .body(body):
            switch state {
            case .ready:
                assert(false, "Unexpected HttpClientResponsePart.body when awaiting request head.")
            case let .parsingBody(head, existingData):
                let buffer: ByteBuffer
                if var existing = existingData {
                    existing.writeBuffer(&body)
                    buffer = existing
                } else {
                    buffer = body
                }
                state = .parsingBody(head, buffer)
            }
        case .end(let tailHeaders):
            assert(tailHeaders == nil, "Unexpected tail headers")
            switch state {
            case .ready:
                assert(false, "Unexpected HttpClientResponsePart.end when awaiting request head.")
            case let .parsingBody(head, data):
                let body: HttpBody = data.flatMap(HttpBody.init(buffer:)) ?? HttpBody.empty
                let response = HttpResponse(
                    status: head.status,
                    version: head.version,
                    headersNoUpdate: head.headers,
                    body: body
                )
                state = .ready
                context.fireChannelRead(wrapOutboundOut(response))
            }
        }
    }
}
