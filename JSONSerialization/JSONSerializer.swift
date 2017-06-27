import Foundation

public protocol JSONSerializable {
    
}

protocol JSONPrimitive {
}

extension JSONSerializable {
    func toJSONString() -> String? {
        let obj: Any
        
        // Array case
        if self is NSArray {
            obj = []
        } else { // Object case
            obj = [:]
        }
        
        let data =  try? JSONSerialization.data(withJSONObject: obj, options: [])
        
        return data == nil ? nil : String(data: data!, encoding: .utf8)
    }
}

// Primitives
extension String: JSONPrimitive {}
extension Int: JSONPrimitive {}
extension Bool: JSONPrimitive {}
extension Decimal: JSONPrimitive {}
extension Double: JSONPrimitive {}
extension Float: JSONPrimitive {}
