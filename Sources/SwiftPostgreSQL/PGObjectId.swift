import Foundation
import libpq


public struct PGObjectId: RawRepresentable {
    private static let minCustomId: Oid = 16_000
    private static var _cache = [Oid: PGObjectId]()
    
    public let rawValue: Oid
    public let name: String
    public let description: String
    
    private init(rawValue: Oid, name: String, description: String) {
        self.rawValue = rawValue
        self.name = name
        self.description = description
        
        PGObjectId._cache[rawValue] = self
    }
    
    public init?(rawValue: Oid) {
        PGObjectId.updateCache()
        
        if let cache = PGObjectId._cache[rawValue] {
            self = cache
        }
        else if rawValue > PGObjectId.minCustomId {
            self = PGObjectId(rawValue: rawValue, name: "custom", description: "custom type")
        }
        else {
            print("Unhandled OID: \(rawValue)")
            return nil
        }
    }
    
    // NOTE: preload static variables in order to do a lookup by Oid
    private static var cacheLoaded = false
    private static func updateCache() {
        guard !cacheLoaded else { return }
        cacheLoaded = true
        
        let _ = numericTypes
        let _ = monetaryTypes
        let _ = characterTypes
        let _ = binaryDataTypes
        let _ = dateTimeTypes
        let _ = booleanTypes
        let _ = geometricTypes
        let _ = networkTypes
        let _ = bitStringTypes
        let _ = textSearchTypes
        let _ = uuidTypes
        let _ = xmlTypes
        let _ = jsonTypes
        let _ = objectIdTypes
        let _ = lsnTypes
        let _ = pseudoTypes
        let _ = aclTypes
        let _ = otherTypes
    }
}

// MARK: -
// MARK: Numeric Types

public extension PGObjectId {
    public static let bigInteger =                      PGObjectId(rawValue: 00_020, name: "int8", description: "~18 digit integer, 8-byte storage")
    public static let bigIntegerArray =                 PGObjectId(rawValue: 01_016, name: "_int8", description: "array of ~18 digit integer, 8-byte storage")
    public static let bigIntegerRange =                 PGObjectId(rawValue: 03_926, name: "int8range", description: "range of bigints")
    public static let bigIntegerRangeArray =            PGObjectId(rawValue: 03_927, name: "_int8range", description: "array of range of bigints")
    public static let double =                          PGObjectId(rawValue: 00_701, name: "float8", description: "double-precision floating point number, 8-byte storage")
    public static let doubleArray =                     PGObjectId(rawValue: 01_022, name: "_float8", description: "array of double-precision floating point number, 8-byte storage")
    public static let integer =                         PGObjectId(rawValue: 00_023, name: "int4", description: "-2 billion to 2 billion integer, 4-byte storage")
    public static let integerArray =                    PGObjectId(rawValue: 01_007, name: "_int4", description: "array of -2 billion to 2 billion integer, 4-byte storage")
    public static let integerRange =                    PGObjectId(rawValue: 03_904, name: "int4range", description: "range of integers")
    public static let integerRangeArray =               PGObjectId(rawValue: 03_905, name: "_int4range", description: "array of range of integers")
    public static let numeric =                         PGObjectId(rawValue: 01_700, name: "numeric", description: "numeric(precision, decimal), arbitrary precision number")
    public static let numericArray =                    PGObjectId(rawValue: 01_231, name: "_numeric", description: "array of numeric(precision, decimal), arbitrary precision number")
    public static let numericRange =                    PGObjectId(rawValue: 03_906, name: "numrange", description: "range of numerics")
    public static let numericRangeArray =               PGObjectId(rawValue: 03_907, name: "_numrange", description: "array of range of numerics")
    public static let real =                            PGObjectId(rawValue: 00_700, name: "float4", description: "single-precision floating point number, 4-byte storage")
    public static let realArray =                       PGObjectId(rawValue: 01_021, name: "_float4", description: "array of single-precision floating point number, 4-byte storage")
    public static let smallInteger =                    PGObjectId(rawValue: 00_021, name: "int2", description: "-32 thousand to 32 thousand, 2-byte storage")
    public static let smallIntegerArray =               PGObjectId(rawValue: 01_005, name: "_int2", description: "array of -32 thousand to 32 thousand, 2-byte storage")
    public static let smallIntegerVector =              PGObjectId(rawValue: 00_022, name: "int2vector", description: "array of int2, used in system tables")
    public static let smallIntegerVectorArray =         PGObjectId(rawValue: 01_006, name: "_int2vector", description: "array of array of int2, used in system tables")
    
