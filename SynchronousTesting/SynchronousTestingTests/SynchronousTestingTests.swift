import XCTest
@testable import SynchronousTesting

class WorkerTests: XCTestCase {
    
    var sut: Worker!
    
    override func setUp() {
        super.setUp()
        sut = Worker(queue:.global())
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testDoStuffCallsCompletionHander() {
        let expectation = XCTestExpectation(description: "should call completion handler")
        sut.doStuff {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.1)
    }
}

class DispatchingWorkerTests: XCTestCase {
    
    var sut: DispatchingWorker!
    
    override func setUp() {
        super.setUp()
        sut = DispatchingWorker(queue: SyncQueue.background)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testDoStuffCallsCompletionHander() {
        sut.doStuff {
            XCTFail("Just kidding 😎! If you see this failure it means that the test was executed synchronously and this approach works as desired!")
        }
    }
}


class BackgroundToMainDispatchingWorkerTests: XCTestCase {
    typealias Worker = BackgroundToMainDispatchingWorker
    var sut: Worker!
    
    override func setUp() {
        super.setUp()
        sut = Worker(main: SyncQueue.global, background: SyncQueue.background)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testDoStuffCallsCompletionHander() {
        sut.doStuff {
            XCTFail("Just kidding 😎! If you see this failure it means that the test was executed synchronously and this approach works as desired!")
        }
    }
}
