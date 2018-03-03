import XCTest
@testable import SynchronousTesting

class MessageLoaderTests: XCTestCase {
    
    var sut: MessageLoader!
    
    override func setUp() {
        super.setUp()
        print(">>> Staring a test")
        sut = MessageLoader()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
        print(">>> Finished a test")
    }
    
    func testAtLeast1MessageOnLoad() {
        
        //Arrange
        print(#function, "Arrange - main thread")
        var messages: [Message] = []
        
        let background = SyncQueue.background
        let main = SyncQueue.global
        
        sut.main = main
        sut.background = background
        
        //Act
        print(#function, "Act - main thread")
        
        sut.load { fetched in
            print(#function, "callback on global thread")
            messages = fetched
            print(messages)
        }
        
        //Assert
        print(#function, "Assert - main thread")
        XCTAssertFalse(messages.isEmpty, "Messages should not be empty")
    }
}