    private static var numericTypes: [PGObjectId] {
        return [.bigInteger,
                .bigIntegerArray,
                .bigIntegerRange,
                .bigIntegerRangeArray,
                .double,
                .doubleArray,
                .integer,
                .integerArray,
                .integerRange,
                .integerRangeArray,
                .numeric,
                .numericArray,
                .numericRange,
                .numericRangeArray,
                .real,
                .realArray,
                .smallInteger,
                .smallIntegerArray,
                .smallIntegerVector,
                .smallIntegerVectorArray]
    }
}

// MARK: -
// MARK: Monetary Types

public extension PGObjectId {
    public static let money =                           PGObjectId(rawValue: 00_790, name: "money", description: "monetary amounts, $d,ddd.cc")
    public static let moneyArray =                      PGObjectId(rawValue: 00_791, name: "_money", description: "array of monetary amounts, $d,ddd.cc")
    
    private static var monetaryTypes: [PGObjectId] {
        return [.money,
                .moneyArray]
    }
}

// MARK: -
// MARK: Character Types

public extension PGObjectId {
    public static let character =                       PGObjectId(rawValue: 00_018, name: "char", description: "single character")
    public static let characterArray =                  PGObjectId(rawValue: 01_002, name: "_char", description: "array of single character")
    public static let name =                            PGObjectId(rawValue: 00_019, name: "name", description: "63-byte type for storing system identifiers")
    public static let nameArray =                       PGObjectId(rawValue: 01_003, name: "_name", description: "array of 63-byte type for storing system identifiers")
    public static let paddedCharacter =                 PGObjectId(rawValue: 01_042, name: "bpchar", description: "char(length), blank-padded string, fixed storage length")
    public static let paddedCharacterArray =            PGObjectId(rawValue: 01_014, name: "_bpchar", description: "array of char(length), blank-padded string, fixed storage length")
    public static let text =                            PGObjectId(rawValue: 00_025, name: "text", description: "variable-length string, no limit specified")
    public static let textArray =                       PGObjectId(rawValue: 01_009, name: "_text", description: "array of variable-length string, no limit specified")
    public static let variableCharacter =               PGObjectId(rawValue: 01_043, name: "varchar", description: "varchar(length), non-blank-padded string, variable storage length")
    public static let variableCharacterArray =          PGObjectId(rawValue: 01_015, name: "_varchar", description: "array of varchar(length), non-blank-padded string, variable storage length")
    
    private static var characterTypes: [PGObjectId] {
        return [.character,
                .characterArray,
                .name,
                .nameArray,
                .paddedCharacter,
                .paddedCharacterArray,
                .text,
                .textArray,
                .variableCharacter,
                .variableCharacterArray]
    }
}

// MARK: -
// MARK: Binary Data Types

public extension PGObjectId {
    public static let byteArray =                       PGObjectId(rawValue: 00_017, name: "bytea", description: "variable-length string, binary values escaped")
    public static let byteArrayArray =                  PGObjectId(rawValue: 01_001, name: "_bytea", description: "array of variable-length string, binary values escaped")
    
    private static var binaryDataTypes: [PGObjectId] {
        return [.byteArray,
                .byteArrayArray]
    }
}

// MARK: -
// MARK: Date/Time Types

