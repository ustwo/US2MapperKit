//
//  US2Mapper.swift
//  US2Mapper
//
//  Created by Anton on 6/22/15.
//  Copyright © 2015 US2Mapper. All rights reserved.
//

import Foundation

protocol US2MapperProtocol {
    static func transformValues(inputValues : [AnyObject]?) -> AnyObject?
}

extension Array {
    func containsValue<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

var propertyMappings : Dictionary<String, Dictionary<String, Dictionary<String, AnyObject>>> = Dictionary()

let US2MapperJSONKey                 = "key"
let US2MapperTypeKey                 = "type"
let US2MapperNonOptionalKey          = "nonoptional"
let US2MapperDefaultKey              = "default"
let US2MapperMapperKey               = "mapper"
let US2MapperCollectionSubTypeKey    = "collection_subtype"

let UTDataTypeString        = "String"
let UTDataTypeInt           = "Int"
let UTDataTypeDouble        = "Double"
let UTDataTypeFloat         = "Float"
let UTDataTypeBool          = "Bool"
let UTDataTypeArray         = "Array"
let UTDataTypeDictionary    = "Dictionary"

let nativeDataTypes      = [UTDataTypeString, UTDataTypeInt, UTDataTypeDouble, UTDataTypeFloat, UTDataTypeBool]
let collectionTypes      = [UTDataTypeArray, UTDataTypeDictionary]

public class _US2Mapper {

    // MARK Load Mapping Configuration
    
    final class func retrieveMappingConfiguration(className : String) -> Dictionary<String, Dictionary<String, AnyObject>> {
        if let mappingconfiguration = propertyMappings[className] {
            return mappingconfiguration
        } else {
            if let mappingPath = NSBundle(forClass: self).pathForResource(className, ofType: "plist") {
                let tempMapping = NSDictionary(contentsOfFile: mappingPath) as? Dictionary<String, Dictionary<String, AnyObject>>
                propertyMappings[className] = tempMapping
                return tempMapping!
            } else {
                return Dictionary<String, Dictionary<String, AnyObject>>()
            }
        }
    }
    
    // Parse Dictionary Data for the specific class
    public final class func parseJSONResponse(className : String, data : Dictionary<String, AnyObject>) -> Dictionary<String, AnyObject>? {
        
        // The Mapping configuration for the Class
        let mappingConfiguration = retrieveMappingConfiguration(className)
        
        // Return nil if the mapping configuration is missing
        if mappingConfiguration.keys.isEmpty { return nil }
        
        // Dictionary of values to be returned
        var propertyValueDictionary = Dictionary<String, AnyObject>()
        
        // Iterate over the properties accordingly
        for (propertyKey, propertyMapping) in mappingConfiguration {
            
            // Check if complex transform mapper class exists
            if let transformClass = propertyMapping[US2MapperMapperKey] as? String {
                if let jsonKeys = propertyMapping[US2MapperJSONKey] as? [String] {
                    if let transformedValue: AnyObject = complexTransformValue(transformClass, jsonKeys : jsonKeys, data: data) {
                        propertyValueDictionary[propertyKey] = transformedValue;
                    }
                }
            }
            
            if let jsonKey = propertyMapping[US2MapperJSONKey] as? String {
                if let dataType = propertyMapping[US2MapperTypeKey]  as? String {
                    let subType = propertyMapping[US2MapperCollectionSubTypeKey] as? String
                    
                    if let retrievedJSONValue: AnyObject = dictionaryValueForKey(jsonKey, data: data) {
                        // If a value was retireced from the response dictionary, parse it accodingly to Type / Potential Subtype
                        propertyValueDictionary[propertyKey] = parsePropertyValue(retrievedJSONValue, dataType, subType)
                    } else if let retrievedMappingDefaultValue: AnyObject = propertyMapping[US2MapperDefaultKey] {
                        // If a default value was configured in the mapping configuration, parse it accodingly to Type / Potential Subtype
                        propertyValueDictionary[propertyKey] = parsePropertyValue(retrievedMappingDefaultValue, dataType, subType)
                    }
                }
            }
        }
        
        // Validate that all non-optional properties have a value assigned
        for (propertyKey, propertyMapping) in mappingConfiguration {
            if let isPropertyNonOptional : AnyObject = propertyMapping[US2MapperNonOptionalKey] {
                if isPropertyNonOptional.boolValue == true {
                    if let _ = propertyValueDictionary[propertyKey] {
                        // If value was mapped, continue with validation
                        continue
                    } else {
                        return nil
                    }
                }
            }
        }
        
        return propertyValueDictionary
    }
    
    
    // MARK Retrieve Dictionary Value For Assignment Methods
    
    final class func dictionaryValueForKey(key : String, data : Dictionary<String, AnyObject>) -> AnyObject? {
        var keys = key.componentsSeparatedByString(".")
        var nestedDictionary = data
        
