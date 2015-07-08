//
//  US2Mapper12Tests.swift
//  US2Mapper12Tests
//
//  Created by Anton on 7/8/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//


import XCTest

class US2Mapper12OSXTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func test_retrieveMappingConfiguration() {
        var mapping = US2Mapper.retrieveMappingConfiguration("TestObjectFive")
        XCTAssertNotNil(mapping, "Configuration Not Found")
        
        if let propertyMapping = mapping["optionalSubType"] as Dictionary<String, AnyObject>? {
            if let optionalSubtypeMapping = propertyMapping["optionalSubType"] as? Dictionary<String, String>  {
              
              XCTAssertEqual(count(optionalSubtypeMapping), 2, "Missing String values - Failing Method parsedDictionaryOfNativeValuesArray()")
            }
            
            if let nonoptionalSubtypeMapping = propertyMapping["non_optionalSubType"] as? Dictionary<String, String> {
                XCTAssertEqual(count(nonoptionalSubtypeMapping), 3, "Missing String values - Failing Method parsedDictionaryOfNativeValuesArray()")
            }
        }
    }
    
    func test_dictionaryValueForKey() {
        let first_level_dictionary = ["non_optional_int" : 50, "non_optional_string" : "TestString", "non_optional_double" : 70.0, "non_optional_float" : 80.0, "non_optional_bool" : false]
        
        let secondary_level_dictionary = ["top_level_key" : first_level_dictionary]
        
        let primaryLevelValue = US2Mapper.dictionaryValueForKey("non_optional_int", data: first_level_dictionary) as! Int
        let secondaryLevelValue  = US2Mapper.dictionaryValueForKey("top_level_key.non_optional_int", data: secondary_level_dictionary) as! Int
        
        XCTAssertEqual(primaryLevelValue, 50, "Primary Level Value Incorrectly Returned")
        XCTAssertEqual(secondaryLevelValue, 50, "Secondary Level Value Incorrectly Returned")
    }
    
    func test_dictionaryFromDictionaryOfDictionaries() {
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        let object2Dictionary = ["non_optional_int" : 110, "non_optional_string" : "TestString3", "non_optional_double" : 120.0, "non_optional_float" : 130.0, "non_optional_bool" : true]
        let dataDictionary : Dictionary<String, AnyObject> = ["optional_sub_object_dictionary" : object1Dictionary, "non_optional_sub_object_dictionary" : object2Dictionary]
        
        let parsedDictionary = US2Mapper.dictionaryFromDictionaryOfDictionaries("TestObjectFour", data: dataDictionary)
        
        let instanceOne = parsedDictionary["0"] as? TestObjectFour
        let instanceTwo = parsedDictionary["1"] as? TestObjectFour
        
        XCTAssertEqual(instanceOne!.non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly - Failing Method dictionaryFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalDouble, Double(60.0), "Non-Optional Double value was parsed incorrectly - Failing Method dictionaryFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalFloat, Float(70.0), "Non-Optional Float value was parsed incorrectly - Failing Method dictionaryFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalString, "TestString1", "Non-Optional String value was parsed incorrectly - Failing Method dictionaryFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly - Failing Method dictionaryFromDictionaryOfDictionaries()")
        
        XCTAssertEqual(instanceTwo!.non_optionalInt, Int(110), "Non-Optional Int value was parsed incorrectly - Failing Method dictionaryFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalDouble, Double(120.0), "Non-Optional Double value was parsed incorrectly - Failing Method dictionaryFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalFloat, Float(130.0), "Non-Optional Float value was parsed incorrectly - Failing Method dictionaryFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalString, "TestString3", "Non-Optional String value was parsed incorrectly - Failing Method dictionaryFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly - Failing Method dictionaryFromDictionaryOfDictionaries()")
    }
    
    func test_dictionaryFromArrayOfDictionaries() {
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        let object2Dictionary = ["non_optional_int" : 110, "non_optional_string" : "TestString3", "non_optional_double" : 120.0, "non_optional_float" : 130.0, "non_optional_bool" : true]
        
        let dataArray : Array<AnyObject> = [object1Dictionary, object2Dictionary]
        
        let parsedDictionary = US2Mapper.dictionaryFromArrayOfDictionaries("TestObjectFour", data: dataArray)
        
        let instanceOne = parsedDictionary["0"] as? TestObjectFour
        let instanceTwo = parsedDictionary["1"] as? TestObjectFour
        
        XCTAssertEqual(instanceOne!.non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly - Failing Method dictionaryFromArrayOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalDouble, Double(60.0), "Non-Optional Double value was parsed incorrectly - Failing Method dictionaryFromArrayOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalFloat, Float(70.0), "Non-Optional Float value was parsed incorrectly - Failing Method dictionaryFromArrayOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalString, "TestString1", "Non-Optional String value was parsed incorrectly - Failing Method dictionaryFromArrayOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly - Failing Method dictionaryFromArrayOfDictionaries()")
        
        XCTAssertEqual(instanceTwo!.non_optionalInt, Int(110), "Non-Optional Int value was parsed incorrectly - Failing Method dictionaryFromArrayOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalDouble, Double(120.0), "Non-Optional Double value was parsed incorrectly - Failing Method dictionaryFromArrayOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalFloat, Float(130.0), "Non-Optional Float value was parsed incorrectly - Failing Method dictionaryFromArrayOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalString, "TestString3", "Non-Optional String value was parsed incorrectly - Failing Method dictionaryFromArrayOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly")
    }
    
    func test_arrayFromArrayOfDictionaries() {
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        let object2Dictionary = ["non_optional_int" : 110, "non_optional_string" : "TestString3", "non_optional_double" : 120.0, "non_optional_float" : 130.0, "non_optional_bool" : true]
        
        let dataArray : Array<AnyObject> = [object1Dictionary, object2Dictionary]
        
        let parsedArray = US2Mapper.arrayFromArrayOfDictionaries("TestObjectFour", data: dataArray)
        
        let instanceOne = parsedArray[0] as? TestObjectFour
        let instanceTwo = parsedArray[1] as? TestObjectFour
        
        XCTAssertEqual(instanceOne!.non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly - Failing Method arrayFromArrayOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalDouble, Double(60.0), "Non-Optional Double value was parsed incorrectly - Failing Method arrayFromArrayOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalFloat, Float(70.0), "Non-Optional Float value was parsed incorrectly - Failing Method arrayFromArrayOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalString, "TestString1", "Non-Optional String value was parsed incorrectly - Failing Method arrayFromArrayOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly - Failing Method arrayFromArrayOfDictionaries()")
        
        XCTAssertEqual(instanceTwo!.non_optionalInt, Int(110), "Non-Optional Int value was parsed incorrectly - Failing Method arrayFromArrayOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalDouble, Double(120.0), "Non-Optional Double value was parsed incorrectly - Failing Method arrayFromArrayOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalFloat, Float(130.0), "Non-Optional Float value was parsed incorrectly - Failing Method arrayFromArrayOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalString, "TestString3", "Non-Optional String value was parsed incorrectly - Failing Method arrayFromArrayOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly - Failing Method arrayFromArrayOfDictionaries()")
    }
    
    func test_arrayFromDictionaryOfDictionaries() {
        
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        let object2Dictionary = ["non_optional_int" : 110, "non_optional_string" : "TestString3", "non_optional_double" : 120.0, "non_optional_float" : 130.0, "non_optional_bool" : true]
        let dataDictionary : Dictionary<String, AnyObject> = ["0" : object1Dictionary, "1" : object2Dictionary]
        
        let parsedArray = US2Mapper.arrayFromDictionaryOfDictionaries("TestObjectFour", data: dataDictionary)
        
        let instanceOne = parsedArray[0] as? TestObjectFour
        let instanceTwo = parsedArray[1] as? TestObjectFour
        
        XCTAssertEqual(instanceOne!.non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly - Failing Method arrayFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalDouble, Double(60.0), "Non-Optional Double value was parsed incorrectly - Failing Method arrayFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalFloat, Float(70.0), "Non-Optional Float value was parsed incorrectly - Failing Method arrayFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalString, "TestString1", "Non-Optional String value was parsed incorrectly - Failing Method arrayFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly - Failing Method arrayFromDictionaryOfDictionaries()")
        
        XCTAssertEqual(instanceTwo!.non_optionalInt, Int(110), "Non-Optional Int value was parsed incorrectly - Failing Method arrayFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalDouble, Double(120.0), "Non-Optional Double value was parsed incorrectly - Failing Method arrayFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalFloat, Float(130.0), "Non-Optional Float value was parsed incorrectly - Failing Method arrayFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalString, "TestString3", "Non-Optional String value was parsed incorrectly - Failing Method arrayFromDictionaryOfDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly ")
    }
    
    func test_parsedDictionaryOfNativeValueDictionary() {
        let stringDictionary = ["1" : "String1", "2" : "String2", "3" : "String3"]
        let intDictionary = ["1" : 1, "2" : 2, "3" : 3]
        let doubleDictionary = ["1" : Double(4.0), "2" : Double(5.0), "3" : Double(6.0)]
        let floatDictionary = ["1" : Float(7.0), "2" : Float(8.0), "3" : Float(9.0)]
        let boolDictionary = ["1" : true, "2" : false, "3" :true]
        
        let returnedStringDictionary = US2Mapper.parsedDictionaryOfNativeValueDictionary(stringDictionary)
        let returnedIntDictionary = US2Mapper.parsedDictionaryOfNativeValueDictionary(intDictionary)
        let returnedDoubleDictionary = US2Mapper.parsedDictionaryOfNativeValueDictionary(doubleDictionary)
        let returnedFloatDictionary = US2Mapper.parsedDictionaryOfNativeValueDictionary(floatDictionary)
        let returnedBoolDictionary = US2Mapper.parsedDictionaryOfNativeValueDictionary(boolDictionary)
        
        for (key, stringValue) in stringDictionary {
            XCTAssertEqual(returnedStringDictionary[key] as! String, stringValue, "String values was parsed incorrectly - Failing Method parsedDictionaryOfNativeValueDictionary()")
        }
        
        for (key, stringValue) in intDictionary {
            XCTAssertEqual(returnedIntDictionary[key] as! Int, stringValue, "Int values was parsed incorrectly - Failing Method parsedDictionaryOfNativeValueDictionary()")
        }
        
        for (key, stringValue) in doubleDictionary {
            XCTAssertEqual(returnedDoubleDictionary[key] as! Double, stringValue, "Double values was parsed incorrectly - Failing Method parsedDictionaryOfNativeValueDictionary()")
        }
        
        for (key, stringValue) in floatDictionary {
            XCTAssertEqual(returnedFloatDictionary[key] as! Float, stringValue, "Float values was parsed incorrectly - Failing Method parsedDictionaryOfNativeValueDictionary()")
        }
        
        for (key, stringValue) in boolDictionary {
            XCTAssertEqual(returnedBoolDictionary[key] as! Bool, stringValue, "Bool values was parsed incorrectly - Failing Method parsedDictionaryOfNativeValueDictionary()")
        }
    }
    
    func test_parsedDictionaryOfNativeValuesArray() {
        let stringArray = ["String1", "String2", "String3"]
        let intArray = [1,  2,  3]
        let doubleArray = [ Double(4.0), Double(5.0), Double(6.0)]
        let floatArray = [Float(7.0),Float(8.0), Float(9.0)]
        let boolArray = [true, true, true]
        
        let returnedStringDictionary = US2Mapper.parsedDictionaryOfNativeValuesArray(stringArray)
        let returnedIntDictionary = US2Mapper.parsedDictionaryOfNativeValuesArray(intArray)
        let returnedDoubleDictionary = US2Mapper.parsedDictionaryOfNativeValuesArray(doubleArray)
        let returnedFloatDictionary = US2Mapper.parsedDictionaryOfNativeValuesArray(floatArray)
        let returnedBoolDictionary = US2Mapper.parsedDictionaryOfNativeValuesArray(boolArray)
        
        for (_, stringValue) in returnedStringDictionary {
            XCTAssertTrue(contains(stringArray, stringValue as! String), "String values parsed incorrectly - Failing Method parsedDictionaryOfNativeValuesArray()")
        }
        
        XCTAssertEqual(count(returnedStringDictionary), stringArray.count, "Missing String values - Failing Method parsedDictionaryOfNativeValuesArray()")
        
        for (_, integerVal) in returnedIntDictionary {
            XCTAssertTrue(contains(intArray, integerVal as! Int), "Int values parsed incorrectly - Failing Method parsedDictionaryOfNativeValuesArray()")
        }
        
        XCTAssertEqual(count(returnedIntDictionary), intArray.count, "Missing Int values - Failing Method parsedDictionaryOfNativeValuesArray()")
        
        for (_, doubleValue) in returnedDoubleDictionary {
            XCTAssertTrue(contains(doubleArray, doubleValue as! Double), "Double values parsed incorrectly - Failing Method parsedDictionaryOfNativeValuesArray()")
        }
        
        XCTAssertEqual(count(returnedDoubleDictionary), doubleArray.count, "Missing Double values - Failing Method parsedDictionaryOfNativeValuesArray()")
        
        for (_, floatVal) in returnedFloatDictionary {
            XCTAssertTrue(contains(floatArray, floatVal as! Float), "Float values parsed incorrectly - Failing Method parsedDictionaryOfNativeValuesArray()")
        }
        
        XCTAssertEqual(count(returnedFloatDictionary), floatArray.count, "Missing Float values - Failing Method parsedDictionaryOfNativeValuesArray()")
        
        for (_, value) in returnedBoolDictionary {
            XCTAssertEqual(value as! Bool, true, "Bool values parsed incorrectly - Failing Method parsedDictionaryOfNativeValuesArray()")
        }
        
        XCTAssertEqual(count(returnedBoolDictionary), boolArray.count, "Missing Bool values - Failing Method parsedDictionaryOfNativeValuesArray()")
    }

    func test_parsedArrayOfNativeValuesArray() {
        let stringArray = ["String1", "String2", "String3"]
        let intArray = [1,  2,  3]
        let doubleArray = [ Double(4.0), Double(5.0), Double(6.0)]
        let floatArray = [Float(7.0),Float(8.0), Float(9.0)]
        let boolArray = [true, true, true]
        
        let returnedStringArray = US2Mapper.parsedArrayOfNativeValuesArray(stringArray)
        let returnedIntArray = US2Mapper.parsedArrayOfNativeValuesArray(intArray)
        let returnedDoubleArray = US2Mapper.parsedArrayOfNativeValuesArray(doubleArray)
        let returnedFloatArray = US2Mapper.parsedArrayOfNativeValuesArray(floatArray)
        let returnedBoolArray = US2Mapper.parsedArrayOfNativeValuesArray(boolArray)
        
        for stringValue in returnedStringArray {
            XCTAssertTrue(contains(stringArray, stringValue as! String), "String values parsed incorrectly - Failing Method parsedArrayOfNativeValuesArray()")
        }
        
        XCTAssertEqual(returnedStringArray.count, stringArray.count, "Missing String values - Failing Method parsedArrayOfNativeValuesArray()")
        
        for integerVal in returnedIntArray {
            XCTAssertTrue(contains(intArray, integerVal as! Int), "Int values parsed incorrectly - Failing Method parsedArrayOfNativeValuesArray()")
        }
        
        XCTAssertEqual(count(returnedIntArray), intArray.count, "Missing Int values - Failing Method parsedArrayOfNativeValuesArray()")
        
        for doubleValue in returnedDoubleArray {
            XCTAssertTrue(contains(doubleArray, doubleValue as! Double), "Double values parsed incorrectly - Failing Method parsedArrayOfNativeValuesArray()")
        }
        
        XCTAssertEqual(count(returnedDoubleArray), doubleArray.count, "Missing Double values - Failing Method parsedArrayOfNativeValuesArray()")
        
        for floatVal in returnedFloatArray {
            XCTAssertTrue(contains(floatArray, floatVal as! Float), "Float values parsed incorrectly - Failing Method parsedArrayOfNativeValuesArray()")
        }
        
        XCTAssertEqual(count(returnedFloatArray), floatArray.count, "Missing Float values - Failing Method parsedArrayOfNativeValuesArray()")
        
        for boolVal in returnedBoolArray {
            XCTAssertEqual(boolVal as! Bool, true, "Bool values parsed incorrectly - Failing Method parsedArrayOfNativeValuesArray()")
        }
        
        XCTAssertEqual(count(returnedBoolArray), boolArray.count, "Missing Bool values - Failing Method parsedArrayOfNativeValuesArray()")
    }

    func test_parsedArrayOfNativeValuesDictionary() {
        let stringDictionary = ["1" : "String1", "2" : "String2", "3" : "String3"]
        let intDictionary = ["1" : 1, "2" : 2, "3" : 3]
        let doubleDictionary = ["1" : Double(4.0), "2" : Double(5.0), "3" : Double(6.0)]
        let floatDictionary = ["1" : Float(7.0), "2" : Float(8.0), "3" : Float(9.0)]
        let boolDictionary = ["1" : true, "2" : true, "3" :true]
        
        let returnedStringArray = US2Mapper.parsedArrayFromNativeValuesDictionary(stringDictionary) as! [String]
        let returnedIntArray = US2Mapper.parsedArrayFromNativeValuesDictionary(intDictionary)  as! [Int]
        let returnedDoubleArray = US2Mapper.parsedArrayFromNativeValuesDictionary(doubleDictionary)  as! [Double]
        let returnedFloatArray = US2Mapper.parsedArrayFromNativeValuesDictionary(floatDictionary)  as! [Float]
        let returnedBoolArray = US2Mapper.parsedArrayFromNativeValuesDictionary(boolDictionary)  as! [Bool]
        
        for (_, stringValue) in stringDictionary {
            XCTAssertTrue(contains(returnedStringArray, stringValue), "String values parsed incorrectly - Failing Method parsedArrayOfNativeValuesDictionary()")
        }
        
        XCTAssertEqual(count(returnedStringArray), count(stringDictionary), "Missing String values -  Failing Method parsedArrayOfNativeValuesDictionary()")
        
        
        for (_, intVal) in intDictionary {
            XCTAssertTrue(contains(returnedIntArray, intVal), "Int values parsed incorrectly - Failing Method parsedArrayOfNativeValuesDictionary()")
        }
        
        XCTAssertEqual(count(returnedIntArray), count(intDictionary), "Missing Int values -  Failing Method parsedArrayOfNativeValuesDictionary()")
        
        
        for (_, doubleVal) in doubleDictionary {
            XCTAssertTrue(contains(returnedDoubleArray, doubleVal), "Double values parsed incorrectly - Failing Method parsedArrayOfNativeValuesDictionary()")
        }
        
        XCTAssertEqual(count(returnedDoubleArray),  count(doubleDictionary), "Missing Double values -  Failing Method parsedArrayOfNativeValuesDictionary()")
        
        
        for (_, floatValue) in floatDictionary {
            XCTAssertTrue(contains(returnedFloatArray, floatValue), "Float values parsed incorrectly - Failing Method parsedArrayOfNativeValuesDictionary() ")
        }
        
        XCTAssertEqual(count(returnedFloatArray),  count(floatDictionary), "Missing Float values -  Failing Method parsedArrayOfNativeValuesDictionary()")
        
        
        for boolVal in returnedBoolArray {
            XCTAssertEqual(boolVal, true, "Bool values parsed incorrectly - Failing Method parsedArrayOfNativeValuesDictionary()")
        }
        
        XCTAssertEqual(count(returnedBoolArray), count(boolDictionary), "Missing Bool values -  Failing Method parsedArrayOfNativeValuesDictionary()")
    }

    func test_complexTransformValue(){
        let dataDictionary = ["left_hand_string" : "Left-String-", "right_hand_string" : "Right-String"]
        let jsonKeys = ["left_hand_string", "right_hand_string"]
        let compoundString = US2Mapper.complexTransformValue("UTCompoundValueMapper", jsonKeys: jsonKeys, data: dataDictionary) as? String
        XCTAssertEqual(compoundString!, "Left-String-Right-String", "Compount Value Mapper returned incorrect Value - Failing Method complexTransformValue()")
    }
    
    func test_parsedDictionaryFromSingleComplexValueDictionary() {
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        
        let parsedDictionary = US2Mapper.parsedDictionaryFromSingleComplexValueDictionary("TestObjectFour", singleDictionary: object1Dictionary)
        let instanceOne = parsedDictionary["0"] as? TestObjectFour
        
        XCTAssertEqual(instanceOne!.non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly - Failing Method parsedDictionaryFromSingleComplexValueDictionary()")
        XCTAssertEqual(instanceOne!.non_optionalDouble, Double(60.0), "Non-Optional Double value was parsed incorrectly - Failing Method parsedDictionaryFromSingleComplexValueDictionary()")
        XCTAssertEqual(instanceOne!.non_optionalFloat, Float(70.0), "Non-Optional Float value was parsed incorrectly - Failing Method parsedDictionaryFromSingleComplexValueDictionary()")
        XCTAssertEqual(instanceOne!.non_optionalString, "TestString1", "Non-Optional String value was parsed incorrectly - Failing Method parsedDictionaryFromSingleComplexValueDictionary()")
        XCTAssertEqual(instanceOne!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly - Failing Method parsedDictionaryFromSingleComplexValueDictionary()")
    }
    
    func test_parsedArrayFromDictionaryOfComplexValueDictionaries() {
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        let object2Dictionary = ["non_optional_int" : 110, "non_optional_string" : "TestString3", "non_optional_double" : 120.0, "non_optional_float" : 130.0, "non_optional_bool" : true]
        
        let dataDictionary : Dictionary<String, Dictionary<String, AnyObject>> = ["0" : object1Dictionary, "1" : object2Dictionary]
        let parsedDictionary = US2Mapper.parsedArrayFromDictionaryOfComplexValueDictionaries("TestObjectFour", dataDictionary: dataDictionary)
        
        let instanceOne = parsedDictionary[0] as? TestObjectFour
        let instanceTwo = parsedDictionary[1] as? TestObjectFour
        
        XCTAssertEqual(instanceOne!.non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly - Failing Method parsedArrayFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalDouble, Double(60.0), "Non-Optional Double value was parsed incorrectly - Failing Method parsedArrayFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalFloat, Float(70.0), "Non-Optional Float value was parsed incorrectly - Failing Method parsedArrayFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalString, "TestString1", "Non-Optional String value was parsed incorrectly - Failing Method parsedArrayFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly - Failing Method parsedArrayFromDictionaryOfComplexValueDictionaries()")
        
        XCTAssertEqual(instanceTwo!.non_optionalInt, Int(110), "Non-Optional Int value was parsed incorrectly - Failing Method parsedArrayFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalDouble, Double(120.0), "Non-Optional Double value was parsed incorrectly - Failing Method parsedArrayFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalFloat, Float(130.0), "Non-Optional Float value was parsed incorrectly - Failing Method parsedArrayFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalString, "TestString3", "Non-Optional String value was parsed incorrectly - Failing Method parsedArrayFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly - Failing Method parsedArrayFromDictionaryOfComplexValueDictionaries()")
    }
    
    func text_parsedArrayFromArrayOfComplexValueDictionaries() {
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        let object2Dictionary = ["non_optional_int" : 110, "non_optional_string" : "TestString3", "non_optional_double" : 120.0, "non_optional_float" : 130.0, "non_optional_bool" : true]
        
        let dataDictionaryArray : [Dictionary<String, AnyObject>] = [object1Dictionary, object2Dictionary]
        let parsedDictionary = US2Mapper.parsedArrayFromArrayOfComplexValueDictionaries("TestObjectFour", dataArray: dataDictionaryArray)
        
        let instanceOne = parsedDictionary[0] as? TestObjectFour
        let instanceTwo = parsedDictionary[1] as? TestObjectFour
        
        XCTAssertEqual(instanceOne!.non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly - Failing Method parsedArrayFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalDouble, Double(60.0), "Non-Optional Double value was parsed incorrectly - Failing Method parsedArrayFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalFloat, Float(70.0), "Non-Optional Float value was parsed incorrectly - Failing Method parsedArrayFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalString, "TestString1", "Non-Optional String value was parsed incorrectly - Failing Method parsedArrayFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly - Failing Method parsedArrayFromArrayOfComplexValueDictionaries()")
        
        XCTAssertEqual(instanceTwo!.non_optionalInt, Int(110), "Non-Optional Int value was parsed incorrectly - Failing Method parsedArrayFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalDouble, Double(120.0), "Non-Optional Double value was parsed incorrectly - Failing Method parsedArrayFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalFloat, Float(130.0), "Non-Optional Float value was parsed incorrectly - Failing Method parsedArrayFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalString, "TestString3", "Non-Optional String value was parsed incorrectly - Failing Method parsedArrayFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly - Failing Method parsedArrayFromArrayOfComplexValueDictionaries()")
    }
    
    func test_parsedDictionaryFromArrayOfComplexValueDictionaries() {
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        let object2Dictionary = ["non_optional_int" : 110, "non_optional_string" : "TestString3", "non_optional_double" : 120.0, "non_optional_float" : 130.0, "non_optional_bool" : true]
        
        let dataArray : Array<Dictionary<String, AnyObject>> = [object1Dictionary, object2Dictionary]
        
        let parsedDictionary = US2Mapper.parsedDictionaryFromArrayOfComplexValueDictionaries("TestObjectFour", dataArray: dataArray)
        
        let instanceOne = parsedDictionary["0"] as? TestObjectFour
        let instanceTwo = parsedDictionary["1"] as? TestObjectFour
        
        XCTAssertEqual(instanceOne!.non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly - Failing Method parsedDictionaryFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalDouble, Double(60.0), "Non-Optional Double value was parsed incorrectly - Failing Method parsedDictionaryFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalFloat, Float(70.0), "Non-Optional Float value was parsed incorrectly - Failing Method parsedDictionaryFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalString, "TestString1", "Non-Optional String value was parsed incorrectly - Failing Method parsedDictionaryFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly - Failing Method parsedDictionaryFromArrayOfComplexValueDictionaries()")
        
        XCTAssertEqual(instanceTwo!.non_optionalInt, Int(110), "Non-Optional Int value was parsed incorrectly - Failing Method parsedDictionaryFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalDouble, Double(120.0), "Non-Optional Double value was parsed incorrectly - Failing Method parsedDictionaryFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalFloat, Float(130.0), "Non-Optional Float value was parsed incorrectly - Failing Method parsedDictionaryFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalString, "TestString3", "Non-Optional String value was parsed incorrectly - Failing Method parsedDictionaryFromArrayOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly - Failing Method parsedDictionaryFromArrayOfComplexValueDictionaries()")
    }
    
    func test_parsedDictionaryFromDictionaryOfComplexValueDictionaries() {
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        let object2Dictionary = ["non_optional_int" : 110, "non_optional_string" : "TestString3", "non_optional_double" : 120.0, "non_optional_float" : 130.0, "non_optional_bool" : true]
        
        let dataDictionary : Dictionary<String, Dictionary<String, AnyObject>> = ["0" : object1Dictionary, "1" : object2Dictionary]
        
        let parsedDictionary = US2Mapper.parsedDictionaryFromDictionaryOfComplexValueDictionaries("TestObjectFour", dataDictionary: dataDictionary)
        
        let instanceOne = parsedDictionary["0"] as? TestObjectFour
        let instanceTwo = parsedDictionary["1"] as? TestObjectFour
        
        XCTAssertEqual(instanceOne!.non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly - Failing Method parsedDictionaryFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalDouble, Double(60.0), "Non-Optional Double value was parsed incorrectly - Failing Method parsedDictionaryFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalFloat, Float(70.0), "Non-Optional Float value was parsed incorrectly - Failing Method parsedDictionaryFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalString, "TestString1", "Non-Optional String value was parsed incorrectly - Failing Method parsedDictionaryFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceOne!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly - Failing Method parsedDictionaryFromDictionaryOfComplexValueDictionaries()")
        
        XCTAssertEqual(instanceTwo!.non_optionalInt, Int(110), "Non-Optional Int value was parsed incorrectly - Failing Method parsedDictionaryFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalDouble, Double(120.0), "Non-Optional Double value was parsed incorrectly - Failing Method parsedDictionaryFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalFloat, Float(130.0), "Non-Optional Float value was parsed incorrectly - Failing Method parsedDictionaryFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalString, "TestString3", "Non-Optional String value was parsed incorrectly - Failing Method parsedDictionaryFromDictionaryOfComplexValueDictionaries()")
        XCTAssertEqual(instanceTwo!.non_optionalBool, true, "Non-Optional Bool value was parsed incorrectly - Failing Method parsedDictionaryFromDictionaryOfComplexValueDictionaries()")
    }
    
    func test_convertDefaultValue() {
        
        let stringToString = "String1"
        let stringToInt = "77"
        let stringToDouble = "42.4722"
        let stringToFloat = "66.494949494"
        let stringToBoolTrue = "true"
        let stringToBoolFalse = "False"
        
        XCTAssertTrue(US2Mapper.convertDefaultValue(stringToString, dataType: "String") as! String == "String1", "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(stringToInt, dataType: "Int") as! Int == 77, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(stringToDouble, dataType: "Double") as! Double == 42.4722, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(stringToFloat, dataType: "Float") as! Float == 66.494949494, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(stringToBoolTrue, dataType: "Bool") as! Bool == true, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(stringToBoolFalse, dataType: "Bool") as! Bool == false, "Failed Method convertDefaultValue()")
        
        let doubleToString : Double = 99.87659
        let doubleToInt : Double = 77.8888
        let doubleToDouble : Double = 42.4722
        let doubleToFloat : Double = 66.494949494
        let doubleToBoolFalse  : Double = 0.0
        let doubleToBoolTrue  : Double = 1.0
        
        XCTAssertTrue(US2Mapper.convertDefaultValue(doubleToString, dataType: "String") as! String == "99.87659", "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(doubleToInt, dataType: "Int") as! Int == 77, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(doubleToDouble, dataType: "Double") as! Double == doubleToDouble, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(doubleToFloat, dataType: "Float") as! Float == 66.494949494, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(doubleToBoolFalse, dataType: "Bool") as! Bool == false, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(doubleToBoolTrue, dataType: "Bool") as! Bool == true, "Failed Method convertDefaultValue()")
        
        let floatToString : Float = 88.7777
        let floatToInt : Float = 77.8888
        let floatToDouble : Float = 42.4722
        let floatToFloat : Float = 66.494949494
        let floatToBoolFalse  : Float = 0.0
        let floatToBoolTrue  : Float = 1.0
        
        XCTAssertTrue(US2Mapper.convertDefaultValue(floatToString, dataType: "String") as! String == "88.7777", "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(floatToInt, dataType: "Int") as! Int == 77, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(floatToDouble, dataType: "Double") as! Float == 42.4722, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(floatToFloat, dataType: "Float") as! Int == 66, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(floatToBoolFalse, dataType: "Bool") as! Bool == false, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(floatToBoolTrue, dataType: "Bool") as! Bool == true, "Failed Method convertDefaultValue()")
        
        let intToString : Int = 88
        let intToInt : Int = 77
        let intToDouble : Int = 42
        let intToFloat : Int = 66
        let intToBoolFalse  : Float = 0
        let intToBoolTrue  : Float = 1
        
        XCTAssertTrue(US2Mapper.convertDefaultValue(intToString, dataType: "String") as! String == "88", "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(intToInt, dataType: "Int") as! Int == 77, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(intToDouble, dataType: "Double") as! Double == 42.0, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(intToFloat, dataType: "Float") as! Float == 66.0, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(intToBoolFalse, dataType: "Bool") as! Bool == false, "Failed Method convertDefaultValue()")
        XCTAssertTrue(US2Mapper.convertDefaultValue(intToBoolTrue, dataType: "Bool") as! Bool == true, "Failed Method convertDefaultValue()")
    }
    
    func test_typeCast() {
        let doublevalue : Double = 10.0
        var stringToString : String? = US2Mapper.typeCast(doublevalue)
        XCTAssertNil(stringToString, "Type Casting Failed, the value should of been nil")
        
        let stringvalue : String = "Hello"
        stringToString = US2Mapper.typeCast(stringvalue)
        XCTAssertEqual(stringToString!, stringvalue, "Type Casting Failed, the values should of been equal")
    }
}
