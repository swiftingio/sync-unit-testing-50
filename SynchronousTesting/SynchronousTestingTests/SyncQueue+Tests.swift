import SynchronousTesting

extension SyncQueue {
    static let stubbedMain: SyncQueue = SyncQueue(queue: DispatchQueue(label: "stubbed-main-queue"))
}
