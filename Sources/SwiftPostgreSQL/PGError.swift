import Foundation


public enum PGError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    case message(String)
    case badConnection
    case executeStatement(PGResultStatus)
    
    public var description: String {
        switch self {
            case let .message(value):
                return value
            case .badConnection:
                return "Connection status is bad"
            case let .executeStatement(status):
                return "Failed to execute statement. status: \(status)"
        }
    }
    
    public var debugDescription: String {
        return description
    }
}
