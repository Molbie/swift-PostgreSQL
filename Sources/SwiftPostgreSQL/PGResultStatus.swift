import Foundation
import libpq


public enum PGResultStatus {
    case noResult
    case emptyQuery
    case commandOK
    case tuplesOK
    case badResponse
    case nonFatalError
    case fatalError
    case singleTuple
    case unknown(UInt32)
}

public extension PGResultStatus {
    init(status: ExecStatusType) {
        switch status.rawValue {
            case PGRES_EMPTY_QUERY.rawValue:
                self = .emptyQuery
            case PGRES_COMMAND_OK.rawValue:
                self = .commandOK
            case PGRES_TUPLES_OK.rawValue:
                self = .tuplesOK
            case PGRES_BAD_RESPONSE.rawValue:
                self = .badResponse
            case PGRES_NONFATAL_ERROR.rawValue:
                self = .nonFatalError
            case PGRES_FATAL_ERROR.rawValue:
                self = .fatalError
            case PGRES_SINGLE_TUPLE.rawValue:
                self = .singleTuple
            default:
                print("Unhandled PQresult status type \(status.rawValue)")
                self = .unknown(status.rawValue)
        }
    }
}
