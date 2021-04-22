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

import NIOHTTP1

public struct HttpRequest: HttpMessage {
    public var method: HttpMethod
    public var uri: URI
    public var version: HttpVersion
    public var headers: HttpHeaders
    public var body: HttpBody

    public var upgrader: HttpClientProtocolUpgrader?

    public init(
        method: HttpMethod = .get,
        uri: URI = .root,
        version: HttpVersion = .v1_1,
        headers: HttpHeaders = [:],
        body: HttpBody = .empty
    ) {
        self.method = method
        self.uri = uri
        self.version = version
        self.headers = headers
        self.body = body
    }

    func header(headers: HttpHeaders) -> HTTPRequestHead {
        let path: String
        if let query = uri.query {
            path = uri.path + "?" + query
        } else {
            path = uri.path
        }

        return HTTPRequestHead(
            version: version.raw(),
            method: method.raw(),
            uri: path.hasPrefix("/") ? path : "/" + path,
            headers: headers.raw()
        )
    }
}
