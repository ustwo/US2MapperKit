//
//  UTMapper.swift
//  UTMapper
//
//  Created by Anton on 6/22/15.
//  Copyright © 2015 UTMapper. All rights reserved.
//

import Foundation

protocol UTMapperProtocol {
    static func transformValues(inputValues : [AnyObject]?) -> AnyObject?
}

var propertyMappings : Dictionary<String, Dictionary<String, Dictionary<String, AnyObject>>> = Dictionary()

let UTMapperJSONKey                 = "key"
let UTMapperTypeKey                 = "type"
let UTMapperNonOptionalKey          = "nonoptional"
let UTMapperDefaultKey              = "default"
let UTMapperMapperKey               = "mapper"
let UTMapperCollectionSubTypeKey    = "collection_subtype"

let UTDataTypeString        = "String"
let UTDataTypeInt           = "Int"
let UTDataTypeDouble        = "Double"
let UTDataTypeFloat         = "Float"
let UTDataTypeBool          = "Bool"
let UTDataTypeArray         = "Array"
let UTDataTypeDictionary    = "Dictionary"

let nativeDataTypes      = [UTDataTypeString, UTDataTypeInt, UTDataTypeDouble, UTDataTypeFloat, UTDataTypeBool]
let collectionTypes      = [UTDataTypeArray, UTDataTypeDictionary]

final class UTMapper {
    
    // Parse Dictionary Data for the specific class
    class func parseJSONResponse(className : String, data : Dictionary<String, AnyObject>) -> Dictionary<String, AnyObject>? {
        
        // The Mapping configuration for the Class
        let mappingConfiguration = retrieveMappingConfiguration(className)
        
        // Return nil if the mapping configuration is missing
        if mappingConfiguration.keys.count == 0 { return nil }
        
        // Dictionary of values to be returned
        var propertyValueDictionary = Dictionary<String, AnyObject>()
        
        // Iterate over the properties accordingly
        for (propertyKey, propertyMapping) in mappingConfiguration {
            
            // Check if complex transform mapper class exists
            if let transformClass = propertyMapping[UTMapperMapperKey] as? String {
                if let jsonKeys = propertyMapping[UTMapperJSONKey] as? [String] {
                    if let transformedValue = complexTransformValue(transformClass, jsonKeys : jsonKeys, data: data) {
                        propertyValueDictionary[propertyKey] = transformedValue;
                    }
                }
            }
            
            if let jsonKey = propertyMapping[UTMapperJSONKey] as? String {
                if let jsonValue = dictionaryValueForKey(jsonKey, data: data) {
                    // Ditionary value was found
                    propertyValueDictionary[propertyKey] = parsedValue(propertyKey, mapping: propertyMapping, data: jsonValue)
                } else if let defaultValue = propertyMapping[UTMapperDefaultKey] {
                    // Fallback to default value, if specified
                    propertyValueDictionary[propertyKey] = parsedValue(propertyKey, mapping: propertyMapping, data: defaultValue)
                } else {
                    // Fallbackthrough to Null Instance if the property is optional
                    propertyValueDictionary[propertyKey] = nullValueFor(propertyKey, mapping: propertyMapping)
                }
            }
        }
        
