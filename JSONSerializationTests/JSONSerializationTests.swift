import XCTest
import SwiftyJSON

@testable import JSONSerialization

struct Animal {
    let name: String
    let age: Int
}

class JSONSerializationTests: XCTestCase {
    func createSerializer() -> JSONSerializer {
        let m = JSONMapper()
        
        m.addMapping(type: Date.self) { d in
            return d.description + " Yea boi" as AnyObject
        }
        
        m.addMapping(type: Animal.self) { animal -> AnyObject in
            return "\(animal.name) is \(animal.age) years old" as AnyObject
        }
        
        return JSONSerializer(mapper: m)
    }
    
    func testCanSerializeObjectWithPrimitives(){
        let it = createSerializer()
        
        let json = JSON.parse(it.toJSON(Animal(name: "Spike", age: 5)) ?? "")
        
        XCTAssert(json["Name"].string == "Spike")
        XCTAssert(json["Age"].number == 5)
    }
}
