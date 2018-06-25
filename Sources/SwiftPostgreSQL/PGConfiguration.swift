import Foundation


public struct PGConfiguration {
    public let database: String
    public let host: String
    public let port: Int?
    public let username: String?
    public let password: String?
    
    public var connectionInfo: String {
        var result = "host=\(host) dbname=\(database)"
        if let port = port {
            result += " port=\(port)"
        }
        if let username = username {
            result += " user=\(username)"
        }
        if let password = password {
            result += " password=\(password)"
        }
        return result
    }
    
    public init(database: String, host: String, port: Int? = nil, username: String? = nil, password: String? = nil) {
        self.database = database
        self.host = host
        self.port = port
        self.username = username
        self.password = password
    }
}