public extension PGObjectId {
    public static let date =                            PGObjectId(rawValue: 01_082, name: "date", description: "date")
    public static let dateArray =                       PGObjectId(rawValue: 01_182, name: "_date", description: "array of date")
    public static let dateRange =                       PGObjectId(rawValue: 03_912, name: "daterange", description: "range of dates")
    public static let dateRangeArray =                  PGObjectId(rawValue: 03_913, name: "_daterange", description: "array of range of dates")
    public static let interval =                        PGObjectId(rawValue: 01_186, name: "interval", description: "@ <number> <units>, time interval")
    public static let intervalArray =                   PGObjectId(rawValue: 01_187, name: "_interval", description: "array of @ <number> <units>, time interval")
    public static let time =                            PGObjectId(rawValue: 01_083, name: "time", description: "time of day")
    public static let timeArray =                       PGObjectId(rawValue: 01_183, name: "_time", description: "array of time of day")
    public static let timeInterval =                    PGObjectId(rawValue: 00_704, name: "tinterval", description: "(abstime,abstime), time interval")
    public static let timeIntervalArray =               PGObjectId(rawValue: 01_025, name: "_tinterval", description: "array of (abstime,abstime), time interval")
    public static let timestamp =                       PGObjectId(rawValue: 01_114, name: "timestamp", description: "date and time")
    public static let timestampArray =                  PGObjectId(rawValue: 01_115, name: "_timestamp", description: "array of date and time")
    public static let timestampRange =                  PGObjectId(rawValue: 03_908, name: "tsrange", description: "range of timestamps without time zone")
    public static let timestampRangeArray =             PGObjectId(rawValue: 03_909, name: "_tsrange", description: "array of range of timestamps without time zone")
    public static let timestampWithTimezone =           PGObjectId(rawValue: 01_184, name: "timestamptz", description: "date and time with time zone")
    public static let timestampWithTimezoneArray =      PGObjectId(rawValue: 01_185, name: "_timestamptz", description: "array of date and time with time zone")
    public static let timestampWithTimezoneRange =      PGObjectId(rawValue: 03_910, name: "tstzrange", description: "range of timestamps with time zone")
    public static let timestampWithTimezoneRangeArray = PGObjectId(rawValue: 03_911, name: "_tstzrange", description: "array of range of timestamps with time zone")
    public static let timeWithTimezone =                PGObjectId(rawValue: 01_266, name: "timetz", description: "time of day with time zone")
    public static let timeWithTimezoneArray =           PGObjectId(rawValue: 01_270, name: "_timetz", description: "array of time of day with time zone")
    public static let unixTime =                        PGObjectId(rawValue: 00_702, name: "abstime", description: "absolute, limited-range date and time (Unix system time)")
    public static let unixTimeArray =                   PGObjectId(rawValue: 01_023, name: "_abstime", description: "array of absolute, limited-range date and time (Unix system time)")
    public static let unixTimeOffset =                  PGObjectId(rawValue: 00_703, name: "reltime", description: "relative, limited-range time interval (Unix delta time)")
    public static let unixTimeOffsetArray =             PGObjectId(rawValue: 01_024, name: "_reltime", description: "array of relative, limited-range time interval (Unix delta time)")
    
    private static var dateTimeTypes: [PGObjectId] {
        return [.date,
                .dateArray,
                .dateRange,
                .dateRangeArray,
                .interval,
                .intervalArray,
                .time,
                .timeArray,
                .timeInterval,
                .timeIntervalArray,
                .timestamp,
                .timestampArray,
                .timestampRange,
                .timestampRangeArray,
                .timestampWithTimezone,
                .timestampWithTimezoneArray,
                .timestampWithTimezoneRange,
                .timestampWithTimezoneRangeArray,
                .timeWithTimezone,
                .timeWithTimezoneArray,
                .unixTime,
                .unixTimeArray,
                .unixTimeOffset,
                .unixTimeOffsetArray]
    }
}

// MARK: -
// MARK: Boolean Type

public extension PGObjectId {
    public static let boolean =                         PGObjectId(rawValue: 00_016, name: "bool", description: "boolean, 'true'/'false'")
    public static let booleanArray =                    PGObjectId(rawValue: 01_000, name: "_bool", description: "array of boolean, 'true'/'false'")
    
    private static var booleanTypes: [PGObjectId] {
        return [.boolean,
                .booleanArray]
    }
}

// MARK: -
// MARK: Geometric Types

