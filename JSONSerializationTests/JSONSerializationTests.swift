import XCTest
@testable import JSONSerialization

struct Animal : JSONSerializable {
    let name: String
    let age: Int
    let species: String
}

class JSONSerializationTests: XCTestCase {
    func testIsObject(){
        let animal = Animal(name: "Daisy", age: 5, species: "Cow")
        
        let jsonString = animal.toJSONString()
        
        XCTAssertNotNil(jsonString)
    }
}