        for var x = 0; x < keys.count; x++ {
            if x >= (keys.count - 1) {
                if let finalValue: AnyObject = nestedDictionary[keys[x]] {
                    return finalValue
                } else {
                    break
                }
            } else if let nextLevelDictionary = nestedDictionary[keys[x]] as? Dictionary<String, AnyObject> {
                nestedDictionary = nextLevelDictionary
            } else {
                break
            }
        }
        return nil
    }
    
    
    // MARK Parse Value Types Methods
    
    final class func parsePropertyValue(value : AnyObject, _ dataType : String, _ subType: String?) -> AnyObject? {
        if nativeDataTypes.containsValue(dataType) {
            return convertDefaultValue(value, dataType: dataType)
        } else if collectionTypes.containsValue(dataType) {
            return parseCollection(dataType, subType!, value)
        } else if let complexTypeValue: AnyObject = classFromString(dataType, data: value as! Dictionary<String, AnyObject>) {
            return complexTypeValue
        }
        return nil
    }
    
    final class func parseCollection(collectionType: String, _ subCollectionType : String, _ data : AnyObject) -> AnyObject? {
        if let subDictionary = data as? Dictionary<String, AnyObject> {
            switch collectionType {
            case UTDataTypeArray:
                return parseCollectionToArray(subCollectionType, data: subDictionary)
            case UTDataTypeDictionary:
                return parseCollectionToDictionary(subCollectionType, data: subDictionary)
            default:
                return nil
            }
        } else if let subValueArray = data as? Array<AnyObject> {
            switch collectionType {
            case UTDataTypeArray:
                return parseCollectionToArray(subCollectionType, data: subValueArray)
            case UTDataTypeDictionary:
                return parseCollectionToDictionary(subCollectionType, data: subValueArray)
            default:
                return nil
            }
        }
        return nil
    }
    
    // MARK Collection Values
    
    final class func parseCollectionToDictionary(subCollectionType : String, data : Dictionary<String, AnyObject>)  -> Dictionary<String, AnyObject> {
        if nativeDataTypes.containsValue(subCollectionType) {
            return dictionaryOfNativeValues(data)
        } else if let subObjectDictionary = data as? Dictionary<String, Dictionary <String, AnyObject>> {
            return dictionaryOfComplexValues(subCollectionType, data: subObjectDictionary)
        } else {
            return dictionaryOfComplexValues(subCollectionType, data: data)
        }
    }
    
    final class func parseCollectionToDictionary(subCollectionType : String, data : Array<AnyObject>) -> Dictionary<String, AnyObject>  {
        if nativeDataTypes.containsValue(subCollectionType) {
            return dictionaryOfNativeValues(data)
        } else if let subObjectArray = data as? Array<Dictionary <String, AnyObject>> {
            return dictionaryOfComplexValues(subCollectionType, data : subObjectArray)
        } else {
            return Dictionary<String, AnyObject>()
        }
    }
    
    final class func parseCollectionToArray(subCollectionType : String, data : Array<AnyObject>) -> [AnyObject] {
        if nativeDataTypes.containsValue(subCollectionType) {
            return arrayOfNativeValues(data)
        } else if let subObjectArray = data as? Array<Dictionary <String, AnyObject>> {
            return arrayOfComplexValues(subCollectionType, data : subObjectArray)
        }
        return []
    }
    
    final class func parseCollectionToArray(subCollectionType : String, data : Dictionary<String, AnyObject>) -> [AnyObject] {
        if nativeDataTypes.containsValue(subCollectionType) {
            return arrayOfNativeValues(data)
        } else if let subObjectDictionary = data as? Dictionary<String, Dictionary <String, AnyObject>> {
            return arrayOfComplexValues(subCollectionType, data : subObjectDictionary)
        }
        return []
    }
    
    
    // MARK Array Parsing from Collections
    
    final  class func arrayOfNativeValues(data : Array<AnyObject>) -> [AnyObject] {
        var valueArray : [AnyObject] = []
        
        for value in data {
            valueArray.append(value)
        }
        return valueArray
    }
    
    final class func arrayOfNativeValues(data : Dictionary<String, AnyObject>) -> [AnyObject] {
        var valueArray : [AnyObject] = []
        
        for (_, subDictValue) in data {
            valueArray.append(subDictValue)
        }
        return valueArray
    }
    
    final class func arrayOfComplexValues(dataType : String, data : Array<Dictionary <String, AnyObject>> ) -> [AnyObject] {
        var valueArray : [AnyObject] = []
        
        for subDictValue in data {
            if let complexTypeValue: AnyObject = classFromString(dataType, data: subDictValue) {
                valueArray.append(complexTypeValue)
            }
        }
        return valueArray
    }
    
    final class func arrayOfComplexValues(dataType : String, data : Dictionary<String, Dictionary <String, AnyObject>> ) -> [AnyObject] {
        var valueArray : [AnyObject] = []
        
