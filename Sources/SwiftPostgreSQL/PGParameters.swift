import Foundation
import libpq


public final class PGParameters {
    let count: Int
    let values: UnsafeMutablePointer<UnsafePointer<Int8>?>
    let types: UnsafeMutablePointer<Oid>
    let lengths: UnsafeMutablePointer<Int32>
    let formats: UnsafeMutablePointer<Int32>
    
    public init(_ parameters: [Any?]) {
        let parameterCount = parameters.count
        self.count = parameterCount
        self.values = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: parameterCount)
        self.types = UnsafeMutablePointer<Oid>.allocate(capacity: parameterCount)
        self.lengths = UnsafeMutablePointer<Int32>.allocate(capacity: parameterCount)
        self.formats = UnsafeMutablePointer<Int32>.allocate(capacity: parameterCount)
        
        parse(parameters)
    }
    
    deinit {
        values.deinitialize(count: count)
        values.deallocate()
        types.deinitialize(count: count)
        types.deallocate()
        lengths.deinitialize(count: count)
        lengths.deallocate()
        formats.deinitialize(count: count)
        formats.deallocate()
    }
    
    private func parse(_ parameters: [Any?]) {
        var rawValues = [String]()
        var rawBytes = [[UInt8]]()
        for index in 0..<count {
            switch parameters[index] {
            case let value as String:
                var terminatedValue = [UInt8](value.utf8)
                terminatedValue.append(0)
                rawBytes.append(terminatedValue)
                values[index] = UnsafePointer<Int8>(OpaquePointer(rawBytes.last!))
                types[index] = 0
                lengths[index] = 0
                formats[index] = 0
            case let value as [UInt8]:
                let length = Int32(value.count)
                values[index] = UnsafePointer<Int8>(OpaquePointer(value))
                types[index] = 17
                lengths[index] = length
                formats[index] = 1
            case let value as [Int8]:
                let length = Int32(value.count)
                values[index] = UnsafePointer<Int8>(OpaquePointer(value))
                types[index] = 17
                lengths[index] = length
                formats[index] = 1
            case let value as Data:
                let bytes = value.map { $0 }
                let length = Int32(bytes.count)
                rawBytes.append(bytes)
                values[index] = UnsafePointer<Int8>(OpaquePointer(rawBytes.last!))
                types[index] = 17
                lengths[index] = length
                formats[index] = 1
            default:
                if let parameter = parameters[index] {
                    rawValues.append("\(parameter)")
                    var terminatedValue = [UInt8](rawValues.last!.utf8)
                    terminatedValue.append(0)
                    rawBytes.append(terminatedValue)
                    values[index] = UnsafePointer<Int8>(OpaquePointer(rawBytes.last!))
                }
                else {
                    values[index] = nil
                }
                types[index] = 0
                lengths[index] = 0
                formats[index] = 0
            }
        }
    }
}
