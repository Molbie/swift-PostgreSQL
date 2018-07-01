import Foundation
import libpq


public final class PGConnection {
    public typealias Receiver = (PGResult) -> Void // process a PGResult
    public typealias Processor = (String) -> Void // process a text message
    
    private let configuration: PGConfiguration
    private var connection = OpaquePointer(bitPattern: 0)
    private var receiver: Receiver = { _ in }
    private var processor: Processor = { _ in }
    
    public var status: PGConnectionStatus {
        guard let connection = connection else { return .bad }
        let status = PQstatus(connection)
        
        return status == CONNECTION_OK ? .ok : .bad
    }
    
    public var errorMessage: String {
        return String(validatingUTF8: PQerrorMessage(connection)) ?? ""
    }
    
    public init(configuration: PGConfiguration) {
        self.configuration = configuration
    }
    
    deinit {
        close()
    }
    
    public func open() -> PGConnectionStatus {
        guard status == .bad else { return .ok }
        close()
        connection = PQconnectdb(configuration.connectionInfo)
        
        return status
    }
    
    public func close() {
        guard let connection = connection else { return }
        
        PQfinish(connection)
        self.connection = OpaquePointer(bitPattern: 0)
    }
    
    @discardableResult
    public func execute(statement: String, parameters: [Any?]? = nil) throws -> PGResult {
        try assertStatusIsOk()
        
        let result: PGResult
        if let parameters = parameters {
            result = execute(statement, parameters: parameters)
        }
        else {
            result = execute(statement)
        }
        
        let status: PGResultStatus = result.status
        switch status {
            case .emptyQuery, .commandOK, .tuplesOK:
                return result
            case .badResponse, .nonFatalError, .fatalError, .singleTuple, .unknown, .noResult:
                throw PGError.executeStatement(status, errorMessage)
        }
    }
    
    @discardableResult
    public func transaction<Result>(_ work: () throws -> Result) throws -> Result {
        try assertStatusIsOk()
        
        try execute(statement: "BEGIN")
        do {
            let result: Result = try work()
            try execute(statement: "COMMIT")
            return result
        }
        catch {
            try execute(statement: "ROLLBACK")
            throw error
        }
    }
    
    private func execute(_ statement: String) -> PGResult {
        let result = PQexec(connection, statement)
        
        return PGResult(result)
    }
    
    private func execute(_ statement: String, parameters: [Any?]) -> PGResult {
        let parsed = PGParameters(parameters)
        let result = PQexecParams(connection, statement, Int32(parsed.count), nil, parsed.values, parsed.lengths, parsed.formats, Int32(0))
        
        return PGResult(result)
    }
    
    private func assertStatusIsOk() throws {
        guard status == .ok else { throw PGError.badConnection }
    }
    
    public func setReceiver(_ handler: @escaping Receiver) -> PQnoticeReceiver? {
        guard let connection = self.connection else { return nil }
        
        self.receiver = handler
        let opaqueSelf = Unmanaged.passUnretained(self).toOpaque()
        
        return PQsetNoticeReceiver(connection, { arg, rawResult in
            guard let pointer = arg, let rawResult = rawResult else { return }
            
            let weakSelf = Unmanaged<PGConnection>.fromOpaque(pointer).takeUnretainedValue()
            let result = PGResult(rawResult, isOwner: false)
            weakSelf.receiver(result)
        }, opaqueSelf)
    }
    
    public func setProcessor(_ handler: @escaping Processor) -> PQnoticeProcessor?{
        guard let connection = self.connection else { return nil }
        
        self.processor = handler
        let opaqueSelf = Unmanaged.passUnretained(self).toOpaque()
        
        return PQsetNoticeProcessor(connection, { arg, rawResult in
            guard let pointer = arg, let rawResult = rawResult else { return }
            
            let weakSelf = Unmanaged<PGConnection>.fromOpaque(pointer).takeUnretainedValue()
            let result = String(cString: rawResult)
            weakSelf.processor(result)
        }, opaqueSelf)
    }
}
