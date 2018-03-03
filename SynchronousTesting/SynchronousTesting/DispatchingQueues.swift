import Foundation

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


extension AsyncQueue {
    static let main: AsyncQueue = AsyncQueue(queue: .main)
    static let global: AsyncQueue = AsyncQueue(queue: .global())
    static let background: AsyncQueue = AsyncQueue(queue: .global(qos: .background))
}

extension SyncQueue {
    static let main: SyncQueue = SyncQueue(queue: .main)
    static let global: SyncQueue = SyncQueue(queue: .global())
    static let background: SyncQueue = SyncQueue(queue: .global(qos: .background))
}

