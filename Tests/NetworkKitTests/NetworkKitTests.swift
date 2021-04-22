import XCTest
import NIO
@testable import NetworkKit

final class NetworkKitTests: XCTestCase {
    func testExample() {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let client = HttpClient(on: group)
        let request = HttpRequest(uri: URI(string: "https://www.baidu.com/")!)
        let response = try! client.send(request)
            .wait()
        try! group.syncShutdownGracefully()
        XCTAssertEqual(response.status, .ok)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
