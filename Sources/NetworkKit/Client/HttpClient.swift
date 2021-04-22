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
import NIOSSL

func isIP(_ value: String) -> Bool {
    var ipv4Addr = in_addr()
    var ipv6Addr = in6_addr()
    return value.withCString { ptr in
        inet_pton(AF_INET, ptr, &ipv4Addr) == 1 || inet_pton(AF_INET6, ptr, &ipv6Addr) == 1
    }
}

public final class HttpClient {
    public let configuration: Configuration
    public let group: EventLoopGroup

    public init(configuration: Configuration = .init(), on group: EventLoopGroup) {
        self.configuration = configuration
        self.group = group
    }

    public func send(_ request: HttpRequest) -> EventLoopFuture<HttpResponse> {
        let host = request.uri.host ?? ""
        let defaultPort = request.uri.scheme == "https" ? 443 : 80
        let port = request.uri.port ?? defaultPort
        let tls = configuration.tlsConfiguration(by: request.uri.scheme)
        let eventLoop = group.next()

        let bootstrap = ClientBootstrap(group: eventLoop)
            .connectTimeout(configuration.timeoutOfRequest)
            .channelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .channelInitializer { channel in
                var handlers: [(String, ChannelHandler)] = []
                var names: [String] = []

                if let tlsConfig = tls {
                    let sslContext = try! NIOSSLContext(configuration: tlsConfig)
                    let tlsHandler = try! NIOSSLClientHandler(context: sslContext,
                        serverHostname: isIP(host) ? nil : host
                    )
                    handlers.append(("tls", tlsHandler))
                }

                handlers.append(("http-encoder", HTTPRequestEncoder()))
                names.append("http-encoder")

                let responseDecoder = ByteToMessageHandler(HTTPResponseDecoder())
                handlers.append(("http-decoder", responseDecoder))
                names.append("http-decoder")

                handlers.append(("client-decoder", HttpClientResponseDecoder()))
                names.append("client-decoder")

                // When port is different from the default port for the scheme
                // it must be explicitly specified in the `Host` HTTP header.
                // See https://tools.ietf.org/html/rfc2616#section-14.23
                let requestEncoder = HttpClientRequestEncoder(
                    host: port == defaultPort ? host : "\(host):\(port)")
                handlers.append(("client-encoder", requestEncoder))
                names.append("client-encoder")

                let handler = HttpClientHandler()
                names.append("client")

                let upgrader = HttpClientUpgradeHandler(handlers: names)
                handlers.append(("upgrader", upgrader))
                handlers.append(("client", handler))

                return EventLoopFuture.andAllSucceed(
                    handlers.map { channel.pipeline.addHandler($1, name: $0, position: .last) },
                    on: channel.eventLoop)
            }

        return bootstrap.connect(host: host, port: port).flatMap { channel in
            let promise = channel.eventLoop.makePromise(of: HttpResponse.self)
            let context = HttpClientHandler.RequestContext(request: request, promise: promise)
            channel.write(context, promise: nil)
            return promise.futureResult.flatMap { response in
                if request.upgrader != nil {
                    // upgrader is responsible for closing
                    return channel.eventLoop.makeSucceededFuture(response)
                } else {
                    return channel.close().map { response }
                }
            }
        }
    }

    public struct Configuration {
        public var tls: TLSConfiguration?
        public var timeoutOfRequest: TimeAmount

        public init(
            tls: TLSConfiguration? = nil,
            timeoutOfRequest: TimeAmount = .seconds(60)
        ) {
            self.tls = tls
            self.timeoutOfRequest = timeoutOfRequest
        }

        func tlsConfiguration(by scheme: String?) -> TLSConfiguration? {
            if scheme == "https" {
                return tls ?? TLSConfiguration.forClient()
            }
            return nil
        }
    }
}
