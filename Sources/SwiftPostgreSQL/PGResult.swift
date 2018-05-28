import Foundation
import libpq


public final class PGResult {
    internal var rawResult: OpaquePointer? = OpaquePointer(bitPattern: 0)
    private var isOwner = true
    
    public var status: PGResultStatus {
        guard let result = rawResult else { return .noResult }
        let rawStatus = PQresultStatus(result)
        
        return PGResultStatus(status: rawStatus)
    }
    
    public var errorMessage: String {
        guard let result = rawResult else { return "" }
        return String(validatingUTF8: PQresultErrorMessage(result)) ?? ""
    }
    
    internal init(_ result: OpaquePointer?, isOwner: Bool = true) {
        self.rawResult = result
        self.isOwner = isOwner
    }
    
    deinit {
        close()
    }
    
    public func close() {
        guard let result = rawResult else { return }
        
        if isOwner {
            PQclear(result)
        }
        self.rawResult = OpaquePointer(bitPattern: 0)
    }
    
    // MARK: -
    // MARK: Metadata
    
    public lazy var metadata: [PGFieldMetadata] = {
        guard let rawResult = rawResult else { return [] }
        
        var result = [PGFieldMetadata]()
        for field in 0..<fieldCount {
            result.append(PGFieldMetadata(result: self, field: field))
        }
        
        return result
    }()
    
    // MARK: -
    // MARK: Rows
    
    public lazy var rowCount: Int = {
        guard let result = rawResult else { return 0 }
        
        return Int(PQntuples(result))
    }()
    
    public subscript(rowIndex: Int) -> PGRow {
        return PGRow(result: self, id: rowIndex)
    }
    
    // MARK: -
    // MARK: Fields
    
    internal lazy var fieldCount: Int = {
        guard let rawResult = rawResult else { return 0 }
        
        return Int(PQnfields(rawResult))
    }()
    
    public subscript(rowIndex: Int, fieldIndex: Int) -> PGField? {
        return self[rowIndex][fieldIndex]
    }
    
    public subscript(rowIndex: Int, fieldName: String) -> PGField? {
        return self[rowIndex][fieldName]
    }
}

extension PGResult: Sequence {
    public func makeIterator() -> PGResultIterator {
        return PGResultIterator(self)
    }
}
