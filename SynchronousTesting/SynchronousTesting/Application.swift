import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    var window: UIWindow?
}

class ViewController: UIViewController {}

class Worker {
    let queue: DispatchQueue
    init(queue: DispatchQueue) {
        self.queue = queue
    }
    func doStuff(_ completion: @escaping ()->Void) {
        queue.async {
            sleep(1) //mock doing stuff
            completion()
        }
    }
}

protocol Dispatching {
    func dispatch(_ work: @escaping ()->Void)
}

class Dispatcher {
    let queue: DispatchQueue
    init(queue: DispatchQueue) {
        self.queue = queue
    }
}

class AsyncQueue: Dispatcher {}
extension AsyncQueue: Dispatching {
    func dispatch(_ work: @escaping ()->Void) {
        queue.async(execute: work)
    }
}

class SyncQueue: Dispatcher {}
extension SyncQueue: Dispatching {
    func dispatch(_ work: @escaping ()->Void) {
        queue.sync(execute: work)
    }
}

class DispatchingWorker {
    let queue: Dispatching
    
    init(queue: Dispatching) {
        self.queue = queue
    }
    
    func doStuff(_ completion: @escaping ()->Void) {
        queue.dispatch {
            sleep(1) //mocks doing stuff
            completion()
        }
    }
}

extension SyncQueue {
    static let main: SyncQueue = SyncQueue(queue: .main)
    static let global: SyncQueue = SyncQueue(queue: .global())
    static let background: SyncQueue = SyncQueue(queue: .global(qos: .background))
}

extension AsyncQueue {
    static let main: AsyncQueue = AsyncQueue(queue: .main)
    static let global: AsyncQueue = AsyncQueue(queue: .global())
    static let background: AsyncQueue = AsyncQueue(queue: .global(qos: .background))
}

class BackgroundWorker {
    let main: DispatchQueue
    let background: DispatchQueue
    
    init(queue: DispatchQueue) {
        self.main = .main
        self.background = queue
    }
    func doStuff(_ completion: @escaping ()->Void) {
        background.async { [unowned self] in
            sleep(1) //mocks doing stuff
            self.main.async {
                completion() //calls completion on the main thread
            }
        }
    }
}

class BackgroundToMainDispatchingWorker {
    let main: Dispatching
    let background: Dispatching
    
    init(main: Dispatching, background: Dispatching) {
        self.main = main
        self.background = background
    }
    
    func doStuff(_ completion: @escaping ()->Void) {
        background.dispatch { [unowned self] in
            sleep(1) //mocks doing stuff
            self.main.dispatch {
                completion()
            }
        }
    }
}
