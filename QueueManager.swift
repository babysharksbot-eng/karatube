import Foundation
import AVFoundation

protocol QueueManagerDelegate: AnyObject {
    func queueUpdated()
}

class QueueManager {
    private var items: [URL] = []
    weak var delegate: QueueManagerDelegate?

    init() {
        // initial demo items (can be empty)
    }

    func add(url: URL) {
        items.append(url)
        delegate?.queueUpdated()
    }

    func popNext() -> URL? {
        if items.isEmpty { return nil }
        return items.removeFirst()
    }

    func allItems() -> [URL] { return items }
}
