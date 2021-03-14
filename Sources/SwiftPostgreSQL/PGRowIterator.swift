import Foundation
import CPostgreSQL


public final class PGRowIterator: IteratorProtocol {
    private weak var row: PGRow?
    private var current = 0
    
    internal init(_ row: PGRow) {
        self.row = row
    }
    
    public func next() -> PGField? {
        guard let row = row else { return nil }
        guard let rawResult = row.result else { return nil }
        guard current < row.count else { return nil }
        
        let fieldId = current
        current += 1
        
        return PGField(result: rawResult, rowId: row.id, id: fieldId)
    }
}
