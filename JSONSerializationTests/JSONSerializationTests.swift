import XCTest
import SwiftyJSON

@testable import JSONSerialization

struct Animal {
    let name: String
    let age: Int
}

struct Person {
    let name: String
    let dateOfBirth: Date
    let pet: Animal
}

struct PersonWithChildren {
    let name: String
    let dateOfBirth: Date
    let pet: Animal
    let children: [Person]
}

struct Thing {
    let name: String
    let maybeName: String?
    let otherMaybeName: String?
}

struct ParentThing {
    let name: String
    let subThing: Thing
    let optionalSubThing: Thing?
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
    
    func testOptionals(){
        let it = createSerializer()
        
        let json = JSON.parse(it.toJSON(Thing(name: "Spike", maybeName: nil, otherMaybeName: "James")) ?? "")
        
        XCTAssert(json["Name"].string == "Spike")
        XCTAssert(json["MaybeName"].string == nil)
        XCTAssert(json["OtherMaybeName"].string == "James")
    }
    
    func testOptionalSubObjects(){
        let it = createSerializer()
        
        let thing = ParentThing(name: "Jayquelin",
                                subThing: Thing(name: "Spike", maybeName: nil, otherMaybeName: "James"),
                                optionalSubThing: nil)
        
        let string = it.toJSON(thing) ?? ""
        let json = JSON.parse(string)
        
        XCTAssert(json["Name"].string == "Jayquelin")
        XCTAssert(json["SubThing"]["Name"].string == "Spike")
        XCTAssert(json["SubThing"]["MaybeName"].string == nil)
        XCTAssert(json["SubThing"]["OtherMaybeName"].string == "James")
        XCTAssert(json["OptionalSubThing"] == JSON.null)
    }
    
    func testCustomMapping() {
        let it = createSerializer()
        
        let person = Person(name: "Lars", dateOfBirth: Date(timeIntervalSince1970: 500000), pet: Animal(name: "Poppy", age: 16))
        
        let string = it.toJSON(person) ?? ""
        let json = JSON.parse(string)
        
        XCTAssert(json["Name"].string == "Lars")
        XCTAssert(json["DateOfBirth"].string == "1970-01-06 18:53:20 +0000 Yea boi")
        XCTAssert(json["Pet"].string == "Poppy is 16 years old")
        
    }
    
    func testRootArray(){
        let it = createSerializer()
        
        let animals = [Animal(name: "Roger", age: 7), Animal(name: "Mr Pickles", age: 6)]
        
        let string = it.toJSON(animals) ?? ""
        let json = JSON.parse(string)
        
        XCTAssert(json[0].string == "Roger is 7 years old")
        XCTAssert(json[1].string == "Mr Pickles is 6 years old")
    }
    
    func testArrays() {
        let it = createSerializer()
        
        let person = PersonWithChildren(name: "Lars",
                                        dateOfBirth: Date(timeIntervalSince1970: 500000),
                                        pet: Animal(name: "Poppy", age: 16),
                                        children: [
                                            Person(name: "Mike", dateOfBirth: Date(timeIntervalSince1970: 510000), pet: Animal(name: "Scruffy", age: 5)),
                                            Person(name: "Hugs", dateOfBirth: Date(timeIntervalSince1970: 520000), pet: Animal(name: "Bonny", age: 8))
                                        ])
        
        let string = it.toJSON(person) ?? ""
        let json = JSON.parse(string)
        
        XCTAssert(json["Name"].string == "Lars")
        XCTAssert(json["DateOfBirth"].string == "1970-01-06 18:53:20 +0000 Yea boi")
        XCTAssert(json["Pet"].string == "Poppy is 16 years old")
        XCTAssert(json["Children"][0]["Name"] == "Mike")
        XCTAssert(json["Children"][0]["DateOfBirth"] == "1970-01-06 21:40:00 +0000 Yea boi")
        XCTAssert(json["Children"][0]["Pet"] == "Scruffy is 5 years old")
        
        XCTAssert(json["Children"][1]["Name"] == "Hugs")
        XCTAssert(json["Children"][1]["DateOfBirth"] == "1970-01-07 00:26:40 +0000 Yea boi")
        XCTAssert(json["Children"][1]["Pet"] == "Bonny is 8 years old")
    }
}

