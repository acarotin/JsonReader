//
//  JsonReader.swift
//  JsonReader
//
//  Created by Arthur MASSON on 1/19/18.
//  Copyright © 2018 Arthur MASSON. All rights reserved.
//

import Foundation

indirect enum JsonObject {
    case dictionnary([String: JsonObject])
    case array([JsonObject])
    case string(String)
    case integer(Int)
    case float(Double)
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
        } else if let integer = json as? Int {
            self = .integer(integer)
        } else if let float = json as? Double {
            self = .float(float)
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
    
    var integerValue: Int? {
        if case let .integer(i) = self {
            return i
        }
        return nil
    }
    
    var floatValue: Double? {
        if case let .float(f) = self {
            return f
        }
        return nil
    }
    
    var booleanValue: Bool? {
        if case let .integer(i) = self {
			return i != 0
		}
        return nil
    }
    
    var isNull: Bool {
        if case .none = self {
            return true
        }
        return false
    }
}

extension JsonObject: CustomStringConvertible {
	
	func description(offsetMargin n: Int) -> String {
		let oneMargin = "  "
		let margin = String(repeating: oneMargin, count: n)
		var out = ""
		switch self {
		case .dictionnary(let d):
			out += "{\n"
			for (offset: i, element: (key: key, value: value)) in d.enumerated() {
				out += margin + oneMargin + "\"\(key)\" : " + value.description(offsetMargin: n + 1) + (i + 1 == d.count ? "\n" : ",\n")
			}
			out += margin + "}"
		case .array(let a):
			out += "[\n"
			for (i, value) in a.enumerated() {
				out += margin + oneMargin + value.description(offsetMargin: n + 1) + (i + 1 == a.count ? "\n" : ",\n")
			}
			out += margin + "]"
		case .string(let s):
			out += "\"\(s)\""
		case .integer(let i):
			out += "\(i)"
		case .float(let f):
			out += "\(f)"
		case .none:
			out += "null"
		}
		return out
	}
	
	var description: String {
		return description(offsetMargin: 0)
	}
    
}

extension JsonObject: Equatable {
    
    static func ==(lhs: JsonObject, rhs: JsonObject) -> Bool {
        switch lhs {
        case .dictionnary(let ld):
            if case let .dictionnary(rd) = rhs {
                return ld == rd
            } else {
                return false
            }
        case .array(let la):
            if case let .array(ra) = rhs {
                return la == ra
            } else {
                return false
            }
        case .string(let ls):
            if case let .string(rs) = rhs {
                return ls == rs
            } else {
                return false
            }
        case .integer(let li):
            if case let .integer(ri) = rhs {
                return li == ri
            } else {
                return false
            }
        case .float(let lf):
            if case let .float(rf) = rhs {
                return lf == rf
            } else {
                return false
            }
        case .none:
            if case .none = rhs {
                return true
            } else {
                return false
            }
        }
    }
    
}
