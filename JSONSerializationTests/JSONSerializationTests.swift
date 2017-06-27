import XCTest
import SwiftyJSON

@testable import JSONSerialization

struct Animal : JSONSerializable {
    let name: String
    let age: Int
    let species: String
}

struct Person: JSONSerializable {
    let name: String
    let age: Int
    let weight: Double
    let savings: Decimal
    let pet: Animal
}

struct Person2: JSONSerializable {
    let name: String
    let middleName: String?
    let lastName: String?
    let pet: Animal?
}

func serializableToJSON(_ obj: JSONSerializable) -> JSON {
    let string = obj.toJSONString()
    return string == nil ? JSON.null : JSON.parse(string!)
}

class JSONSerializationTests: XCTestCase {
    func testCanSerializeObjectWithPrimitives(){
        let animal = Animal(name: "Daisy", age: 5, species: "Cow")
        
        let json = serializableToJSON(animal)
        
        XCTAssert(json["Name"].string == "Daisy")
        XCTAssert(json["Species"].string == "Cow")
        XCTAssert(json["Age"].number == 5)
    }
    
    func testCanSerializeObjectWithNestedObject(){
        let person = Person(name: "Francis", age: 55, weight: 69.3, savings: 44303.57, pet: Animal(name: "Spike", age: 8, species: "Dog"))

        let json = serializableToJSON(person)
        
        XCTAssert(json["Name"].string == "Francis")
        XCTAssert(json["Age"].number == 55)
        XCTAssert(json["Weight"].number == 69.3)
        XCTAssert(json["Savings"].number == 44303.57)
        
        XCTAssert(json["Pet"]["Name"].string == "Spike")
        XCTAssert(json["Pet"]["Age"].number == 8)
        XCTAssert(json["Pet"]["Species"].string == "Dog")
    }
    
    func testCanSerializeOptionals(){
        let person = Person2(name: "Mike", middleName: nil, lastName: "Little", pet: Animal(name: "Leo", age: 16, species: "Cat"))
        
        let json = serializableToJSON(person)
        
        XCTAssert(json["Name"].string == "Mike")
        XCTAssert(json["MiddleName"].string == nil)
        XCTAssert(json["LastName"].string == "Little")
        
        XCTAssert(json["Pet"]["Name"].string == "Leo")
        XCTAssert(json["Pet"]["Species"].string == "Cat")
        XCTAssert(json["Pet"]["Age"].number == 16)
    }
}
