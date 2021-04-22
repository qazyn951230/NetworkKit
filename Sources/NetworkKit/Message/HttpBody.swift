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
import Foundation

protocol _HttpBody {
    var buffer: ByteBuffer { get }
}

public struct HttpBody {
    let body: _HttpBody

    var buffer: ByteBuffer {
        body.buffer
    }

    init(body: _HttpBody) {
        self.body = body
    }

    public init(buffer: ByteBuffer) {
        body = BufferBody(buffer: buffer)
    }

    public init(data: Data) {
        body = DataBody(data: data)
    }

    public static var empty: HttpBody {
        HttpBody(body: EmptyBody())
    }
}

struct EmptyBody: _HttpBody {
    var buffer: ByteBuffer {
        .init()
    }
}

struct BufferBody: _HttpBody {
    let buffer: ByteBuffer
}

struct DataBody: _HttpBody {
    let data: Data

    var buffer: ByteBuffer {
        var buffer = ByteBufferAllocator().buffer(capacity: data.count)
        buffer.writeBytes(data)
        return buffer
    }
}
