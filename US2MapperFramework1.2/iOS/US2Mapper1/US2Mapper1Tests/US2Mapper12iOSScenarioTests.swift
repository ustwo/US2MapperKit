//
//  US2Mapper12iOSScenarioTests.swift
//  US2Mapper12
//
//  Created by Anton on 7/8/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

import UIKit
import XCTest

class US2Mapper12iOSScenarioTests: XCTestCase {
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
        XCTAssertNil(testObjectInstance, "Failable initializer should have returned nil, non-optinal values are missing")
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
        XCTAssertNil(testObjectInstance, "Failable initializer should have returned nil, non-optinal values are missing")
    }
    
    func testArrayComplexSubtypeMapping() {
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
    
    func testArrayComplexSubtypeReturnedAsDictionaryMapping() {
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
    
    func testArrayComplexSubtypeMappingFailableInitializer() {
        // TestObjectSEven has an array of TestObjectFour(s)
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        let object2Dictionary = ["non_optional_int" : 80, "non_optional_string"  : "TestString2", "non_optional_double" : 90.0, "non_optional_float" : 100.0, "non_optional_bool" : false]
        
        let testObjectArray = [object1Dictionary, object2Dictionary]
        let dataDictionary = ["optional_sub_object_array" : testObjectArray]
        
        let testObjectInstance = TestObjectSeven(dataDictionary)
        XCTAssertNil(testObjectInstance, "Failable initializer should have returned nil, non-optinal values are missing")
    }
    
    func testDictionaryComplexSubtypeSingleMapping() {
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
    
    func testDictionaryComplexSubtypeToArraysOfDictionaries() {
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
    
    func testDictionaryComplexSubtypeFailableInitializer() {
        // TestObjectSEven has an array of TestObjectFour(s)
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        
        let dataDictionary = ["optional_sub_object_dictionary" : object1Dictionary]
        
        let testObjectInstance = TestObjectEight(dataDictionary)
        XCTAssertNil(testObjectInstance, "Failable initializer should have returned nil, non-optinal values are missing")
    }
    
    func testArraySimpleSubtypeMapping() {
        let stringArray = ["String1", "String2", "String3"]
        let intArray = [1, 2, 3]
        let doubleArray = [Double(4.0), Double(5.0), Double(6.0)]
        let floatArray = [Float(7.0), Float(8.0), Float(9.0)]
        
        let dataDictionary : Dictionary<String, AnyObject> = ["optional_array_string_type" : stringArray, "optional_array_int_type" : intArray, "optional_array_double_type" : doubleArray, "optional_array_float_type" : floatArray, "non_optional_array_string_type" : stringArray, "non_optional_array_int_type" : intArray, "non_optional_array_double_type" : doubleArray, "non_optional_array_float_type" : floatArray]
        
        let testObjectInstance = TestObjectNine(dataDictionary)
        
        for stringValue in stringArray {
            XCTAssertTrue(contains(testObjectInstance!.optionalArrayStringType!, stringValue) == true, "Array subtype as String was parsed incorrectly from Array")
        }
        
        for doubleValue in doubleArray {
            XCTAssertTrue(contains(testObjectInstance!.optionalArrayDoubleType!, doubleValue) == true, "Array subtype as Double was parsed incorrectly from Array")
        }
        
        for floatValue in floatArray {
            XCTAssertTrue(contains(testObjectInstance!.optionalArrayFloatType!, floatValue) == true, "Array subtype as Float was parsed incorrectly from Array")
        }
        
        for intValue in intArray {
            XCTAssertTrue(contains(testObjectInstance!.optionalArrayIntType!, intValue) == true, "Array subtype as Int was parsed incorrectly from Array")
        }
        
        for stringValue in stringArray {
            XCTAssertTrue(contains(testObjectInstance!.non_optionalArrayStringType , stringValue) == true, "Non-Optional Array subtype as String was parsed incorrectly from Array")
        }
        
        for doubleValue in doubleArray {
            XCTAssertTrue(contains(testObjectInstance!.non_optionalArrayDoubleType, doubleValue) == true, "Non-Optional Array subtype as Double was parsed incorrectly from Array")
        }
        
        for floatValue in floatArray {
            XCTAssertTrue(contains(testObjectInstance!.non_optionalArrayFloatType, floatValue) == true, "Non-Optional Array subtype as Float was parsed incorrectly from Array")
        }
        
        for intValue in intArray {
            XCTAssertTrue(contains(testObjectInstance!.non_optionalArrayIntType , intValue) == true, "Non-Optional Array subtype as Int was parsed incorrectly from Array")
        }
    }
    
    func testArraySimpleSubtypeToArraysOfDictionaries() {
        let stringDictionary = ["1" : "String1", "2" : "String2", "3" : "String3"]
        let intDictionary = ["1" : 1, "2" : 2, "3" : 3]
        let doubleDictionary = ["1" : Double(4.0), "2" : Double(5.0), "3" : Double(6.0)]
        let floatDictionary = ["1" : Float(7.0), "2" : Float(8.0), "3" : Float(9.0)]
        
        let dataDictionary : Dictionary<String, AnyObject> = ["optional_array_string_type" : stringDictionary, "optional_array_int_type" : intDictionary, "optional_array_double_type" : doubleDictionary, "optional_array_float_type" : floatDictionary, "non_optional_array_string_type" : stringDictionary, "non_optional_array_int_type" : intDictionary, "non_optional_array_double_type" : doubleDictionary, "non_optional_array_float_type" : floatDictionary]
        
        let testObjectInstance = TestObjectNine(dataDictionary)
        
        for (_ , stringValue) in stringDictionary {
            XCTAssertTrue(contains(testObjectInstance!.optionalArrayStringType!, stringValue) == true, "Array subtype as String was parsed incorrectly from dictionary")
        }
        
        for (_ , doubleValue) in doubleDictionary {
            XCTAssertTrue(contains(testObjectInstance!.optionalArrayDoubleType!, doubleValue) == true, "Array subtype as Double was parsed incorrectly from dictionary")
        }
        
        for (_ , floatValue) in floatDictionary {
            XCTAssertTrue(contains(testObjectInstance!.optionalArrayFloatType!, floatValue) == true, "Array subtype as Float was parsed incorrectly from dictionary")
        }
        
        for (_ , intValue) in intDictionary {
            XCTAssertTrue(contains(testObjectInstance!.optionalArrayIntType! , intValue) == true, "Array subtype as Int was parsed incorrectly from dictionary")
        }
        
        for (_ , stringValue) in stringDictionary {
            XCTAssertTrue(contains(testObjectInstance!.non_optionalArrayStringType, stringValue) == true, "Non-Optional Array subtype as String was parsed incorrectly from dictionary")
        }
        
        for (_ , doubleValue) in doubleDictionary {
            XCTAssertTrue(contains(testObjectInstance!.non_optionalArrayDoubleType, doubleValue) == true, "Non-Optional Array subtype as Double was parsed incorrectly from dictionary")
        }
        
        for (_ , floatValue) in floatDictionary {
            XCTAssertTrue(contains(testObjectInstance!.non_optionalArrayFloatType, floatValue), "Non-Optional Array subtype as Float was parsed incorrectly from dictionary")
        }
        
        for (_ , intValue) in intDictionary {
            XCTAssertTrue(contains(testObjectInstance!.non_optionalArrayIntType , intValue), "Non-Optional Array subtype as Int was parsed incorrectly from dictionary")
        }
    }
    
    func testArraySimpleSubtypeFailableInitializer() {
        let stringArray = ["String1", "String2", "String3"]
        let intArray = [1, 2, 3]
        let doubleArray = [Double(4.0), Double(5.0), Double(6.0)]
        let floatArray = [Float(7.0), Float(8.0), Float(9.0)]
        
        let dataDictionary : Dictionary<String, AnyObject> = ["optional_array_string_type" : stringArray, "optional_array_int_type" : intArray, "optional_array_double_type" : doubleArray, "optional_array_float_type" : floatArray]
        
        let testObjectInstance = TestObjectNine(dataDictionary)
        XCTAssertNil(testObjectInstance, "Failable initializer should have returned nil, non optional array values are nill")
    }
    
    func testDictionarySimpleSubtypeMapping() {
        let stringDictionary = ["1" : "String1", "2" : "String2", "3" : "String3"]
        let intDictionary = ["1" : 1, "2" : 2, "3" : 3]
        let doubleDictionary = ["1" : Double(4.0), "2" : Double(5.0), "3" : Double(6.0)]
        let floatDictionary = ["1" : Float(7.0), "2" : Float(8.0), "3" : Float(9.0)]
        
        let dataDictionary : Dictionary<String, AnyObject> = ["optional_dictionary_string_type" : stringDictionary, "optional_dictionary_int_type" : intDictionary, "optional_dictionary_double_type" : doubleDictionary, "optional_dictionary_float_type" : floatDictionary, "non_optional_dictionary_string_type" : stringDictionary, "non_optional_dictionary_int_type" : intDictionary, "non_optional_dictionary_double_type" : doubleDictionary, "non_optional_dictionary_float_type" : floatDictionary]
        
        let testObjectInstance = TestObjectTen(dataDictionary)
        
        for (key, stringValue) in stringDictionary {
            XCTAssertEqual(testObjectInstance!.optionalDictionaryStringType![key]!, stringValue, "Optional String value was parsed incorrectly from dictionary")
        }
        
        for (key, intValue) in intDictionary {
            XCTAssertEqual(testObjectInstance!.optionalDictionaryIntType![key]!, intValue, "Optional Int value was parsed incorrectly from dictionary")
        }
        
        for (key, floatValue) in floatDictionary {
            XCTAssertEqual(testObjectInstance!.optionalDictionaryFloatType![key]!, floatValue, "Optional Float value was parsed incorrectly from dictionary")
        }
        
        for (key, doubleValue) in doubleDictionary {
            XCTAssertEqual(testObjectInstance!.optionalDictionaryDoubleType![key]!, doubleValue, "Optional Double value was parsed incorrectly from dictionary")
        }
        
        for (key, stringValue) in stringDictionary {
            XCTAssertEqual(testObjectInstance!.non_optionalDictionaryStringType[key]!, stringValue, "Non-Optional String value was parsed incorrectly from dictionary")
        }
        
        for (key, intValue) in intDictionary {
            XCTAssertEqual(testObjectInstance!.non_optionalDictionaryIntType[key]!, intValue, "Non-Optional Int value was parsed incorrectly from dictionary")
        }
        
        for (key, floatValue) in floatDictionary {
            XCTAssertEqual(testObjectInstance!.non_optionalDictionaryFloatType[key]!, floatValue, "Non-Optional Float value was parsed incorrectly from dictionary")
        }
        
        for (key, doubleValue) in doubleDictionary {
            XCTAssertEqual(testObjectInstance!.non_optionalDictionaryDoubleType[key]!, doubleValue, "Non-Optional Double value was parsed incorrectly from dictionary")
        }
    }
    
    func testDictionarySimpleSubtypeFromArrayMapping() {
        let stringArray = ["String1", "String2", "String3"]
        let intArray = [1, 2, 3]
        let doubleArray = [Double(4.0), Double(5.0), Double(6.0)]
        let floatArray = [Float(7.0), Float(8.0), Float(9.0)]
        
        let dataDictionary : Dictionary<String, AnyObject> = ["optional_dictionary_string_type" : stringArray, "optional_dictionary_int_type" : intArray, "optional_dictionary_double_type" : doubleArray, "optional_dictionary_float_type" : floatArray, "non_optional_dictionary_string_type" : stringArray, "non_optional_dictionary_int_type" : intArray, "non_optional_dictionary_double_type" : doubleArray, "non_optional_dictionary_float_type" : floatArray]
        
        let testObjectInstance = TestObjectTen(dataDictionary)
        
        XCTAssertEqual(testObjectInstance!.optionalDictionaryStringType!["0"]!, "String1", "Optional String value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryStringType!["1"]!, "String2", "Optional String value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryStringType!["2"]!, "String3", "Optional String value was parsed incorrectly from Array")
        
        XCTAssertEqual(testObjectInstance!.optionalDictionaryIntType!["0"]!, 1, "Optional Int value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryIntType!["1"]!, 2, "Optional Int value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryIntType!["2"]!, 3, "Optional Int value was parsed incorrectly from Array")
        
        XCTAssertEqual(testObjectInstance!.optionalDictionaryDoubleType!["0"]!, Double(4.0), "Optional Double value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryDoubleType!["1"]!, Double(5.0), "Optional Double value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryDoubleType!["2"]!, Double(6.0), "Optional Double value was parsed incorrectly from Array")
        
        XCTAssertEqual(testObjectInstance!.optionalDictionaryFloatType!["0"]!, Float(7.0), "Optional Float value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryFloatType!["1"]!, Float(8.0), "Optional Float value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.optionalDictionaryFloatType!["2"]!, Float(9.0), "Optional Float value was parsed incorrectly from Array")
        
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryStringType["0"]!, "String1", "Non-Optional String value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryStringType["1"]!, "String2", "Optional String value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryStringType["2"]!, "String3", "Optional String value was parsed incorrectly from Array")
        
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryIntType["0"]!, 1, "Optional Int value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryIntType["1"]!, 2, "Optional Int value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryIntType["2"]!, 3, "Optional Int value was parsed incorrectly from Array")
        
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryDoubleType["0"]!, Double(4.0), "Optional Double value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryDoubleType["1"]!, Double(5.0), "Optional Double value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryDoubleType["2"]!, Double(6.0), "Optional Double value was parsed incorrectly from Array")
        
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryFloatType["0"]!, Float(7.0), "Optional Float value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryFloatType["1"]!, Float(8.0), "Optional Float value was parsed incorrectly from Array")
        XCTAssertEqual(testObjectInstance!.non_optionalDictionaryFloatType["2"]!, Float(9.0), "Optional Float value was parsed incorrectly from Array")
    }
    
    func testNestedMapping() {
        // TestObjectTwelve is mapped with nested key values
        let final_value_dictionary = ["non_optional_int" : 50, "non_optional_string" : "TestString", "non_optional_double" : 70.0, "non_optional_float" : 80.0, "non_optional_bool" : false]
        
        let testObjectdictionary = ["top_level_key" : final_value_dictionary]
        let testObjectInstance = TestObjectEleven(testObjectdictionary)
        
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
    
    func testNestedAndNonNestedMapping() {
        // TestObjectTwelve is mapped with nested and non nested key values
        let final_value_dictionary = ["non_optional_double" : 70.0, "non_optional_float" : 80.0, "non_optional_bool" : false]
        
        let testObjectdictionary = ["top_level_key" : final_value_dictionary, "non_optional_int" : 50, "non_optional_string" : "TestString"]
        let testObjectInstance = TestObjectTwelve(testObjectdictionary as! Dictionary<String, AnyObject>)
        
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


}
