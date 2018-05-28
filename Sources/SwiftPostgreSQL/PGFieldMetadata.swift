import Foundation
import libpq


public final class PGFieldMetadata {
    private weak var result: PGResult?
    private let field: Int32
    
    public init(result: PGResult, field: Int) {
        self.result = result
        self.field = Int32(field)
    }
    
    public var name: String? {
        guard let rawResult = result?.rawResult else { return nil }
        guard let rawName = PQfname(rawResult, field) else { return nil }
        guard let value = String(validatingUTF8: rawName) else { return nil }
        
        return value
    }
    
    public var type: PGObjectId? {
        guard let rawResult = result?.rawResult else { return nil }
        let rawType = PQftype(rawResult, field)
        
        return PGObjectId(rawValue: rawType)
    }
}
