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
        let testObjectInstance = TestObjectOne(Dictionary<String, AnyObject>())
        XCTAssertNil(testObjectInstance, "Failable initializer should have returned nil, missing mapping configuration file")
    }
    
    func testFailableInitializer() {
        // TestObjectTwo does not have default values defined for non-optional values
        let testObjectInstance = TestObjectTwo(Dictionary<String, AnyObject>())
        XCTAssertNil(testObjectInstance, "Failable initializer should have returned nil, mapping configuration is blank")
    }

    func testDefaultMapping() {
        // TestObjectThree has all the default values defined
        let testObjectInstance = TestObjectThree(Dictionary<String, AnyObject>())
        
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
        let testObjectInstance = TestObjectFour(Dictionary<String, AnyObject>())

        XCTAssertNil(testObjectInstance!.optionalInt,              "Optional Int Value should be nil")
        XCTAssertNil(testObjectInstance!.optionalString,           "Optional String Value should be nil")
        XCTAssertNil(testObjectInstance!.optionalDouble,           "Optional String Value should be nil")
        XCTAssertNil(testObjectInstance!.optionalFloat,            "Optional String Value should be nil")
        XCTAssertNil(testObjectInstance!.optionalBool,             "Optional String Value should be nil")

        XCTAssertEqual(testObjectInstance!.non_optionalInt, Int(500), "Non-Optional Int does not equal the defined default value")
        XCTAssertEqual(testObjectInstance!.non_optionalString, "Non-Optional Hello", "Non-Optional String value does not equal the defined default value")
        XCTAssertEqual(testObjectInstance!.non_optionalDouble, Double(50.0), "Non-Optional Double value does not equal the defined default value")
        XCTAssertEqual(testObjectInstance!.non_optionalFloat, Float(60.0), "Non-Optional Float value does not equal the defined default value")
        XCTAssertEqual(testObjectInstance!.non_optionalBool, true, "Non-Optional Bool value does not equal the defined default value")
    }

    func testBasicMappingForDictionaryWithNonOptionalValues() {
        // TestObjectFive has defaults only for non-optional values the optional values should all be nil
        // All while the non optional values will be overriden to a value not set to a default
        let dictionary = ["non_optional_int" : 50, "non_optional_string" : "TestString", "non_optional_double" : 70.0, "non_optional_float" : 80.0, "non_optional_bool" : false]
        let testObjectInstance = TestObjectFour(dictionary)
        
        XCTAssertNil(testObjectInstance!.optionalInt,               "Optional Int Value should be nil")
        XCTAssertNil(testObjectInstance!.optionalString,            "Optional String Value should be nil")
        XCTAssertNil(testObjectInstance!.optionalDouble,            "Optional String Value should be nil")
        XCTAssertNil(testObjectInstance!.optionalFloat,             "Optional String Value should be nil")
        XCTAssertNil(testObjectInstance!.optionalBool,              "Optional String Value should be nil")
        
        XCTAssertEqual(testObjectInstance!.non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalString, "TestString", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalDouble, Double(70.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalFloat, Float(80.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalBool, false, "Non-Optional Bool value was parsed incorrectly")
    }
    
    func testNumericValueReturnedAsStrings() {
        // TestObjectFour has defaults only for non-optional values the optional values should all be nil
        let dictionary = ["non_optional_int" : "50", "non_optional_double" : "70.0", "non_optional_float" : "80.0"]
        let testObjectInstance = TestObjectFour(dictionary)
        
        XCTAssertEqual(testObjectInstance!.non_optionalInt, Int(50), "Non-Optional Int was parsed incorrectly from a String value")
        XCTAssertEqual(testObjectInstance!.non_optionalDouble, Double(70.0), "Non-Optional Double was parsed incorrectly from a String value")
        XCTAssertEqual(testObjectInstance!.non_optionalFloat, Float(80.0), "Non-Optional Float value was parsed incorrectly from a String value")
    }
    
    func testBoolFalseMapping() {
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
    
    func testBoolTrueMapping() {
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
    
    func testNumericStringMapping() {
        // TestObjectFour has default set to true for the non_optionalBool property
        let dictionaryNumericStringValue = ["non_optional_string" : 70.0]
        let numericStringInstance = TestObjectThree(dictionaryNumericStringValue)
        
        XCTAssertEqual(numericStringInstance!.non_optionalString, "70.0", "Non-Optional String value was not parsed correctly from a numeric value")
    }
    
    func testNestedMapping() {
        // TestObjectFour has default set to true for the non_optionalBool property
        let dictionaryNumericStringValue = ["non_optional_string" : 70.0]
        let numericStringInstance = TestObjectThree(dictionaryNumericStringValue)
        
        XCTAssertEqual(numericStringInstance!.non_optionalString, "70.0", "Non-Optional String value was not parsed correctly from a numeric value")
    }
    
    func testSubTypeMapping() {
        let subtypeDictionary = ["non_optional_int" : 50, "non_optional_string" : "TestString", "non_optional_double" : 70.0, "non_optional_float" : 80.0, "non_optional_bool" : false]
        let dictionaryBoolValue = ["optional_subtype" : subtypeDictionary, "non_optional_subtype" : subtypeDictionary]
       
        let testObjectInstance = TestObjectFive(dictionaryBoolValue)

        XCTAssertEqual(testObjectInstance!.optionalSubType!.non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalSubType!.non_optionalString, "TestString", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalSubType!.non_optionalDouble, Double(70.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalSubType!.non_optionalFloat, Float(80.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalSubType!.non_optionalBool, false, "Non-Optional Bool value was parsed incorrectly")
        
        XCTAssertEqual(testObjectInstance!.non_optionalSubType.non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalSubType.non_optionalString, "TestString", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalSubType.non_optionalDouble, Double(70.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalSubType.non_optionalFloat, Float(80.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalSubType.non_optionalBool, false, "Non-Optional Bool value was parsed incorrectly")
    }
    
    func testFailableWithComplexTypesInitializer() {
        // TestObjectTwo does not have default values defined for non-optional values
        let subtypeDictionary = ["non_optional_int" : 50, "non_optional_string" : "TestString", "non_optional_double" : 70.0, "non_optional_float" : 80.0, "non_optional_bool" : false]
        let dictionaryBoolValue = ["optional_subtype" : subtypeDictionary]
        
        let testObjectInstance = TestObjectFive(dictionaryBoolValue)
        XCTAssertNil(testObjectInstance, "Failable initializer should have returned nil, mapping configuration is blank")
    }
    
    func testCompoundValueMapper() {
        // TestObjectSix should have compound values mapped for the optinal and non optional values
        let dataDictionary = ["left_hand_string" : "Left-String-", "right_hand_string" : "Right-String", "non_optional_left_hand_string" : "NONOP-Left-String-", "non_optional_right_hand_string" : "NONOP-Right-String"]
        
        let testObjectInstance = TestObjectSix(dataDictionary)
        XCTAssertEqual(testObjectInstance!.optionalCompoundString!, "Left-String-Right-String", "Compount Value Mapper returned incorrect Value")
        XCTAssertEqual(testObjectInstance!.non_optionalCompoundString, "NONOP-Left-String-NONOP-Right-String", "Compount Value Mapper returned incorrect Value")
    }
    
    func testCompoundValueMapperFailableInitializer() {
        // TestObjectSix should fail since the non_optionalCompoundString will return nil
        let dataDictionary = ["left_hand_string" : "Left-String-", "right_hand_string" : "Right-String"]
        
        let testObjectInstance = TestObjectSix(dataDictionary)
        XCTAssertNil(testObjectInstance, "Failable initializer should have returned nil, mapping configuration is blank")
    }
    
    func testArraySubtypeMapping() {
        // TestObjectSEven has an array of TestObjectFour(s)
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        let object2Dictionary = ["non_optional_int" : 80, "non_optional_string"  : "TestString2", "non_optional_double" : 90.0, "non_optional_float" : 100.0, "non_optional_bool" : false]
        let object3Dictionary = ["non_optional_int" : 110, "non_optional_string" : "TestString3", "non_optional_double" : 120.0, "non_optional_float" : 130.0, "non_optional_bool" : true]

        let testObjectArray = [object1Dictionary, object2Dictionary]
        let dataDictionary : Dictionary<String, AnyObject> = ["optional_sub_object_array" : testObjectArray, "non_optional_sub_object_array" : [object3Dictionary]]
        
        let testObjectInstance = TestObjectSeven(dataDictionary)
        
        XCTAssertEqual(testObjectInstance!.optionalArrayType![0].non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![0].non_optionalDouble, Double(60.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![0].non_optionalFloat, Float(70.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![0].non_optionalString, "TestString1", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![0].non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly")
        
        XCTAssertEqual(testObjectInstance!.optionalArrayType![1].non_optionalInt, Int(80), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![1].non_optionalDouble, Double(90.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![1].non_optionalFloat, Float(100.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![1].non_optionalString, "TestString2", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![1].non_optionalBool, false, "Non-Optional Bool value was parsed incorrectly")
        
        XCTAssertEqual(testObjectInstance!.non_optionalArrayType[0].non_optionalInt, Int(110), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalArrayType[0].non_optionalDouble, Double(120.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalArrayType[0].non_optionalFloat, Float(130.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalArrayType[0].non_optionalString, "TestString3", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalArrayType[0].non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly")
    }
    
    func testArraySubtypeReturnedAsDictionaryMapping() {
        // TestObjectSEven has an array of TestObjectFour(s)
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        let object2Dictionary = ["non_optional_int" : 80, "non_optional_string"  : "TestString2", "non_optional_double" : 90.0, "non_optional_float" : 100.0, "non_optional_bool" : false]
        let object3Dictionary = ["non_optional_int" : 110, "non_optional_string" : "TestString3", "non_optional_double" : 120.0, "non_optional_float" : 130.0, "non_optional_bool" : true]
   
        let testObjectDictionary = ["1" : object2Dictionary, "2" : object1Dictionary]
        let testObjectDictionary2 = ["1" : object3Dictionary]
        
        let dataDictionary : Dictionary<String, AnyObject> = ["optional_sub_object_array" : testObjectDictionary, "non_optional_sub_object_array" : testObjectDictionary2]
        
        let testObjectInstance = TestObjectSeven(dataDictionary)
        
        XCTAssertEqual(testObjectInstance!.optionalArrayType![0].non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![0].non_optionalDouble, Double(60.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![0].non_optionalFloat, Float(70.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![0].non_optionalString, "TestString1", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![0].non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly")
        
        XCTAssertEqual(testObjectInstance!.optionalArrayType![1].non_optionalInt, Int(80), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![1].non_optionalDouble, Double(90.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![1].non_optionalFloat, Float(100.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![1].non_optionalString, "TestString2", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalArrayType![1].non_optionalBool, false, "Non-Optional Bool value was parsed incorrectly")
        
        XCTAssertEqual(testObjectInstance!.non_optionalArrayType[0].non_optionalInt, Int(110), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalArrayType[0].non_optionalDouble, Double(120.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalArrayType[0].non_optionalFloat, Float(130.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalArrayType[0].non_optionalString, "TestString3", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalArrayType[0].non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly")
    }
    
    func testArraySubtypeMappingFailableInitializer() {
        // TestObjectSEven has an array of TestObjectFour(s)
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        let object2Dictionary = ["non_optional_int" : 80, "non_optional_string"  : "TestString2", "non_optional_double" : 90.0, "non_optional_float" : 100.0, "non_optional_bool" : false]

        let testObjectArray = [object1Dictionary, object2Dictionary]
        let dataDictionary = ["optional_sub_object_array" : testObjectArray]
        
        let testObjectInstance = TestObjectSeven(dataDictionary)
        XCTAssertNil(testObjectInstance, "Failable initializer should have returned nil, mapping configuration is blank")
    }
    
    func testDictionarySubtypeSingleMapping() {
        // TestObjectEight has an array of TestObjectEight(s)
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        let object2Dictionary = ["non_optional_int" : 110, "non_optional_string" : "TestString3", "non_optional_double" : 120.0, "non_optional_float" : 130.0, "non_optional_bool" : true]
        let dataDictionary : Dictionary<String, AnyObject> = ["optional_sub_object_dictionary" : object1Dictionary, "non_optional_sub_object_dictionary" : object2Dictionary]
        
        let testObjectInstance = TestObjectEight(dataDictionary)
        
        XCTAssertEqual(testObjectInstance!.optionalDictionaryType!["0"]!.non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryType!["0"]!.non_optionalDouble, Double(60.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryType!["0"]!.non_optionalFloat, Float(70.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryType!["0"]!.non_optionalString, "TestString1", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryType!["0"]!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly")
      
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryType["0"]!.non_optionalInt, Int(110), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryType["0"]!.non_optionalDouble, Double(120.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryType["0"]!.non_optionalFloat, Float(130.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryType["0"]!.non_optionalString, "TestString3", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryType["0"]!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly")
    }
    
    func testDictionarySubtypeArraysOfDictionaryMapping() {
        // TestObjectSEven has an array of TestObjectFour(s)
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        let object2Dictionary = ["non_optional_int" : 80, "non_optional_string"  : "TestString2", "non_optional_double" : 90.0, "non_optional_float" : 100.0, "non_optional_bool" : false]
        let object3Dictionary = ["non_optional_int" : 110, "non_optional_string" : "TestString3", "non_optional_double" : 120.0, "non_optional_float" : 130.0, "non_optional_bool" : true]
        let object4Dictionary = ["non_optional_int" : 140, "non_optional_string" : "TestString4", "non_optional_double" : 150.0, "non_optional_float" : 160.0, "non_optional_bool" : false]
        
        let testObjectArray = [object1Dictionary, object2Dictionary]
        let testObjectArray2 = [object3Dictionary, object4Dictionary]
        let dataDictionary : Dictionary<String, AnyObject> = ["optional_sub_object_dictionary" : testObjectArray, "non_optional_sub_object_dictionary" : testObjectArray2]
        
        let testObjectInstance = TestObjectEight(dataDictionary)
        
        XCTAssertEqual(testObjectInstance!.optionalDictionaryType!["0"]!.non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryType!["0"]!.non_optionalDouble, Double(60.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryType!["0"]!.non_optionalFloat, Float(70.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryType!["0"]!.non_optionalString, "TestString1", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryType!["0"]!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly")
        
        XCTAssertEqual(testObjectInstance!.optionalDictionaryType!["1"]!.non_optionalInt, Int(80), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryType!["1"]!.non_optionalDouble, Double(90.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryType!["1"]!.non_optionalFloat, Float(100.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryType!["1"]!.non_optionalString, "TestString2", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryType!["1"]!.non_optionalBool, false, "Non-Optional Bool value was parsed incorrectly")
        
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryType["0"]!.non_optionalInt, Int(110), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryType["0"]!.non_optionalDouble, Double(120.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryType["0"]!.non_optionalFloat, Float(130.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryType["0"]!.non_optionalString, "TestString3", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryType["0"]!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly")
   
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryType["1"]!.non_optionalInt, Int(140), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryType["1"]!.non_optionalDouble, Double(150.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryType["1"]!.non_optionalFloat, Float(160.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryType["1"]!.non_optionalString, "TestString4", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryType["1"]!.non_optionalBool, false, "Non-Optional Bool value was parsed incorrectly")
    }
    /*
    func testDictionarySubtypeFailableInitializer() {
        // TestObjectSEven has an array of TestObjectFour(s)
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]

        let dataDictionary = ["optional_sub_object_dictionary" : object1Dictionary]
        
        let testObjectInstance = TestObjectEight(dataDictionary)
        XCTAssertNil(testObjectInstance, "Failable initializer should have returned nil, mapping configuration is blank")
    }
*/

}