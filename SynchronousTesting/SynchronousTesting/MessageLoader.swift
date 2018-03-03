import Foundation

protocol MessageLoaderProtocol {
    func load(_ callback: @escaping([Message]) -> Void )
}

class MessageLoader: MessageLoaderProtocol {
    
    var main: Dispatching
    var background: Dispatching
    
    init(main: Dispatching = AsyncQueue.main,
         background: Dispatching = AsyncQueue.background) {
        
        self.main = main
        self.background = background
        
    }
 
    func load(_ callback: @escaping([Message]) -> Void) {
        
        background.dispatch {
            
            let messages = [ Message.welcome ]
            
            sleep(1)

            self.main.dispatch {
                callback(messages)
            }
            
        }
    }
}
