import XCTest
@testable import JsonReader

class JsonReaderTests: XCTestCase {
    
    func testSyntax() {
        
        // Creating our data (this part shouldn't fail)
        let jsonContent = "{\"person\" : [{\"name\": \"Bob\",\"age\": 16,\"employed\": false},{\"name\": \"Vinny\",\"age\": 56,\"employed\": true}]}"
        let data = jsonContent.data(using: .utf8)!
        guard let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            XCTAssert(false, "can't parse to json")
            return
        }
        
        // parsing our object
        let object = JsonObject(json: jsonResult)
        
        // test random values
        XCTAssertEqual(object["person"]?[0]?["name"]?.stringValue, "Bob")
        XCTAssertEqual(object["person"]?[1]?["age"]?.integerValue, 56)
        XCTAssertEqual(object["person"]?[0]?["employed"]?.booleanValue, false)
    }
    
    func testNumeric() {
        
        // Creating datas
        let jsonContent = "[1, 1.618, 2, 3, 3.141592, true, false, \"stringValue\", null]"
        let data = jsonContent.data(using: .utf8)!
        guard let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            XCTAssert(false, "can't parse to json")
            return
        }
        
        // parsing our object
        let object = JsonObject(json: jsonResult)
        
        // test cast values
        XCTAssertEqual(object[0]?.integerValue, 1)
        XCTAssertEqual(object[1]?.floatValue, 1.618)
        XCTAssertEqual(object[2]?.integerValue, 2)
        XCTAssertEqual(object[3]?.integerValue, 3)
        XCTAssertEqual(object[4]?.floatValue, 3.141592)
        XCTAssertEqual(object[5]?.booleanValue, true)
        XCTAssertEqual(object[6]?.booleanValue, false)
        XCTAssertEqual(object[7]?.stringValue, "stringValue")
        XCTAssertEqual(object[8]?.isNull, true)
    }
    
    func testDescription() {
        
        // creating datas
        let jsonContent = "{\"person\" : [{\"name\": \"Bob\",\"age\": 16,\"employed\": false, \"nil\": null},{\"name\": \"Vinny\",\"age\": 56,\"employed\": true}]}"
        let data = jsonContent.data(using: .utf8)!
        
        // creating first object
        guard let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            XCTAssert(false, "can't parse to json")
            return
        }
        let object = JsonObject(json: jsonResult)
        
        // creating second object from description of first
        let savedData = object.description.data(using: .utf8)!
        let savedJsonResult = try? JSONSerialization.jsonObject(with: savedData, options: .allowFragments)
        XCTAssertNotNil(savedJsonResult, "can't parse saved json")
        if let savedJsonResult = savedJsonResult {
            let savedObject = JsonObject(json: savedJsonResult)
            
            // the two items shall be equals
            XCTAssertEqual(object, savedObject)
        }
    }
    
    static var allTests = [
        ("testSyntax", testSyntax),
        ("testNumeric", testNumeric),
        ("testDescription", testDescription)
    ]
}