public extension PGObjectId {
    public static let box =                             PGObjectId(rawValue: 00_603, name: "box", description: "geometric box '(lower left,upper right)'")
    public static let boxArray =                        PGObjectId(rawValue: 01_020, name: "_box", description: "array of geometric box '(lower left,upper right)'")
    public static let circle =                          PGObjectId(rawValue: 00_718, name: "circle", description: "geometric circle '(center,radius)'")
    public static let circleArray =                     PGObjectId(rawValue: 00_719, name: "_circle", description: "array of geometric circle '(center,radius)'")
    public static let line =                            PGObjectId(rawValue: 00_628, name: "line", description: "geometric line")
    public static let lineArray =                       PGObjectId(rawValue: 00_629, name: "_line", description: "array of geometric line")
    public static let lineSegment =                     PGObjectId(rawValue: 00_601, name: "lseg", description: "geometric line segment '(pt1,pt2)'")
    public static let lineSegmentArray =                PGObjectId(rawValue: 01_018, name: "_lseg", description: "array of geometric line segment '(pt1,pt2)'")
    public static let path =                            PGObjectId(rawValue: 00_602, name: "path", description: "geometric path '(pt1,...)'")
    public static let pathArray =                       PGObjectId(rawValue: 01_019, name: "_path", description: "array of geometric path '(pt1,...)'")
    public static let point =                           PGObjectId(rawValue: 00_600, name: "point", description: "geometric point '(x, y)'")
    public static let pointArray =                      PGObjectId(rawValue: 01_017, name: "_point", description: "array of geometric point '(x, y)'")
    public static let polygon =                         PGObjectId(rawValue: 00_604, name: "polygon", description: "geometric polygon '(pt1,...)'")
    public static let polygonArray =                    PGObjectId(rawValue: 01_027, name: "_polygon", description: "array of geometric polygon '(pt1,...)'")
    
    private static var geometricTypes: [PGObjectId] {
        return [.box,
                .boxArray,
                .circle,
                .circleArray,
                .line,
                .lineArray,
                .lineSegment,
                .lineSegmentArray,
                .path,
                .pathArray,
                .point,
                .pointArray,
                .polygon,
                .polygonArray]
    }
}

// MARK: -
// MARK: Network Address Types

public extension PGObjectId {
    public static let cidr =                            PGObjectId(rawValue: 00_650, name: "cidr", description: "network IP address/netmask, network address")
    public static let cidrArray =                       PGObjectId(rawValue: 00_651, name: "_cidr", description: "array of network IP address/netmask, network address")
    public static let ipAddress =                       PGObjectId(rawValue: 00_869, name: "inet", description: "IP address/netmask, host address, netmask optional")
    public static let ipAddressArray =                  PGObjectId(rawValue: 01_041, name: "_inet", description: "array of IP address/netmask, host address, netmask optional")
    public static let ipv4MacAddress =                  PGObjectId(rawValue: 00_829, name: "macaddr", description: "XX:XX:XX:XX:XX:XX, MAC address")
    public static let ipv4MacAddressArray =             PGObjectId(rawValue: 01_040, name: "_macaddr", description: "array of XX:XX:XX:XX:XX:XX, MAC address")
    public static let ipv6MacAddress =                  PGObjectId(rawValue: 00_774, name: "macaddr8", description: "XX:XX:XX:XX:XX:XX:XX:XX, MAC address")
    public static let ipv6MacAddressArray =             PGObjectId(rawValue: 00_775, name: "_macaddr8", description: "array of XX:XX:XX:XX:XX:XX:XX:XX, MAC address")
    
    private static var networkTypes: [PGObjectId] {
        return [.cidr,
                .cidrArray,
                .ipAddress,
                .ipAddressArray,
                .ipv4MacAddress,
                .ipv4MacAddressArray,
                .ipv6MacAddress,
                .ipv6MacAddressArray]
    }
}

// MARK: -
// MARK: Bit String Types

public extension PGObjectId {
    public static let bitString =                       PGObjectId(rawValue: 01_560, name: "bit", description: "fixed-length bit string")
    public static let bitStringArray =                  PGObjectId(rawValue: 01_561, name: "_bit", description: "array of fixed-length bit string")
    public static let variableBitString =               PGObjectId(rawValue: 01_562, name: "varbit", description: "variable-length bit string")
    public static let variableBitStringArray =          PGObjectId(rawValue: 01_563, name: "_varbit", description: "array of variable-length bit string")
    
    private static var bitStringTypes: [PGObjectId] {
        return [.bitString,
                .bitStringArray,
                .variableBitString,
                .variableBitStringArray]
    }
}

// MARK: -
// MARK: Text Search Types

