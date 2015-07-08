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

let nativeDataTypes : [String]      = [UTDataTypeString, UTDataTypeInt, UTDataTypeDouble, UTDataTypeFloat, UTDataTypeBool]
let collectionTypes : [String]      = [UTDataTypeArray, UTDataTypeDictionary]

class _US2Mapper {
    
    class func classFromString(classname : String, data : Dictionary<String, AnyObject>) -> AnyObject? {
        switch classname {
        default:
            return nil
        }
    }
    
    class func transformValues(transformer : String, values : [AnyObject]) -> AnyObject? {
        return nil
    }
    
    // Parse Dictionary Data for the specific class
    class func parseJSONResponse(className : String, data : Dictionary<String, AnyObject>) -> Dictionary<String, AnyObject>? {
        
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
                if let jsonKeys : [String] = propertyMapping[US2MapperJSONKey] as? [String] {
                    if let transformedValue: AnyObject = complexTransformValue(transformClass, jsonKeys : jsonKeys, data: data) {
                        propertyValueDictionary[propertyKey] = transformedValue;
                    }
                }
            }
            
            if let jsonKey = propertyMapping[US2MapperJSONKey] as? String {
                if let jsonValue : AnyObject = dictionaryValueForKey(jsonKey, data: data) {
                    // Ditionary value was found
                    propertyValueDictionary[propertyKey] = parsedValue(propertyKey, mapping: propertyMapping, data: jsonValue)
                } else if let defaultValue: AnyObject = propertyMapping[US2MapperDefaultKey] {
                    // Fallback to default value, if specified
                    propertyValueDictionary[propertyKey] = parsedValue(propertyKey, mapping: propertyMapping, data: defaultValue)
                }
            }
        }
        
        // Validate that all non-optional properties have a value assigned
        for (propertyKey, propertyMapping) in mappingConfiguration {
            if let isPropertyOptional : AnyObject = propertyMapping[US2MapperNonOptionalKey] {
                if isPropertyOptional.boolValue == true {
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
            
            let bundle = NSBundle(forClass: self)
            
            if let mappingPath = bundle.pathForResource(className, ofType: "plist") {
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
                if let finalValue : AnyObject = nestedDictionary[keys[x]] {
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
        if let dataType = mapping[US2MapperTypeKey]  as? String {
            if contains(nativeDataTypes, dataType)  == true {
                return convertDefaultValue(data, dataType: dataType)
            } else if contains(collectionTypes, dataType) {
                // Check if the collection subtype has been defined
                if let subCollectionType = mapping[US2MapperCollectionSubTypeKey] as? String {
                    if let subDictionary = data as? Dictionary <String, AnyObject> {
                        switch dataType {
                        case UTDataTypeArray:
                            return arrayFromDictionaryOfDictionaries(subCollectionType, data: subDictionary)
                        case UTDataTypeDictionary:
                            return dictionaryFromDictionaryOfDictionaries(subCollectionType, data: subDictionary)
                        default:
                            break
                        }
                    } else if let subValueArray = data as? Array<AnyObject> {
                        switch dataType {
                        case UTDataTypeArray:
                            return arrayFromArrayOfDictionaries(subCollectionType, data: subValueArray)
                        case UTDataTypeDictionary:
                            return dictionaryFromArrayOfDictionaries(subCollectionType, data: subValueArray)
                        default:
                            break
                        }
                    }
                }
            } else if let complexTypeValue : AnyObject = classFromString(dataType, data: data as! Dictionary<String, AnyObject>) {
                // Unwrapped as a dictionary for a complex type and map accordingly, since it is not a simple type or a collection type
                return complexTypeValue
            }
        }
        return nil
    }
    
    
    // MARK Parse Complex Types to Collections

    class func dictionaryFromDictionaryOfDictionaries(subCollectionType : String, data : Dictionary<String, AnyObject>)  -> Dictionary<String, AnyObject> {
        if contains(nativeDataTypes, subCollectionType) == true {
            return parsedDictionaryOfNativeValueDictionary(data)
        } else if let subObjectDictionary = data as? Dictionary<String, Dictionary <String, AnyObject>> {
            return parsedDictionaryFromDictionaryOfComplexValueDictionaries(subCollectionType, dataDictionary: subObjectDictionary)
        } else {
            return parsedDictionaryFromSingleComplexValueDictionary(subCollectionType, singleDictionary: data)
        }
    }

    class func dictionaryFromArrayOfDictionaries(subCollectionType : String, data : Array<AnyObject>) -> Dictionary<String, AnyObject>  {
        if contains(nativeDataTypes, subCollectionType) == true {
            return parsedDictionaryOfNativeValuesArray(data)
        } else if let subObjectArray = data as? Array<Dictionary <String, AnyObject>> {
            return parsedDictionaryFromArrayOfComplexValueDictionaries(subCollectionType, dataArray : subObjectArray)
        }
        
        return Dictionary<String, AnyObject>()
    }

    class func arrayFromArrayOfDictionaries(subCollectionType : String, data : Array<AnyObject>) -> [AnyObject] {
        if contains(nativeDataTypes, subCollectionType) == true {
            return parsedArrayOfNativeValuesArray(data)
        } else if let subObjectArray = data as? Array<Dictionary <String, AnyObject>> {
            return parsedArrayFromArrayOfComplexValueDictionaries(subCollectionType, dataArray : subObjectArray)
        }
        
        return []
    }

    class func arrayFromDictionaryOfDictionaries(subCollectionType : String, data : Dictionary<String, AnyObject>) -> [AnyObject] {
        if contains(nativeDataTypes, subCollectionType) == true {
            return parsedArrayFromNativeValuesDictionary(data)
        } else if let subObjectDictionary = data as? Dictionary<String, Dictionary <String, AnyObject>> {
            return parsedArrayFromDictionaryOfComplexValueDictionaries(subCollectionType, dataDictionary: subObjectDictionary)
        }
        
        return []
    }
    
    
    // MARK Parse Native Type to Collections

    class func parsedDictionaryOfNativeValueDictionary(dataDictionary : Dictionary<String, AnyObject>) -> Dictionary<String, AnyObject> {
        var valueDictionary = Dictionary<String, AnyObject>()
        
        for (subkey, subDictValue) in dataDictionary {
            valueDictionary[String(subkey)] = subDictValue
        }
        
        return valueDictionary
    }

    class func parsedDictionaryOfNativeValuesArray(dataArray :Array<AnyObject>) -> Dictionary<String, AnyObject> {
        var valueDictionary = Dictionary<String, AnyObject>()
        var intKey = 0
        
        for value in dataArray {
            valueDictionary[String(intKey)] = value
            intKey++
        }
        
        return valueDictionary
    }

    class func parsedArrayOfNativeValuesArray(dataArray : Array<AnyObject>) -> [AnyObject] {
        var valueArray : [AnyObject] = []
        
        for value in dataArray {
            valueArray.append(value)
        }
        return valueArray
    }

    class func parsedArrayFromNativeValuesDictionary(dataDictionary : Dictionary<String, AnyObject>) -> [AnyObject] {
        var valueArray : [AnyObject] = []
        
        for (_, subDictValue) in dataDictionary {
            valueArray.append(subDictValue)
        }
        return valueArray
    }
    
    
    // MARK Perform Complex Transform Methods

    class func complexTransformValue(mapperClass : String, jsonKeys : [String], data : Dictionary<String, AnyObject>) -> AnyObject? {
        var valueArray : [AnyObject] = []
        
        for jsonKey in jsonKeys {
            if let jsonValue : AnyObject = dictionaryValueForKey(jsonKey, data: data) {
                valueArray.append(jsonValue)
            }
        }
        
        if let transformedValue : AnyObject = transformValues(mapperClass, values : valueArray) {
            return transformedValue;
        }
        
        return nil
    }
    
    
    // MARK Parse Complex Values (User Defined Class Properties)

    class func parsedDictionaryFromSingleComplexValueDictionary(dataType : String, singleDictionary : Dictionary<String, AnyObject>) ->  Dictionary<String, AnyObject> {
        var valueDictionary = Dictionary<String, AnyObject>()
        
        if let complexTypeValue : AnyObject = classFromString(dataType, data: singleDictionary) {
            valueDictionary[String(0)] = complexTypeValue
        }
        
        return valueDictionary
    }

    class func parsedDictionaryFromArrayOfComplexValueDictionaries(dataType : String, dataArray : Array<Dictionary <String, AnyObject>> ) ->  Dictionary<String, AnyObject> {
        var valueDictionary = Dictionary<String, AnyObject>()
        var intKey = 0
        
        for subDictValue in dataArray {
            if let complexTypeValue : AnyObject = classFromString(dataType, data: subDictValue) {
                valueDictionary[String(intKey)] = complexTypeValue
                intKey++
            }
        }
        
        return valueDictionary
    }

    class func parsedDictionaryFromDictionaryOfComplexValueDictionaries(dataType : String, dataDictionary : Dictionary<String, Dictionary <String, AnyObject>> ) ->  Dictionary<String, AnyObject> {
        var valueDictionary = Dictionary<String, AnyObject>()
        var intKey = 0
        
        for (_, subDictValue) in dataDictionary {
            if let complexTypeValue : AnyObject = classFromString(dataType, data: subDictValue) {
                valueDictionary[String(intKey)] = complexTypeValue
                intKey++
            }
        }
        
        return valueDictionary
    }
    
    class func parsedArrayFromArrayOfComplexValueDictionaries(dataType : String, dataArray : Array<Dictionary <String, AnyObject>> ) -> [AnyObject] {
        var valueArray : [AnyObject] = []
        
        for subDictValue in dataArray {
            if let complexTypeValue : AnyObject = classFromString(dataType, data: subDictValue) {
                valueArray.append(complexTypeValue)
            }
        }
        return valueArray
    }
    
    class func parsedArrayFromDictionaryOfComplexValueDictionaries(dataType : String, dataDictionary : Dictionary<String, Dictionary <String, AnyObject>> ) -> [AnyObject] {
        var valueArray : [AnyObject] = []
        
        for (_, subDictValue) in dataDictionary {
            if let complexTypeValue : AnyObject = classFromString(dataType, data: subDictValue) {
                valueArray.append(complexTypeValue)
            }
        }
        return valueArray
    }
    
    // MARK TypeCasting / Conversion Methods
    
    class func convertDefaultValue(value : AnyObject, dataType : String) -> AnyObject?  {
        switch dataType {
        case UTDataTypeString:
            if let numericObject = value as? NSNumber {
                return numericObject.stringValue
            }
        case UTDataTypeDouble:
            if let numericObject = value as? NSNumber {
                switch CFNumberGetType(numericObject){
                case .SInt64Type:
                    return value
                case .Float32Type:
                    return value
                case .Float64Type:
                    return value
                default:
                    return Double(value.doubleValue)
                }
            }
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
        
        return value
    }
    
    class func typeCast<U>(object: AnyObject?) -> U? {
        if let typed = object as? U {
            return typed
        }
        return nil
    }
}