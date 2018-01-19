//
//  JsonReader.swift
//  JsonReader
//
//  Created by Arthur MASSON on 1/19/18.
//  Copyright © 2018 Arthur MASSON. All rights reserved.
//

import Foundation

indirect enum JsonObject: CustomStringConvertible {
    case dictionnary([String: JsonObject])
    case array([JsonObject])
    case string(String)
    case number(Double)
    case boolean(Bool)
    case none
    
    init(json: Any) {
        if let dictionnary = json as? [String: Any] {
            var d: [String: JsonObject] = [:]
            for (key, value) in dictionnary {
                d[key] = JsonObject(json: value)
            }
            self = .dictionnary(d)
        } else if let array = json as? [Any] {
            var a: [JsonObject] = []
            for value in array {
                a.append(JsonObject(json: value))
            }
            self = .array(a)
        } else if let string = json as? String {
            self = .string(string)
        } else if let number = json as? Double {
            self = .number(number)
        } else if let boolean = json as? Bool {
            self = .boolean(boolean)
        } else {
            self = .none
        }
    }
    
    subscript(key: String) -> JsonObject? {
        if case let .dictionnary(d) = self {
            return d[key]
        }
        return nil
    }
    
    subscript(index: Int) -> JsonObject? {
        if case let .array(a) = self {
            if index < a.count {
                return a[index]
            }
        }
        return nil
    }
    
    var dictionnaryValue: [String: JsonObject]? {
        if case let .dictionnary(d) = self {
            return d
        }
        return nil
    }
    
    var arrayValue: [JsonObject]? {
        if case let .array(a) = self {
            return a
        }
        return nil
    }
    
    var stringValue: String? {
        if case let .string(s) = self {
            return s
        }
        return nil
    }
    
    var numberValue: Double? {
        if case let .number(n) = self {
            return n
        }
        return nil
    }
    
    var booleanValue: Bool? {
        if case let .boolean(b) = self {
            return b
        }
        return nil
    }
    
    var description: String {
        return ""
//        switch self {
//        case .dictionnary(let d):
//            dump
//        case .array(_):
//            <#code#>
//        case .string(_):
//            <#code#>
//        case .number(_):
//            <#code#>
//        case .boolean(_):
//            <#code#>
//        case .none:
//            <#code#>
//        }
    }
}

class JsonReader {
    
    var object: JsonObject
    
    init(json: Any) {
        self.object = JsonObject(json: json)
    }
}

extension JsonReader: CustomStringConvertible {
    
    var description: String {
        return object.description
    }
}