public extension PGObjectId {
    public static let textSearchQuery =                 PGObjectId(rawValue: 03_615, name: "tsquery", description: "query representation for text search")
    public static let textSearchQueryArray =            PGObjectId(rawValue: 03_645, name: "_tsquery", description: "array of query representation for text search")
    public static let textSearchVector =                PGObjectId(rawValue: 03_614, name: "tsvector", description: "text representation for text search")
    public static let textSearchVectorArray =           PGObjectId(rawValue: 03_643, name: "_tsvector", description: "array of text representation for text search")
    public static let textSearchVectorGist =            PGObjectId(rawValue: 03_642, name: "gtsvector", description: "GiST index internal text representation for text search")
    public static let textSearchVectorGistArray =       PGObjectId(rawValue: 03_644, name: "_gtsvector", description: "array of GiST index internal text representation for text search")
    
    private static var textSearchTypes: [PGObjectId] {
        return [.textSearchQuery,
                .textSearchQueryArray,
                .textSearchVector,
                .textSearchVectorArray,
                .textSearchVectorGist,
                .textSearchVectorGistArray]
    }
}

// MARK: -
// MARK: UUID Type

public extension PGObjectId {
    public static let uuid =                            PGObjectId(rawValue: 02_950, name: "uuid", description: "UUID datatype")
    public static let uuidArray =                       PGObjectId(rawValue: 02_951, name: "_uuid", description: "array of UUID datatype")
    
    private static var uuidTypes: [PGObjectId] {
        return [.uuid,
                .uuidArray]
    }
}

// MARK: -
// MARK: XML Type

public extension PGObjectId {
    public static let xml =                             PGObjectId(rawValue: 00_142, name: "xml", description: "XML content")
    public static let xmlArray =                        PGObjectId(rawValue: 00_143, name: "_xml", description: "array of XML content")
    
    private static var xmlTypes: [PGObjectId] {
        return [.xml,
                .xmlArray]
    }
}

// MARK: -
// MARK: JSON Types

public extension PGObjectId {
    public static let json =                            PGObjectId(rawValue: 00_114, name: "json", description: "JSON content")
    public static let jsonArray =                       PGObjectId(rawValue: 00_199, name: "_json", description: "array of JSON content")
    public static let jsonBinary =                      PGObjectId(rawValue: 03_802, name: "jsonb", description: "Binary JSON")
    public static let jsonBinaryArray =                 PGObjectId(rawValue: 03_807, name: "_jsonb", description: "array of Binary JSON")
    
    private static var jsonTypes: [PGObjectId] {
        return [.json,
                .jsonArray,
                .jsonBinary,
                .jsonBinaryArray]
    }
}

// MARK: -
// MARK: Object Identifier Types

