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
    
    
    struct Person: JSONSerializable {
        let name: String
        let age: Int
        let weight: Double
        let savings: Decimal
        let pet: Animal
    }
    
    func testCanSerializeObjectWithNestedObject(){
        let person = Person(name: "Francis", age: 55, weight: 69.3, savings: 44303.57, pet: Animal(name: "Spike", age: 8, species: "Dog"))
        let jsonString = person.toJSONString()
        
        let json = parseJson(jsonString!)
        
        XCTAssert(json["Name"].string == "Francis")
        XCTAssert(json["Age"].number == 55)
        XCTAssert(json["Weight"].number == 69.3)
        XCTAssert(json["Savings"].number == 44303.57)
        
        XCTAssert(json["Pet"]["Name"].string == "Spike")
        XCTAssert(json["Pet"]["Age"].number == 8)
        XCTAssert(json["Pet"]["Species"].string == "Dog")
    }
}
