import Foundation

public class JSONMapper {
    private var map = [String: ((Any) -> AnyObject)]()
    
    public init(){
        self.addMapping(type: String.self) { s in s as AnyObject }
        self.addMapping(type: Int.self) { s in s as AnyObject }
        self.addMapping(type: Double.self) { s in s as AnyObject }
        self.addMapping(type: Decimal.self) { s in s as AnyObject }
        self.addMapping(type: Float.self) { s in s as AnyObject }
        self.addMapping(type: Bool.self) { s in s as AnyObject }
    }
    
    public func addMapping<T>(type: T.Type,  fn: @escaping ((T) -> AnyObject)){
        map[String(describing: type)] = {a in
            fn(a as! T)
        }
    }
    
    public func applyMapping(obj: Any) -> AnyObject{
        return map[String(describing: type(of: obj))]!(obj)
    }
    
    public func hasMapping(obj: Any) -> Bool {
        return map[String(describing: type(of: obj))] != nil
    }
}

public protocol JSONSerializable {
    func serialize(serializer: JSONSerializer) -> AnyObject
}


extension Array : JSONSerializable {
    public func serialize(serializer: JSONSerializer) -> AnyObject {
        return self.map({ serializer.toObj($0)}) as AnyObject
    }
}

extension Optional : JSONSerializable {
    public func serialize(serializer: JSONSerializer) -> AnyObject  {
        if let val = self {
            return serializer.toObj(val) ?? NSNull() as AnyObject
        }
        
        return NSNull() as AnyObject
    }
}

public class JSONSerializer {
    let mapper : JSONMapper
    
    public init(mapper : JSONMapper) {
        self.mapper = mapper
    }
    
    public func toJSON(_ obj : Any) -> String? {
        //At the top level we only handle objects {} or arrays
        let validObj : Any
        if let arr = obj as? Array<Any> {
            validObj = arr.serialize(serializer: self)
        }else {
            validObj = buildDict(obj)
        }
        
        let data = try? JSONSerialization.data(withJSONObject: validObj, options: [])
        return data == nil ? nil : String(data: data!, encoding: .utf8)
    }
    
    func toObj(_ obj: Any) -> AnyObject? {
        if self.mapper.hasMapping(obj: obj) {
            return self.mapper.applyMapping(obj:obj)
        }
        
        if let serializable = obj as? JSONSerializable {
            return serializable.serialize(serializer: self)
        }
        
        return buildDict(obj) as AnyObject
    }
    
    private func buildDict(_ obj: Any) -> [String: AnyObject] {
        var result = [String: AnyObject]()
        
        for case let (label?, value) in Mirror(reflecting: obj).children {
            if let obj = toObj(value) {
                result[label.uppercaseFirst] = obj
            }
        }
        
        return result
    }
}
