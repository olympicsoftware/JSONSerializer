import XCTest
import SwiftyJSON

@testable import JSONSerialization

struct Animal : JSONSerializable {
    let name: String
    let age: Int
    let species: String
}

func parseJson(_ str: String) -> JSON{
    return JSON.parse(str)
}


class JSONSerializationTests: XCTestCase {
    func testCanSerializeObjectWithPrimitives(){
        let animal = Animal(name: "Daisy", age: 5, species: "Cow")
        
        let jsonString = animal.toJSONString()
        
        let json = parseJson(jsonString!)
        
        XCTAssert(json["Name"].string == "Daisy")
        XCTAssert(json["Species"].string == "Cow")
        XCTAssert(json["Age"].number == 5)
    }
}
