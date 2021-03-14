import Foundation
import CPostgreSQL


public final class PGRow {
    internal weak var result: PGResult?
    internal let id: Int
    
    public init(result: PGResult, id: Int) {
        self.result = result
        self.id = id
    }
    
    public var count: Int {
        guard let result = result else { return 0 }
        
        return result.fieldCount
    }
    
    public subscript(fieldIndex: Int) -> PGField? {
        guard let result = result else { return nil }
        
        return PGField(result: result, rowId: id, id: fieldIndex)
    }
    
    public subscript(name: String) -> PGField? {
        let lowercaseName = name.lowercased()
        guard let index = result?.metadata.firstIndex(where: { $0.name?.lowercased() == lowercaseName }) else { return nil }
        
        return self[index]
    }
}

extension PGRow: Sequence {
    public func makeIterator() -> PGRowIterator {
        return PGRowIterator(self)
    }
}
