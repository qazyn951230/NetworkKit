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

/// Standard HTTP header names.
///
/// These are all defined as lowercase to support HTTP/2 requirements while also not
/// violating HTTP/1.x requirements. New header names should always be lowercase.
public struct HttpHeader: RawRepresentable, Hashable {
    public typealias RawValue = String

    public let rawValue: String

    public init(_ value: String) {
        rawValue = value
    }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension HttpHeader {
    public static let accept = HttpHeader(rawValue: "accept")
    public static let acceptCharset = HttpHeader(rawValue: "accept-charset")
    public static let acceptEncoding = HttpHeader(rawValue: "accept-encoding")
    public static let acceptLanguage = HttpHeader(rawValue: "accept-language")
    public static let acceptRanges = HttpHeader(rawValue: "accept-ranges")
    public static let acceptPatch = HttpHeader(rawValue: "accept-patch")
    public static let accessControlAllowCredentials = HttpHeader(rawValue: "accept-control-allow-credentials")
    public static let accessControlAllowHeaders = HttpHeader(rawValue: "accept-control-allow-headers")
    public static let accessControlAllowMethods = HttpHeader(rawValue: "accept-control-allow-methods")
    public static let accessControlAllowOrigin = HttpHeader(rawValue: "accept-control-allow-origin")
    public static let accessControlExposeHeaders = HttpHeader(rawValue: "accept-control-expose-headers")
    public static let accessControlMaxAge = HttpHeader(rawValue: "accept-control-max-age")
    public static let accessControlRequestHeaders = HttpHeader(rawValue: "accept-control-request-headers")
    public static let accessControlRequestMethod = HttpHeader(rawValue: "accept-control-request-method")
    public static let age = HttpHeader(rawValue: "age")
    public static let allow = HttpHeader(rawValue: "allow")
    public static let authorization = HttpHeader(rawValue: "authorization")
    public static let cacheControl = HttpHeader(rawValue: "cache-control")
    public static let connection = HttpHeader(rawValue: "connection")
    public static let contentBase = HttpHeader(rawValue: "content-base")
    public static let contentEncoding = HttpHeader(rawValue: "content-encoding")
    public static let contentLanguage = HttpHeader(rawValue: "content-language")
    public static let contentLength = HttpHeader(rawValue: "content-length")
    public static let contentLocation = HttpHeader(rawValue: "content-location")
    public static let contentTransferEncoding = HttpHeader(rawValue: "content-transfer-encoding")
    public static let contentDisposition = HttpHeader(rawValue: "content-disposition")
    public static let contentMD5 = HttpHeader(rawValue: "content-md5")
    public static let contentRange = HttpHeader(rawValue: "content-range")
    public static let contentSecurityPolicy = HttpHeader(rawValue: "content-security-policy")
    public static let contentType = HttpHeader(rawValue: "content-type")
    public static let cookie = HttpHeader(rawValue: "cookie")
    public static let date = HttpHeader(rawValue: "date")
    public static let dnt = HttpHeader(rawValue: "dnt")
    public static let etag = HttpHeader(rawValue: "etag")
    public static let expect = HttpHeader(rawValue: "expect")
    public static let expires = HttpHeader(rawValue: "expires")
    public static let from = HttpHeader(rawValue: "from")
    public static let host = HttpHeader(rawValue: "host")
    public static let ifMatch = HttpHeader(rawValue: "if-match")
    public static let ifModifiedSince = HttpHeader(rawValue: "if-modified-since")
    public static let ifNoneMatch = HttpHeader(rawValue: "if-none-match")
    public static let ifRange = HttpHeader(rawValue: "if-range")
    public static let ifUnmodifiedSince = HttpHeader(rawValue: "if-unmodified-since")
    public static let keepAlive = HttpHeader(rawValue: "keep-alive")
    public static let lastModified = HttpHeader(rawValue: "last-modified")
    public static let location = HttpHeader(rawValue: "location")
    public static let maxForwards = HttpHeader(rawValue: "max-forwards")
    public static let origin = HttpHeader(rawValue: "origin")
    public static let pragma = HttpHeader(rawValue: "pragma")
    public static let proxyAuthenticate = HttpHeader(rawValue: "proxy-authenticate")
    public static let proxyAuthorization = HttpHeader(rawValue: "proxy-authorizatio")
    public static let proxyConnection = HttpHeader(rawValue: "proxy-connection")
    public static let range = HttpHeader(rawValue: "range")
    public static let referer = HttpHeader(rawValue: "referer")
    public static let retryAfter = HttpHeader(rawValue: "retry-after")
    public static let secWebsocketKey1 = HttpHeader(rawValue: "sec-websocket-key1")
    public static let secWebsocketKey2 = HttpHeader(rawValue: "sec-websocket-key2")
    public static let secWebsocketLocation = HttpHeader(rawValue: "sec-websocket-location")
    public static let secWebsocketOrigin = HttpHeader(rawValue: "sec-websocket-origin")
    public static let secWebsocketProtocol = HttpHeader(rawValue: "sec-websocket-protocol")
    public static let secWebsocketVersion = HttpHeader(rawValue: "sec-websocket-version")
    public static let secWebsocketKey = HttpHeader(rawValue: "sec-websocket-key")
    public static let secWebsocketAccept = HttpHeader(rawValue: "sec-websocket-accept")
    public static let secWebsocketExtensions = HttpHeader(rawValue: "sec-websocket-extensions")
    public static let server = HttpHeader(rawValue: "server")
    public static let setCookie = HttpHeader(rawValue: "set-cookie")
    public static let setCookie2 = HttpHeader(rawValue: "set-cookie2")
    public static let te = HttpHeader(rawValue: "te")
    public static let trailer = HttpHeader(rawValue: "trailer")
    public static let transferEncoding = HttpHeader(rawValue: "transfer-encoding")
    public static let upgrade = HttpHeader(rawValue: "upgrade")
    public static let upgradeInsecureRequests = HttpHeader(rawValue: "upgrade-insecure-requests")
    public static let userAgent = HttpHeader(rawValue: "user-agent")
    public static let vary = HttpHeader(rawValue: "vary")
    public static let via = HttpHeader(rawValue: "via")
    public static let warning = HttpHeader(rawValue: "warning")
    public static let websocketLocation = HttpHeader(rawValue: "websocket-location")
    public static let websocketOrigin = HttpHeader(rawValue: "websocket-origin")
    public static let websocketProtocol = HttpHeader(rawValue: "websocket-protocol")
    public static let wwwAuthenticate = HttpHeader(rawValue: "www-authenticate")
    public static let xFrameOptions = HttpHeader(rawValue: "x-frame-options")
    public static let xRequestedWith = HttpHeader(rawValue: "x-requested-with")
}
