@testable import App
import Vapor
import XCTest

final class AppTests: XCTestCase {
    static let allTests = [
        ("testHost", testHost)
    ]
    
    var app: Application!
    
    override func setUp() {
        app = try! Application.testable()
    }
    
    override func tearDown() {
        try? app.syncShutdownGracefully()
    }
    
    func testHost() throws {
        let tokenResponse = try app.sendRequest(to: "/users/login/abc/123", method: .POST)
        XCTAssertEqual(tokenResponse.http.status.code, 401)
    }
}
