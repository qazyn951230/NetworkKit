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

/// Type representing HTTP methods.
///
/// - Seealso: [RFC 7231](https://tools.ietf.org/html/rfc7231#section-4.3)
public struct HttpMethod: RawRepresentable {
    public typealias RawValue = String

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    func raw() -> HTTPMethod {
        HTTPMethod(rawValue: rawValue)
    }
}

extension HttpMethod {
    public static let connect = HttpMethod(rawValue: "CONNECT")
    public static let delete = HttpMethod(rawValue: "DELETE")
    public static let get = HttpMethod(rawValue: "GET")
    public static let head = HttpMethod(rawValue: "HEAD")
    public static let options = HttpMethod(rawValue: "OPTIONS")
    public static let patch = HttpMethod(rawValue: "PATCH")
    public static let post = HttpMethod(rawValue: "POST")
    public static let put = HttpMethod(rawValue: "PUT")
    public static let trace = HttpMethod(rawValue: "TRACE")
}

