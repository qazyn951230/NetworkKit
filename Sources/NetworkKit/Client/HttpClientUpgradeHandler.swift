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

public protocol HttpClientProtocolUpgrader {
    /// Builds the `HTTPHeaders` required for an upgrade.
    func buildUpgradeRequest() -> HttpHeaders

    /// Called if `isValidUpgradeResponse` returns `true`. This should return the `UpgradeResult`
    /// that will ultimately be returned by `HTTPClient.upgrade(...)`.
    func upgrade(context: ChannelHandlerContext, upgradeResponse: HTTPResponseHead) -> EventLoopFuture<Void>
}

final class HttpClientUpgradeHandler: ChannelDuplexHandler, RemovableChannelHandler {
    typealias InboundIn = HttpResponse
    typealias OutboundIn = HttpRequest
    typealias OutboundOut = HttpRequest

    enum UpgradeState {
        case ready
        case pending(HttpClientProtocolUpgrader)
    }

    var state: UpgradeState = .ready
    let handlers: [String]

    init(handlers: [String]) {
        self.handlers = handlers
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        context.fireChannelRead(data)
        switch state {
        case let .pending(upgrader):
            let response: HttpResponse = unwrapInboundIn(data)
            if response.status == .switchingProtocols {
                var futures = handlers.map {
                    context.pipeline.removeHandler(name: $0)
                }
                futures.insert(context.pipeline.removeHandler(self), at: 0)
                EventLoopFuture<Void>.andAllSucceed(futures, on: context.eventLoop)
                    .flatMap { () -> EventLoopFuture<Void> in
                        upgrader.upgrade(context: context, upgradeResponse: HTTPResponseHead(
                            version: response.version.raw(),
                            status: response.status.raw(),
                            headers: response.headers.raw()
                        ))
                    }.whenFailure { error in
                        self.errorCaught(context: context, error: error)
                    }

            }
        case .ready:
            break
        }
    }

    func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        var request: HttpRequest = unwrapOutboundIn(data)
        if let upgrader = request.upgrader {
            for (name, value) in upgrader.buildUpgradeRequest() {
                request.headers[name] = value
            }
            state = .pending(upgrader)
        }
        context.write(wrapOutboundOut(request), promise: promise)
    }
}
