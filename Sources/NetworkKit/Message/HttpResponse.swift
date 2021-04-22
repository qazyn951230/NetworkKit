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

public struct HttpResponse: HttpMessage {
    public var status: Status
    public var version: HttpVersion
    public var headers: HttpHeaders
    public var body: HttpBody

    public init(
        status: Status = .ok,
        version: HttpVersion = .v1_1,
        headers: HttpHeaders = [:],
        body: HttpBody = .empty
    ) {
        self.status = status
        self.version = version
        self.headers = headers
        self.body = body
    }

    init(
        status: HTTPResponseStatus,
        version: HTTPVersion,
        headersNoUpdate headers: HTTPHeaders,
        body: HttpBody
    ) {
        self.init(status: .from(status), version: .from(version),
            headers: .from(headers), body: body)
    }

    public struct Status: RawRepresentable, Equatable {
        public let rawValue: UInt

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        public static let `continue`: Status = 100
        public static let switchingProtocols: Status = 101
        public static let processing: Status = 102
        public static let earlyHints: Status = 103

        public static let ok: Status = 200
        public static let created: Status = 201
        public static let accepted: Status = 202
        public static let nonAuthoritativeInformation: Status = 203
        public static let noContent: Status = 204
        public static let resetContent: Status = 205
        public static let partialContent: Status = 206
        public static let multiStatus: Status = 207
        public static let alreadyReported: Status = 208
        public static let imUsed: Status = 226

        public static let multipleChoices: Status = 300
        public static let movedPermanently: Status = 301
        public static let found: Status = 302
        public static let seeOther: Status = 303
        public static let notModified: Status = 304
        public static let useProxy: Status = 305
        public static let temporaryRedirect: Status = 307
        public static let permanentRedirect: Status = 308

        public static let badRequest: Status = 400
        public static let unauthorized: Status = 401
        public static let paymentRequired: Status = 402
        public static let forbidden: Status = 403
        public static let notFound: Status = 404
        public static let methodNotAllowed: Status = 405
        public static let notAcceptable: Status = 406
        public static let proxyAuthenticationRequired: Status = 407
        public static let requestTimeout: Status = 408
        public static let conflict: Status = 409
        public static let gone: Status = 410
        public static let lengthRequired: Status = 411
        public static let preconditionFailed: Status = 412
        public static let payloadTooLarge: Status = 413
        public static let uriTooLong: Status = 414
        public static let unsupportedMediaType: Status = 415
        public static let rangeNotSatisfiable: Status = 416
        public static let expectationFailed: Status = 417
        public static let imATeapot: Status = 418
        public static let misdirectedRequest: Status = 421
        public static let unprocessableEntity: Status = 422
        public static let locked: Status = 423
        public static let failedDependency: Status = 424
        public static let upgradeRequired: Status = 426
        public static let preconditionRequired: Status = 428
        public static let tooManyRequests: Status = 429
        public static let requestHeaderFieldsTooLarge: Status = 431
        public static let unavailableForLegalReasons: Status = 451

        public static let internalServerError: Status = 500
        public static let notImplemented: Status = 501
        public static let badGateway: Status = 502
        public static let serviceUnavailable: Status = 503
        public static let gatewayTimeout: Status = 504
        public static let httpVersionNotSupported: Status = 505
        public static let variantAlsoNegotiates: Status = 506
        public static let insufficientStorage: Status = 507
        public static let loopDetected: Status = 508
        public static let notExtended: Status = 510
        public static let networkAuthenticationRequired: Status = 511
    }
}

extension HttpResponse.Status: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: UInt) {
        self.init(rawValue: value)
    }
}

extension HttpResponse.Status {
    func raw() -> HTTPResponseStatus {
        HTTPResponseStatus(statusCode: Int(rawValue))
    }

    static func from(_ status: HTTPResponseStatus) -> HttpResponse.Status {
        .init(rawValue: status.code)
    }
}
