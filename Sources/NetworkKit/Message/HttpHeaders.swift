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

/// Case insensitive and ordered http headers container.
public struct HttpHeaders: Collection {
    public typealias Element = (key: HttpHeader, value: String)
    public typealias Index = Int

    @usableFromInline
    private(set) var entries: [Entry]

    public init() {
        entries = []
    }

    public init(minimumCapacity: Int) {
        entries = []
        entries.reserveCapacity(minimumCapacity)
    }

    @inlinable
    public var isEmpty: Bool {
        entries.isEmpty
    }

    @inlinable
    public var count: Int {
        entries.count
    }

    @inlinable
    public var capacity: Int {
        entries.capacity
    }

    // MARK: Manipulating Indices

    @inlinable
    public var startIndex: Int {
        entries.startIndex
    }

    @inlinable
    public var endIndex: Int {
        entries.endIndex
    }

    @inlinable
    public func index(after i: Int) -> Int {
        entries.index(after: i)
    }

    @inlinable
    public func index(forKey key: HttpHeader) -> Int? {
        entries.firstIndex(where: HttpHeaders.equals(key))
    }

    @inlinable
    public func formIndex(after i: inout Index) {
        entries.formIndex(after: &i)
    }

    @inlinable
    public mutating func reserveCapacity(_ minimumCapacity: Int) {
        entries.reserveCapacity(minimumCapacity)
    }

    // MARK: - Accessing Keys and Values

    public subscript(position: Int) -> (key: HttpHeader, value: String) {
        get {
            let entry = entries[position]
            return (entry.key, entry.value)
        }
    }

    public subscript(key: HttpHeader, replace: Bool = false) -> String? {
        get {
            entries.first(where: HttpHeaders.equals(key))?.value
        }
        set {
            let _key = key
            if let next = newValue {
                if let old = entries.first(where: HttpHeaders.equals(_key)) {
                    var values = old.values
                    if replace {
                        values = [next]
                    } else {
                        values.append(next)
                    }
                    old.values = values
                } else {
                    entries.append(Entry(key: _key, value: next))
                }
            } else {
                if let index = entries.firstIndex(where: HttpHeaders.equals(_key)) {
                    entries.remove(at: index)
                }
            }
        }
    }

    @discardableResult
    mutating func updateValue(_ value: String, forKey key: HttpHeader) -> String? {
        let old = self[key]
        self[key] = value
        return old
    }

    func asDictionary() -> [HttpHeader: String] {
        var map: [HttpHeader: String] = [:]
        forEach { (key, value) in
            map[key] = value
        }
        return map
    }

    func asRawDictionary() -> [String: String] {
        var map: [String: String] = [:]
        forEach { (key, value) in
            map[key.rawValue] = value
        }
        return map
    }

    @inline(__always)
    @usableFromInline
    static func equals(_ key: HttpHeader) -> (Entry) -> Bool {
        { entry in
            entry.key == key
        }
    }

    @usableFromInline
    final class Entry {
        let key: HttpHeader
        var values: [String] {
            didSet {
                value = values.joined(separator: ",")
            }
        }
        private(set) var value: String

        init(key: HttpHeader) {
            self.key = key
            self.values = []
            self.value = ""
        }

        init(key: HttpHeader, value: String) {
            self.key = key
            self.values = [value]
            self.value = value
        }
    }
}

extension HttpHeaders: ExpressibleByDictionaryLiteral {
    public typealias Key = HttpHeader
    public typealias Value = String

    public init(dictionaryLiteral elements: (Key, Value)...) {
        entries = []
        entries.reserveCapacity(elements.count)
        for element in elements {
            self[element.0] = element.1
        }
    }
}


extension HttpHeaders {
    func raw() -> HTTPHeaders {
        HTTPHeaders(self.map { ($0.key.rawValue, $0.value) })
    }

    static func from(_ value: HTTPHeaders) -> HttpHeaders {
        var result = HttpHeaders()
        result.reserveCapacity(value.count)
        value.forEach { name, value in
            result[HttpHeader(name)] = value
        }
        return result
    }
}
