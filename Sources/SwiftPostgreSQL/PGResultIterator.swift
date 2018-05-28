import Foundation
import libpq


public final class PGResultIterator: IteratorProtocol {
    private weak var result: PGResult?
    private var current = 0
    
    internal init(_ result: PGResult) {
        self.result = result
    }
    
    public func next() -> PGRow? {
        guard let result = result else { return nil }
        guard current < result.rowCount else { return nil }
        
        let row = current
        current += 1
        
        return PGRow(result: result, id: row)
    }
}
