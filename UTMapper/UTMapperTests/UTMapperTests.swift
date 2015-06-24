//
//  UTMapperTests.swift
//  UTMapperTests
//
//  Created by Anton on 6/22/15.
//  Copyright © 2015 UTMapper. All rights reserved.
//

import XCTest

class UTMapperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testMissingConfiguration() {
        // TestObjectOne is completely missing a mapping file
        let testObjectInstance = TestObjectOne(NSDictionary())
        XCTAssertNil(testObjectInstance, "Failable initializer should have returned nil, missing mapping configuration file")
    }
    
    func testFailableInitializer() {
        // TestObjectTwo does not have default values defined for non-optional values
        let testObjectInstance = TestObjectTwo(NSDictionary())
        XCTAssertNil(testObjectInstance, "Failable initializer should have returned nil, mapping configuration is blank")
    }

    func testDefaultMapping() {
        // TestObjectThree has all the default values defined
        let testObjectInstance = TestObjectThree(NSDictionary())
        
        XCTAssertEqual(testObjectInstance!.optionalString!, "Hello", "Optional String Value should default to 'Hello'")
        XCTAssertEqual(testObjectInstance!.optionalInt!, Int(10), "Optional Int value should default to 10")
        XCTAssertEqual(testObjectInstance!.optionalDouble!, Double(20.0), "Optional Double value should default to 20.0")
        XCTAssertEqual(testObjectInstance!.optionalFloat!, Float(30.0), "Optional Float value should default to 30.0")
        XCTAssertEqual(testObjectInstance!.optionalBool!, true, "Optional Bool value should default to true")
        
        XCTAssertEqual(testObjectInstance!.non_optionalString, "Non-Optional Hello", "Non-Optional String Value should default to 'Non-Optional Hello'")
        XCTAssertEqual(testObjectInstance!.non_optionalInt, Int(40), "Non-Optional Int value should be 0.0")
        XCTAssertEqual(testObjectInstance!.non_optionalDouble, Double(50.0), "Non-Optional Double value should be 0.0")
        XCTAssertEqual(testObjectInstance!.non_optionalFloat, Float(60.0), "Non-Optional Float value should be 0.0")
        XCTAssertEqual(testObjectInstance!.non_optionalBool, false, "Non-Optional Bool value should be false")
    }

    func testBasicMappingForDictionaryWithoutOptionalValues() {
        // TestObjectFive has defaults only for non-optional values the optional values should all be nil
        let testObjectInstance = TestObjectFour(NSDictionary())

        XCTAssertNil(testObjectInstance!.optionalInt,              "Optional Int Value should be nil")

        XCTAssertNil(testObjectInstance!.optionalString,            "Optional String Value should be nil")
        XCTAssertNil(testObjectInstance!.optionalDouble,            "Optional String Value should be nil")
        XCTAssertNil(testObjectInstance!.optionalFloat,             "Optional String Value should be nil")
        XCTAssertNil(testObjectInstance!.optionalBool,              "Optional String Value should be nil")

        XCTAssertEqual(testObjectInstance!.non_optionalInt, Int(500), "Non-Optional Int does not equal the defined default value")

        XCTAssertEqual(testObjectInstance!.non_optionalString, "Non-Optional Hello", "Non-Optional String Value should default to 'Non-Optional Hello'")
        XCTAssertEqual(testObjectInstance!.non_optionalDouble, Double(50.0), "Non-Optional Double value should default to 50.0")
        XCTAssertEqual(testObjectInstance!.non_optionalFloat, Float(60.0), "Non-Optional Float value should default to 60.0")
        XCTAssertEqual(testObjectInstance!.non_optionalBool, true, "Non-Optional Bool value should default to true")
    }

    func testBasicMappingForDictionaryWithNonOptionalValues() {
        // TestObjectFive has defaults only for non-optional values the optional values should all be nil
        // All while the non optional values will be overriden to a value not set to a default
        let dictionary = ["non_optional_string" : "TestString", "non_optional_double" : 70.0, "non_optional_float" : 80.0, "non_optional_bool" : false]
        let testObjectInstance = TestObjectFour(dictionary)
        
        XCTAssertNil(testObjectInstance!.optionalInt,              "Optional Int Value should be nil")
        XCTAssertNil(testObjectInstance!.optionalString,            "Optional String Value should be nil")
        XCTAssertNil(testObjectInstance!.optionalDouble,            "Optional String Value should be nil")
        XCTAssertNil(testObjectInstance!.optionalFloat,             "Optional String Value should be nil")
        XCTAssertNil(testObjectInstance!.optionalBool,              "Optional String Value should be nil")
        
        XCTAssertEqual(testObjectInstance!.non_optionalInt, Int(500), "Non-Optional Int does not equal the defined default value")
        XCTAssertEqual(testObjectInstance!.non_optionalString, "TestString", "Non-Optional String Value did not parse the value correctly")
        XCTAssertEqual(testObjectInstance!.non_optionalDouble, Double(70.0), "Non-Optional Double value should default to 50.0")
        XCTAssertEqual(testObjectInstance!.non_optionalFloat, Float(80.0), "Non-Optional Float value should default to 60.0")
        XCTAssertEqual(testObjectInstance!.non_optionalBool, false, "Non-Optional Bool value should be false (default is true)")
    }
    
    func testBasicMappingNumericValueReturnedAsStrings() {
        // TestObjectFour has defaults only for non-optional values the optional values should all be nil
        let dictionary = ["non_optional_double" : "70.0", "non_optional_float" : "80.0"]
        let testObjectInstance = TestObjectFour(dictionary)
        
        XCTAssertEqual(testObjectInstance!.non_optionalInt, Int(500), "Non-Optional Int does not equal the defined default value")
        XCTAssertEqual(testObjectInstance!.non_optionalDouble, Double(70.0), "Non-Optional Double value should default to 50.0")
        XCTAssertEqual(testObjectInstance!.non_optionalFloat, Float(80.0), "Non-Optional Float value should default to 60.0")
    }
    
    func testBasicFalseBoolMapping() {
        
        // TestObjectFour has default set to true for the non_optionalBool property
        let dictionaryBoolValue = ["non_optional_bool" : false]
        let testBoolInstance = TestObjectFour(dictionaryBoolValue)
      
        XCTAssertEqual(testBoolInstance!.non_optionalBool, false, "Non-Optional Bool value should be false (default is true)")
        
        let dictionaryStringZeroValue = ["non_optional_bool" : "0"]
        let testStringZeroInstance = TestObjectFour(dictionaryStringZeroValue)
       
        XCTAssertEqual(testStringZeroInstance!.non_optionalBool, false, "Non-Optional Bool value should be false (default is true)")
        
        let dictionaryStringFalseValue = ["non_optional_bool" : "false"]
        let testStringFalseInstance = TestObjectFour(dictionaryStringFalseValue)
       
        XCTAssertEqual(testStringFalseInstance!.non_optionalBool, false, "Non-Optional Bool value should be false (default is true)")
        
        let dictionaryStringFalseCapsValue = ["non_optional_bool" : "FALSE"]
        let testStringFalseCapsInstance = TestObjectFour(dictionaryStringFalseCapsValue)
        
        XCTAssertEqual(testStringFalseCapsInstance!.non_optionalBool, false, "Non-Optional Bool value should be false (default is true)")
    }
    
    func testBasicTrueBoolMapping() {
        // TestObjectFour has default set to true for the non_optionalBool property
        let dictionaryBoolValue = ["non_optional_bool" : true]
        let testBoolInstance = TestObjectThree(dictionaryBoolValue)
        
        XCTAssertEqual(testBoolInstance!.non_optionalBool, true, "Non-Optional Bool value should be true (default is false)")
        
        let dictionaryStringOneValue = ["non_optional_bool" : "1"]
        let testStringOneInstance = TestObjectThree(dictionaryStringOneValue)
        
        XCTAssertEqual(testStringOneInstance!.non_optionalBool, true, "Non-Optional Bool value should be true (default is false)")
        
        let dictionaryStringTrueValue = ["non_optional_bool" : "true"]
        let testStringTrueInstance = TestObjectThree(dictionaryStringTrueValue)
        
        XCTAssertEqual(testStringTrueInstance!.non_optionalBool, true, "Non-Optional Bool value should be true (default is false)")
        
        let dictionaryStringTrueCapsValue = ["non_optional_bool" : "TRUE"]
        let testStringTrueCapsInstance = TestObjectThree(dictionaryStringTrueCapsValue)
        
        XCTAssertEqual(testStringTrueCapsInstance!.non_optionalBool, true, "Non-Optional Bool value should be true (default is false)")
    }
    
}