public extension PGObjectId {
    public static let `class` =                         PGObjectId(rawValue: 02_205, name: "regclass", description: "registered class")
    public static let classArray =                      PGObjectId(rawValue: 02_210, name: "_regclass", description: "array of registered class")
    public static let commandId =                       PGObjectId(rawValue: 00_029, name: "cid", description: "command identifier type, sequence in transaction id")
    public static let commandIdArray =                  PGObjectId(rawValue: 01_012, name: "_cid", description: "array of command identifier type, sequence in transaction id")
    public static let namespace =                       PGObjectId(rawValue: 04_089, name: "regnamespace", description: "registered namespace")
    public static let namespaceArray =                  PGObjectId(rawValue: 04_090, name: "_regnamespace", description: "array of registered namespace")
    public static let objectId =                        PGObjectId(rawValue: 00_026, name: "oid", description: "object identifier(oid), maximum 4 billion")
    public static let objectIdArray =                   PGObjectId(rawValue: 01_028, name: "_oid", description: "array of object identifier(oid), maximum 4 billion")
    public static let objectIdVector =                  PGObjectId(rawValue: 00_030, name: "oidvector", description: "array of oids, used in system tables")
    public static let objectIdVectorArray =             PGObjectId(rawValue: 01_013, name: "_oidvector", description: "array of array of oids, used in system tables")
    public static let `operator` =                      PGObjectId(rawValue: 02_203, name: "regoper", description: "registered operator")
    public static let operatorArray =                   PGObjectId(rawValue: 02_208, name: "_regoper", description: "array of registered operator")
    public static let operatorWithArguments =           PGObjectId(rawValue: 02_204, name: "regoperator", description: "registered operator (with args)")
    public static let operatorWithArgumentsArray =      PGObjectId(rawValue: 02_209, name: "_regoperator", description: "array of registered operator (with args)")
    public static let procedure =                       PGObjectId(rawValue: 00_024, name: "regproc", description: "registered procedure")
    public static let procedureArray =                  PGObjectId(rawValue: 01_008, name: "_regproc", description: "array of registered procedure")
    public static let procedureWithArguments =          PGObjectId(rawValue: 02_202, name: "regprocedure", description: "registered procedure (with args)")
    public static let procedureWithArgumentsArray =     PGObjectId(rawValue: 02_207, name: "_regprocedure", description: "array of registered procedure (with args)")
    public static let role =                            PGObjectId(rawValue: 04_096, name: "regrole", description: "registered role")
    public static let roleArray =                       PGObjectId(rawValue: 04_097, name: "_regrole", description: "array of registered role")
    public static let textSearchConfiguration =         PGObjectId(rawValue: 03_734, name: "regconfig", description: "registered text search configuration")
    public static let textSearchConfigurationArray =    PGObjectId(rawValue: 03_735, name: "_regconfig", description: "array of registered text search configuration")
    public static let textSearchDictionary =            PGObjectId(rawValue: 03_769, name: "regdictionary", description: "registered text search dictionary")
    public static let textSearchDictionaryArray =       PGObjectId(rawValue: 03_770, name: "_regdictionary", description: "array of registered text search dictionary")
    public static let transactionId =                   PGObjectId(rawValue: 00_028, name: "xid", description: "transaction id")
    public static let transactionIdArray =              PGObjectId(rawValue: 01_011, name: "_xid", description: "array of transaction id")
    public static let transactionIdSnapshot =           PGObjectId(rawValue: 02_970, name: "txid_snapshot", description: "txid snapshot")
    public static let transactionIdSnapshotArray =      PGObjectId(rawValue: 02_949, name: "_txid_snapshot", description: "array of txid snapshot")
    public static let tupleId =                         PGObjectId(rawValue: 00_027, name: "tid", description: "(block, offset), physical location of tuple")
    public static let tupleIdArray =                    PGObjectId(rawValue: 01_010, name: "_tid", description: "array of (block, offset), physical location of tuple")
    public static let type =                            PGObjectId(rawValue: 02_206, name: "regtype", description: "registered type")
    public static let typeArray =                       PGObjectId(rawValue: 02_211, name: "_regtype", description: "array of registered type")
    
    private static var objectIdTypes: [PGObjectId] {
        return [.class,
                .classArray,
                .commandId,
                .commandIdArray,
                .namespace,
                .namespaceArray,
                .objectId,
                .objectIdArray,
                .objectIdVector,
                .objectIdVectorArray,
                .operator,
                .operatorArray,
                .operatorWithArguments,
                .operatorWithArgumentsArray,
                .procedure,
                .procedureArray,
                .procedureWithArguments,
                .procedureWithArgumentsArray,
                .role,
                .roleArray,
                .textSearchConfiguration,
                .textSearchConfigurationArray,
                .textSearchDictionary,
                .textSearchDictionaryArray,
                .transactionId,
                .transactionIdArray,
                .transactionIdSnapshot,
                .transactionIdSnapshotArray,
                .tupleId,
                .tupleIdArray,
                .type,
                .typeArray]
    }
}

// MARK: -
// MARK: LSN Type

public extension PGObjectId {
    public static let logSequenceNumber =               PGObjectId(rawValue: 03_220, name: "pg_lsn", description: "PostgreSQL LSN datatype")
    public static let logSequenceNumberArray =          PGObjectId(rawValue: 03_221, name: "_pg_lsn", description: "array of PostgreSQL LSN datatype")
    
    private static var lsnTypes: [PGObjectId] {
        return [.logSequenceNumber,
                .logSequenceNumberArray]
    }
}

// MARK: -
// MARK: Pseudo-Types

