import Foundation
import libpq


public final class PGField {
    private weak var result: PGResult?
    private let rowId: Int32
    private let id: Int32
    
    internal init(result: PGResult, rowId: Int, id: Int) {
        self.result = result
        self.rowId = Int32(rowId)
        self.id = Int32(id)
    }
    
    public var isNull: Bool {
        guard let rawResult = result?.rawResult else { return true }
        
        return 1 == PQgetisnull(rawResult, rowId, id)
    }
    
    public var stringValue: String? {
        guard !isNull else { return nil }
        guard let rawResult = result?.rawResult else { return nil }
        guard let rawValue = PQgetvalue(rawResult, rowId, id) else { return nil }
        
        return String(validatingUTF8: rawValue)
    }
    
    public var intValue: Int? {
        guard let rawValue = stringValue else { return nil }
        
        return Int(rawValue)
    }
    
    public var boolValue: Bool? {
        guard let rawValue = stringValue else { return nil }
        
        return rawValue == "t"
    }
    
    public var int8Value: Int8? {
        guard let rawValue = stringValue else { return nil }
        
        return Int8(rawValue)
    }
    
    public var int16Value: Int16? {
        guard let rawValue = stringValue else { return nil }
        
        return Int16(rawValue)
    }
    
    public var int32Value: Int32? {
        guard let rawValue = stringValue else { return nil }
        
        return Int32(rawValue)
    }
    
    public var int64Value: Int64? {
        guard let rawValue = stringValue else { return nil }
        
        return Int64(rawValue)
    }
    
    public var doubleValue: Double? {
        guard let rawValue = stringValue else { return nil }
        
        return Double(rawValue)
    }
    
    public var floatValue: Float? {
        guard let rawValue = stringValue else { return nil }
        
        return Float(rawValue)
    }
    
    public var blobValue: [Int8]? {
        guard let rawValue = stringValue else { return nil }
        
        let cValue = rawValue.utf8
        guard cValue.count % 2 == 0, cValue.count >= 2, rawValue[rawValue.startIndex] == "\\", rawValue[rawValue.index(after: rawValue.startIndex)] == "x" else {
            return nil
        }
        
        var result = [Int8]()
        var index = cValue.index(cValue.startIndex, offsetBy: 2)
        while index != cValue.endIndex {
            let c1 = Int8(cValue[index])
            index = cValue.index(after: index)
            let c2 = Int8(cValue[index])
            guard let byte = byteFromHexDigits(one: c1, two: c2) else { return nil }
            result.append(byte)
            index = cValue.index(after: index)
        }
        
        return result
    }
    
    private func byteFromHexDigits(one c1v: Int8, two c2v: Int8) -> Int8? {
        let capA: Int8 = 65
        let capF: Int8 = 70
        let lowA: Int8 = 97
        let lowF: Int8 = 102
        let zero: Int8 = 48
        let nine: Int8 = 57
        
        var newChar = Int8(0)
        
        if c1v >= capA && c1v <= capF {
            newChar = c1v - capA + 10
        }
        else if c1v >= lowA && c1v <= lowF {
            newChar = c1v - lowA + 10
        }
        else if c1v >= zero && c1v <= nine {
            newChar = c1v - zero
        }
        else {
            return nil
        }
        
        newChar *= 16
        
        if c2v >= capA && c2v <= capF {
            newChar += c2v - capA + 10
        }
        else if c2v >= lowA && c2v <= lowF {
            newChar += c2v - lowA + 10
        }
        else if c2v >= zero && c2v <= nine {
            newChar += c2v - zero
        }
        else {
            return nil
        }
        
        return newChar
    }
}
