import Foundation

class JSONMapper {
    private var map = [String: ((Any) -> AnyObject)]()
    
    func addMapping<T>(type: T.Type,  fn: @escaping ((T) -> AnyObject)){
        map[String(describing: type)] = {a in
            fn(a as! T)
        }
    }
    
    func applyMapping(obj: Any) -> AnyObject{
        return map[String(describing: type(of: obj))]!(obj)
    }
    
    func hasMapping(obj: Any) -> Bool {
        return map[String(describing: type(of: obj))] != nil
    }
}

protocol JSONSerializable {
    func serialize(serializer: JSONSerializer) -> AnyObject
}


extension NSArray : JSONSerializable {
    func serialize(serializer: JSONSerializer) -> AnyObject {
        return self.map({ serializer.toObj($0)}) as AnyObject
    }
}

extension Optional : JSONSerializable {
    func serialize(serializer: JSONSerializer) -> AnyObject  {
        if let val = self {
            return serializer.toObj(val)
        }
        
        return NSNull() as AnyObject
    }
}

class JSONSerializer {
    let mapper : JSONMapper
    
    init(mapper : JSONMapper) {
        self.mapper = mapper
    }
    
    func toJSON(_ obj : Any) -> String? {
        //At the top level we only handle objects {} or arrays
        let validObj : Any
        if let arr = obj as? NSArray {
            validObj = arr.serialize(serializer: self)
        }else {
            validObj = buildDict(obj)
        }
        
        let data = try? JSONSerialization.data(withJSONObject: validObj, options: [])
        return data == nil ? nil : String(data: data!, encoding: .utf8)
    }
    
    func toObj(_ obj: Any) -> AnyObject{
        return NSNull()
    }
    
    private func buildDict(_ obj: Any) -> [String: AnyObject] {
        var result = [String: AnyObject]()
        
        for case let (label?, value) in Mirror(reflecting: obj).children {
            let key = label.uppercaseFirst
            
            result[key] = value as AnyObject
        }
        
        return result
    }
}