public extension PGObjectId {
    public static let any =                             PGObjectId(rawValue: 02_276, name: "any", description: "any")
    public static let anyArray =                        PGObjectId(rawValue: 02_277, name: "anyarray", description: "anyarray")
    public static let anyElement =                      PGObjectId(rawValue: 02_283, name: "anyelement", description: "anyelement")
    public static let anyEnum =                         PGObjectId(rawValue: 03_500, name: "anyenum", description: "anyenum")
    public static let anyNonArray =                     PGObjectId(rawValue: 02_776, name: "anynonarray", description: "anynonarray")
    public static let anyRange =                        PGObjectId(rawValue: 03_831, name: "anyrange", description: "anyrange")
    public static let collectedCommand =                PGObjectId(rawValue: 00_032, name: "pg_ddl_command", description: "internal type for passing CollectedCommand")
    public static let cString =                         PGObjectId(rawValue: 02_275, name: "cstring", description: "cstring")
    public static let cStringArray =                    PGObjectId(rawValue: 01_263, name: "_cstring", description: "array of cstring")
    public static let eventTrigger =                    PGObjectId(rawValue: 03_838, name: "event_trigger", description: "event trigger")
    public static let foreignDataWrapperHandler =       PGObjectId(rawValue: 03_115, name: "fdw_handler", description: "foreign data wrapper handler")
    public static let indexAccessMethodHandler =        PGObjectId(rawValue: 00_325, name: "index_am_handler", description: "index access method handler")
    public static let `internal` =                      PGObjectId(rawValue: 02_281, name: "internal", description: "internal")
    public static let languageHandler =                 PGObjectId(rawValue: 02_280, name: "language_handler", description: "language handler")
    public static let opaque =                          PGObjectId(rawValue: 02_282, name: "opaque", description: "opaque")
    public static let record =                          PGObjectId(rawValue: 02_249, name: "record", description: "record")
    public static let recordArray =                     PGObjectId(rawValue: 02_287, name: "_record", description: "array of record")
    public static let tableSampleMethodHandler =        PGObjectId(rawValue: 03_310, name: "tsm_handler", description: "table sample method handler")
    public static let trigger =                         PGObjectId(rawValue: 02_279, name: "trigger", description: "trigger")
    public static let unknown =                         PGObjectId(rawValue: 00_705, name: "unknown", description: "unknown")
    public static let void =                            PGObjectId(rawValue: 02_278, name: "void", description: "void")
    
    private static var pseudoTypes: [PGObjectId] {
        return [.any,
                .anyArray,
                .anyElement,
                .anyEnum,
                .anyNonArray,
                .anyRange,
                .collectedCommand,
                .cString,
                .cStringArray,
                .eventTrigger,
                .foreignDataWrapperHandler,
                .indexAccessMethodHandler,
                .internal,
                .languageHandler,
                .opaque,
                .record,
                .recordArray,
                .tableSampleMethodHandler,
                .trigger,
                .unknown,
                .void]
    }
}

// MARK: -
// MARK: ACL type

public extension PGObjectId {
    public static let aclItem =                         PGObjectId(rawValue: 01_033, name: "aclitem", description: "access control list")
    public static let aclItemArray =                    PGObjectId(rawValue: 01_034, name: "_aclitem", description: "array of access control list")
    
    private static var aclTypes: [PGObjectId] {
        return [.aclItem,
                .aclItemArray]
    }
}

// MARK: -
// MARK: Other

public extension PGObjectId {
    public static let cursor =                          PGObjectId(rawValue: 01_790, name: "refcursor", description: "reference to cursor (portal name)")
    public static let cursorArray =                     PGObjectId(rawValue: 02_201, name: "_refcursor", description: "array of reference to cursor (portal name)")
    public static let dependencies =                    PGObjectId(rawValue: 03_402, name: "pg_dependencies", description: "multivariate dependencies")
    public static let ndistinctCoefficients =           PGObjectId(rawValue: 03_361, name: "pg_ndistinct", description: "multivariate ndistinct coefficients")
    public static let nodeTree =                        PGObjectId(rawValue: 00_194, name: "pg_node_tree", description: "string representing an internal node tree")
    public static let storageManager =                  PGObjectId(rawValue: 00_210, name: "smgr", description: "storage manager")
    
    private static var otherTypes: [PGObjectId] {
        return [.cursor,
                .cursorArray,
                .dependencies,
                .ndistinctCoefficients,
                .nodeTree,
                .storageManager]
    }
}

// MARK: -
// MARK: SQL

//SELECT t.oid AS "Oid",
//       t.typname AS "Name",
//       obj_description(t.oid, 'pg_type') AS "Description",
//       t.typinput AS "Input"
//FROM pg_type AS t
//WHERE (t.typrelid = 0
//       OR (SELECT c.relkind = 'c'
//           FROM pg_catalog.pg_class c
//           WHERE c.oid = t.typrelid))
//      AND pg_type_is_visible(t.oid)
//ORDER BY 1, 2;