        // Validate that all non-optional properties have a value assigned
        for (propertyKey, propertyMapping) in mappingConfiguration {
            if let isPropertyOptional = propertyMapping[UTMapperNonOptionalKey] {
                guard isPropertyOptional.boolValue == false else {
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
    
    // MARK Load Mapping Configuration
    
    class func retrieveMappingConfiguration(className : String) -> Dictionary<String, Dictionary<String, AnyObject>> {
        if let mappingconfiguration = propertyMappings[className] {
            return mappingconfiguration
        } else {
            if let mappingPath = NSBundle.mainBundle().pathForResource(className, ofType: "plist") {
                let tempMapping = NSDictionary(contentsOfFile: mappingPath) as? Dictionary<String, Dictionary<String, AnyObject>>
                propertyMappings[className] = tempMapping
                return tempMapping!
            } else {
                return Dictionary<String, Dictionary<String, AnyObject>>()
            }
        }
    }
    
    
    // MARK Retrieve Dictionary Value For Assignment Methods
    
    class func dictionaryValueForKey(key : String, data : Dictionary<String, AnyObject>) -> AnyObject? {
        var keys = key.componentsSeparatedByString(".")
        var nestedDictionary = data
        
        for var x = 0; x < keys.count; x++ {
            if x >= (keys.count - 1) {
                if let finalValue = nestedDictionary[keys[x]] {
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
    
    class func parsedValue(propertyKey : String, mapping : Dictionary<String, AnyObject>, data : AnyObject) -> AnyObject? {
        
        if let dataType = mapping[UTMapperTypeKey]  as? String {
            if nativeDataTypes.contains(dataType) {
                return convertDefaultValue(data, dataType: dataType)
            } else if collectionTypes.contains(dataType) {
                // Check if the collection subtype has been defined
                if let subCollectionType = mapping[UTMapperCollectionSubTypeKey] as? String {
                    if let subDictionary = data as? Dictionary <String, AnyObject> {
                        switch dataType {
                        case UTDataTypeArray:
                            return parsedDictionaryOfDictionariesToArray(subCollectionType, data: subDictionary)
                        case UTDataTypeDictionary:
                            return parsedDictionaryOfDictionariesToDictionary(subCollectionType, data: subDictionary)
                        default:
                            break
                        }
                    } else if let subValueArray = data as? Array<AnyObject> {
                        switch dataType {
                        case UTDataTypeArray:
                            return parsedArrayOfDictionariesToArray(subCollectionType, data: subValueArray)
                        case UTDataTypeDictionary:
                            return parsedArrayOfDictionariesToDictionary(subCollectionType, data: subValueArray)
                        default:
                            break
                        }
                    }
                }
            } else if let complexTypeValue = _UTMapperHelper.classFromString(dataType, data: data as! Dictionary<String, AnyObject>) {
                // Unwrapped as a dictionary for a complex type and map accordingly, since it is not a simple type or a collection type
                return complexTypeValue
                
            }
        }
        
        return nil
    }
    
    class func parsedDictionaryOfDictionariesToDictionary(subCollectionType : String, data : Dictionary<String, AnyObject>)  -> Dictionary<String, AnyObject> {
        if nativeDataTypes.contains(subCollectionType) {
            return nativeValueDictionary(data)
        } else if let subObjectDictionary = data as? Dictionary<String, Dictionary <String, AnyObject>> {
            return complexValueDictionary(subCollectionType, dataDictionary: subObjectDictionary)
        } else {
            return complexValueDictionary(subCollectionType, singleDictionary: data)
        }
    }
    
    class func parsedArrayOfDictionariesToDictionary(subCollectionType : String, data : Array<AnyObject>) -> Dictionary<String, AnyObject>  {
        if nativeDataTypes.contains(subCollectionType) {
            return nativeValueDictionary(data)
        } else if let subObjectArray = data as? Array<Dictionary <String, AnyObject>> {
            return complexValueDictionary(subCollectionType, dataArray : subObjectArray)
        }
        
        return Dictionary<String, AnyObject>()
    }
    
    class func parsedArrayOfDictionariesToArray(subCollectionType : String, data : Array<AnyObject>) -> [AnyObject] {
        if nativeDataTypes.contains(subCollectionType) {
            return nativeValueArray(data)
        } else if let subObjectArray = data as? Array<Dictionary <String, AnyObject>> {
            return complexValueArray(subCollectionType, dataArray : subObjectArray)
        }
        
        return []
    }
    
    class func parsedDictionaryOfDictionariesToArray(subCollectionType : String, data : Dictionary<String, AnyObject>) -> [AnyObject] {
        if nativeDataTypes.contains(subCollectionType) {
            return nativeValueArray(data)
        } else if let subObjectDictionary = data as? Dictionary<String, Dictionary <String, AnyObject>> {
            return complexValueArray(subCollectionType, dataDictionary: subObjectDictionary)
        }
        
        return []
    }
    
    // MARK Perform Complex Transform Methods
    
    class func complexTransformValue(mapperClass : String, jsonKeys : [String], data : Dictionary<String, AnyObject>) -> AnyObject? {
        var valueArray : [AnyObject] = []
        
        for jsonKey in jsonKeys {
            if let jsonValue = dictionaryValueForKey(jsonKey, data: data) {
                valueArray.append(jsonValue)
            }
        }
        
        if let transformedValue = _UTMapperHelper.transformValues(mapperClass, values : valueArray) {
            return transformedValue;
        }
        
        return nil
    }
    
    
    // MARK Parse to Dictionary Methods
    
    class func complexValueDictionary(dataType : String, dataArray : Array<Dictionary <String, AnyObject>> ) ->  Dictionary<String, AnyObject> {
        var valueDictionary = Dictionary<String, AnyObject>()
        var intKey = 0
        
        for subDictValue in dataArray {
            if let complexTypeValue = _UTMapperHelper.classFromString(dataType, data: subDictValue) {
                valueDictionary[String(intKey)] = complexTypeValue
                intKey++
            }
        }
        
        return valueDictionary
    }
    
    class func complexValueDictionary(dataType : String, dataDictionary : Dictionary<String, Dictionary <String, AnyObject>> ) ->  Dictionary<String, AnyObject> {
        var valueDictionary = Dictionary<String, AnyObject>()
        var intKey = 0
        
        for (_, subDictValue) in dataDictionary {
            if let complexTypeValue = _UTMapperHelper.classFromString(dataType, data: subDictValue) {
                valueDictionary[String(intKey)] = complexTypeValue
                intKey++
            }
        }
        
        return valueDictionary
    }
    
    class func complexValueDictionary(dataType : String, singleDictionary : Dictionary<String, AnyObject>) ->  Dictionary<String, AnyObject> {
        var valueDictionary = Dictionary<String, AnyObject>()
        
        if let complexTypeValue = _UTMapperHelper.classFromString(dataType, data: singleDictionary) {
            valueDictionary[String(0)] = complexTypeValue
        }
        
        return valueDictionary
    }
    
    class func nativeValueDictionary(dataDictionary : Dictionary<String, AnyObject>) -> Dictionary<String, AnyObject> {
        var valueDictionary = Dictionary<String, AnyObject>()
        
        for (subkey, subDictValue) in dataDictionary {
            valueDictionary[String(subkey)] = subDictValue
        }
        
        return valueDictionary
    }
    
    class func nativeValueDictionary(dataArray :Array<AnyObject>) -> Dictionary<String, AnyObject> {
        var valueDictionary = Dictionary<String, AnyObject>()
        var intKey = 0
        
        for value in dataArray {
            valueDictionary[String(intKey)] = value
            intKey++
        }
        
        return valueDictionary
    }
    
    
    // MARK Parse to Array Methods
    
    class func complexValueArray(dataType : String, dataArray : Array<Dictionary <String, AnyObject>> ) -> [AnyObject] {
        var valueArray : [AnyObject] = []
        
        for subDictValue in dataArray {
            if let complexTypeValue = _UTMapperHelper.classFromString(dataType, data: subDictValue) {
                valueArray.append(complexTypeValue)
            }
        }
        return valueArray
    }
    
    class func complexValueArray(dataType : String, dataDictionary : Dictionary<String, Dictionary <String, AnyObject>> ) -> [AnyObject] {
        var valueArray : [AnyObject] = []
        
        for (_, subDictValue) in dataDictionary {
            if let complexTypeValue = _UTMapperHelper.classFromString(dataType, data: subDictValue) {
                valueArray.append(complexTypeValue)
            }
        }
        return valueArray
    }
    
    class func nativeValueArray(dataArray : Array<AnyObject>) -> [AnyObject] {
        var valueArray : [AnyObject] = []
        
        for value in dataArray {
            valueArray.append(value)
        }
        return valueArray
    }
    
    class func nativeValueArray(dataDictionary : Dictionary<String, AnyObject>) -> [AnyObject] {
        var valueArray : [AnyObject] = []
        
        for (_, subDictValue) in dataDictionary {
            valueArray.append(subDictValue)
        }
        return valueArray
    }
    
    class func nullValueFor(propertyKey : String, mapping : Dictionary<String, AnyObject>) -> AnyObject? {
        if let isPropertyNonOptional = mapping[UTMapperNonOptionalKey] {
            if isPropertyNonOptional.boolValue == false {
                return NSNull()
            }
        } else {
            return NSNull()
        }
        return nil
    }
    
    
    class func convertDefaultValue(value : AnyObject, dataType : String) -> AnyObject?  {
        switch dataType {
        case UTDataTypeString:
            if let stringObject = value as? String {
                return stringObject
            }else if let stringObject = value as? NSNumber {
                return String(stringObject.doubleValue)
            }
            return value
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
    
    class func typeCast<U>(object: AnyObject?) -> U? {
        if let typed = object as? U {
            return typed
        }
        return nil
    }
}