        for (_, subDictValue) in data {
            if let complexTypeValue: AnyObject = classFromString(dataType, data: subDictValue) {
                valueArray.append(complexTypeValue)
            }
        }
        return valueArray
    }
    
    
    // MARK Dictionary Parsing from Collections
    
    final class func dictionaryOfNativeValues(data : Dictionary<String, AnyObject>) -> Dictionary<String, AnyObject> {
        var valueDictionary = Dictionary<String, AnyObject>()
        
        for (subkey, subDictValue) in data {
            valueDictionary[String(subkey)] = subDictValue
        }
        return valueDictionary
    }
    
    final class func dictionaryOfNativeValues(data : Array<AnyObject>) -> Dictionary<String, AnyObject> {
        var valueDictionary = Dictionary<String, AnyObject>()
        var intKey = 0
        
        for value in data {
            valueDictionary[String(intKey)] = value
            intKey++
        }
        return valueDictionary
    }
    
    final class func dictionaryOfComplexValues(dataType : String, data : Dictionary<String, AnyObject>) ->  Dictionary<String, AnyObject> {
        var valueDictionary = Dictionary<String, AnyObject>()
        
        if let complexTypeValue: AnyObject = classFromString(dataType, data: data) {
            valueDictionary[String(0)] = complexTypeValue
        }
        return valueDictionary
    }
    
    final class func dictionaryOfComplexValues(dataType : String, data : Array<Dictionary <String, AnyObject>> ) ->  Dictionary<String, AnyObject> {
        var valueDictionary = Dictionary<String, AnyObject>()
        var intKey = 0
        
        for subDictValue in data {
            if let complexTypeValue: AnyObject = classFromString(dataType, data: subDictValue) {
                valueDictionary[String(intKey)] = complexTypeValue
                intKey++
            }
        }
        return valueDictionary
    }
    
    final class func dictionaryOfComplexValues(dataType : String, data : Dictionary<String, Dictionary <String, AnyObject>> ) ->  Dictionary<String, AnyObject> {
        var valueDictionary = Dictionary<String, AnyObject>()
        var intKey = 0
        
        for (_, subDictValue) in data {
            if let complexTypeValue: AnyObject = classFromString(dataType, data: subDictValue) {
                valueDictionary[String(intKey)] = complexTypeValue
                intKey++
            }
        }
        return valueDictionary
    }

    // MARK Perform Complex Transform Methods
    
    final class func complexTransformValue(mapperClass : String, jsonKeys : [String], data : Dictionary<String, AnyObject>) -> AnyObject? {
        var valueArray : [AnyObject] = []
        
        for jsonKey in jsonKeys {
            if let jsonValue: AnyObject = dictionaryValueForKey(jsonKey, data: data) {
                valueArray.append(jsonValue)
            }
        }
        
        if let transformedValue: AnyObject = transformValues(mapperClass, values : valueArray) {
            return transformedValue;
        }
        
        return nil
    }
    
    
    // MARK TypeCasting / Conversion Methods
    
    final class func convertDefaultValue(value : AnyObject, dataType : String) -> AnyObject?  {
        switch dataType {
        case UTDataTypeString:
            if value is NSNumber {
                return numericString(value as! NSNumber)
            }
            return "\(value)"
        case UTDataTypeDouble:
            return Double(value.doubleValue)
        case UTDataTypeFloat:
            return Float(value.floatValue)
        case UTDataTypeInt:
            return Int(value.integerValue)
        case UTDataTypeBool:
            return value.boolValue
        default:
            return value
        }
    }
    
    final class func numericString(value: NSNumber) -> String {
        switch CFNumberGetType(value){
        case .SInt8Type:
            return String(value.charValue)
        case .SInt16Type:
            return String(value.shortValue)
        case .SInt32Type:
            return String(value.intValue)
        case .SInt64Type:
            return String(value.longLongValue)
        case .Float32Type:
            return String(stringInterpolationSegment: value.floatValue)
        case .Float64Type:
            return String(stringInterpolationSegment: value.doubleValue)
        case .CharType:
            return String(value.charValue)
        case .ShortType:
            return String(value.shortValue)
        case .IntType:
            return String(value.integerValue)
        case .LongType:
            return String(value.longValue)
        case .LongLongType:
            return String(value.longLongValue)
        case .FloatType:
            return String(stringInterpolationSegment: value.floatValue)
        case .DoubleType:
            return String(stringInterpolationSegment: value.doubleValue)
        default:
            return String(stringInterpolationSegment: value.doubleValue)
        }
    }
    
    public final class func typeCast<U>(object: AnyObject?) -> U? {
        if let typed = object as? U {
            return typed
        }
        return nil
    }
    
    // MARK These Methods are overriden by the script accordingly in UTMapper.swift
    
    public class func classFromString(classname : String, data : Dictionary<String, AnyObject>) -> AnyObject? {
        switch classname {
        default:
            return nil
        }
    }
    
    public class func transformValues(transformer : String, values : [AnyObject]) -> AnyObject? {
        return nil
    }
}