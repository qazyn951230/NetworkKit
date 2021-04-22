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

final class HttpClientHandler: ChannelDuplexHandler, RemovableChannelHandler {
    typealias InboundIn = HttpResponse
    typealias OutboundIn = RequestContext
    typealias OutboundOut = HttpRequest

    private var queue: [RequestContext] = []

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let response = unwrapInboundIn(data)
        queue.removeFirst()
            .promise.succeed(response)
    }

    func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        let request = unwrapOutboundIn(data)
        self.queue.append(request)
        context.write(wrapOutboundOut(request.request), promise: nil)
        context.flush()
    }

    func errorCaught(context: ChannelHandlerContext, error: Error) {
        if queue.isEmpty {
            context.fireErrorCaught(error)
        } else {
            queue.removeFirst()
                .promise.fail(error)
        }
    }

    func close(context: ChannelHandlerContext, mode: CloseMode, promise: EventLoopPromise<Void>?) {
        guard let promise = promise else {
            context.close(mode: mode, promise: nil)
            return
        }
        let p = context.eventLoop.makePromise(of: Void.self)
        context.close(mode: mode, promise: p)
        p.futureResult.whenComplete { result in
            promise.completeWith(result)
        }
    }

    final class RequestContext {
        let request: HttpRequest
        let promise: EventLoopPromise<HttpResponse>

        init(request: HttpRequest, promise: EventLoopPromise<HttpResponse>) {
            self.request = request
            self.promise = promise
        }
    }
}
