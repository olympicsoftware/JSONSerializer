import Foundation

public protocol JSONSerializable {
    
}

protocol JSONPrimitive {
}

extension JSONSerializable {
    func toJSONString() -> String? {
        let obj = self.toJSONObj()
        
        let data =  try? JSONSerialization.data(withJSONObject: obj, options: [])
        
        return data == nil
            ? nil
            : String(data: data!, encoding: .utf8)
    }
    
    func toJSONObj() -> AnyObject {
        let obj: AnyObject
        
        // Array case
        if let arrSelf = self as? NSArray {
            obj = serializeArray(arrSelf)
        } else { // Object case
            obj = serializeObj(self)
        }
        
        return obj
    }
}

func serializeArray(_ arr : NSArray) -> AnyObject {
    return arr.map({ el -> AnyObject in
        if el is JSONPrimitive {
            return el as AnyObject
        } else if let seri = el as? JSONSerializable {
            return seri.toJSONObj()
        } else {
            return NSNull() as AnyObject
        }
    }) as AnyObject
}

func serializeObj(_ obj: JSONSerializable) -> AnyObject {
    var result = [String:AnyObject]()
    
    for case let (label?, value) in Mirror(reflecting: obj).children {
        let labelCapitalized = label.uppercaseFirst
        
        if value is JSONPrimitive {
            result[labelCapitalized] = value as AnyObject
        }
        
        if let serializable = value as? JSONSerializable {
            result[labelCapitalized] = serializable.toJSONObj()
        }
    }

    return result as AnyObject
}

// Primitives
extension String: JSONPrimitive {}
extension Int: JSONPrimitive {}
extension Bool: JSONPrimitive {}
extension Decimal: JSONPrimitive {}
extension Double: JSONPrimitive {}
extension Float: JSONPrimitive {}

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
}
