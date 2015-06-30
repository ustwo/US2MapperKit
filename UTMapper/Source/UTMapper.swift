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

enum DataType: String {
    case String = "String"
    case Double = "Double"
    case Float  = "Float"
    case Bool   = "Bool"
    case Int    = "Int"
}

let UTCollectionTypeArray           = "Array"
let UTCollectionTypeDictionary      = "Dictionary"

let UTMapperJSONKey                 = "key"
let UTMapperTypeKey                 = "type"
let UTMapperNonOptionalKey          = "nonoptional"
let UTMapperDefaultKey              = "default"
let UTMapperMapperKey               = "mapper"
let UTMapperCollectionSubTypeKey    = "collection_subtype"

let nativeDataTypes      = ["String", "Double", "Int", "Bool", "Float"]
let collectionTypes      = ["Array", "Dictionary"]


var propertyMappings : Dictionary<String, Dictionary<String, Dictionary<String, AnyObject>>> = Dictionary()

final class UTMapper {
    
    class func parseJSONResponse(className : String, data : Dictionary<String, AnyObject>) -> Dictionary<String, AnyObject>? {
        
        // Dictionary of values to be returned
        var propertyValueDictionary = Dictionary<String, AnyObject>()
        
        // The Mapping configuration for the Class
        let mappingConfiguration = UTMapper.mappingConfiguration(className)
        
        // Iterate over the properties accordingly
        for (propertyKey, propertyMapping) in mappingConfiguration {
            
            // Check if mapper class exists
            if let mapperClass = propertyMapping[UTMapperMapperKey] {
                
                // value array holding all the keys needed for the transform class
                var valueArray : [AnyObject] = []
                
                // Get all json mapping keys required by the mapper
                if let jsonKeys = propertyMapping[UTMapperJSONKey] as? [String] {
                    
                    for key in jsonKeys {
                        var delimitedKeys = key.componentsSeparatedByString(".")
                        if let jsonValue = UTMapper.recursiveValueForKeys(propertyKey, keys : &delimitedKeys, data: data) {
                            valueArray.append(jsonValue)
                        }
                    }
                }
                
                // Once the values have been gathered, attempt to transform the values using a class conforming to the UTMapperProtocol protocol
                if let transformedValue = _UTMapperHelper.transformValues(mapperClass as! String, values : valueArray) {
                    propertyValueDictionary[propertyKey] = transformedValue
                }
                
            } else if let jsonKey = propertyMapping[UTMapperJSONKey] {
            
                var keys = jsonKey.componentsSeparatedByString(".")
            
                // Attempt to fetch values from the json
                if let jsonValue = UTMapper.recursiveValueForKeys(propertyKey, keys : &keys, data: data) {
                    // Dictionary value found
                    UTMapper.appendValueFor(propertyKey, mapping: propertyMapping, value: jsonValue, propertyValueDictionary: &propertyValueDictionary)
                } else if let defaultValue = propertyMapping[UTMapperDefaultKey] {
                   // Fallback to default value if specified
                    UTMapper.appendValueFor(propertyKey, mapping: propertyMapping, value: defaultValue, propertyValueDictionary: &propertyValueDictionary)
                } else {
                    // No Value found, ensure to set to NSNull
                    if UTMapper.isPropertyNonOptional(propertyMapping) == false {
                        propertyValueDictionary[propertyKey] = NSNull()
                    }
                }
            }
        }
        
        // Validate that all non optional properties have values assigned to them
        if UTMapper.validateNonOptionalValues(className, propertyValueDictionary: propertyValueDictionary) {
            return propertyValueDictionary
        }
        
        return nil
    }
    
    class func appendValueFor(propertyKey : String, mapping : Dictionary<String, AnyObject>, value : AnyObject, inout propertyValueDictionary : Dictionary<String, AnyObject>) {
        
        if let dataType = mapping[UTMapperTypeKey]  as? String {
            
            if nativeDataTypes.contains(dataType) {
                // Convert the value explicitely and append it to the property value dictionary
                propertyValueDictionary[propertyKey] = UTMapper.convertDefaultValue(value, type: DataType(rawValue:dataType)!)
            } else if collectionTypes.contains(dataType) {
                
                // Check if the collection subtype has been defined
                if let subCollectionType = mapping[UTMapperCollectionSubTypeKey] as? String {
                    
                    var valueArray : [AnyObject] = [] // If the collection is of type Array, all complex and simple objects will be appended to the valueArray
                    var valueDictionary = Dictionary<String, AnyObject>() // If the collection is of type Dictionary, all complex and simple objects will be appended to the valueDictionary
                    var intKey = 0
                    
                    // Block called once the data has been gathered
                    let appendData = { (complexValue : AnyObject, collectionDataType : String, key : String?) -> Void in
                        switch collectionDataType {
                        case UTCollectionTypeArray:
                            valueArray.append(complexValue)
                        case UTCollectionTypeDictionary:
                            if key == nil {
                                valueDictionary[String(intKey)] = complexValue
                                intKey++
                            } else {
                                valueDictionary[key!] = complexValue
                            }
                        default:
                            break
                        }
                    }
                    
                    let mapDataToDefinedType = { (subCollectionType : String, data : AnyObject) -> Void in
                       
                        // If the collectiong subtype is a Simple Type
                        if nativeDataTypes.contains(subCollectionType) {
                            if let dictionaryArray = data as? Dictionary<String, AnyObject> {
                                // Unwrapped as a dictionary, run through all the values and append them accordingly
                                for (key, subDictValue) in dictionaryArray {
                                    appendData(subDictValue, dataType, key)
                                }
                            } else if let valueArray = data as? [AnyObject] {
                                // Unwrapped as an array, run through all the values and append them accordingly
                                for value in valueArray {
                                    appendData(value, dataType, nil)
                                }
                            } else {
                                // Unwrapped as an a simple value, append it accordingly
                                appendData(value, dataType, nil)
                            }
                        } else if let subObjectDictionary = data as? Dictionary<String, Dictionary <String, AnyObject>> {
                            //Unwrapped as a dictionary of dictionaries of complex types, run through all the sub-ditionaries and map the complex subtype accordingly
                            for (_, subDictValue) in subObjectDictionary {
                                if let complexTypeValue = _UTMapperHelper.classFromString(subCollectionType, data: subDictValue) {
                                    appendData(complexTypeValue, dataType, nil)
                                }
                            }
                        } else if let subObjectArray = data as? Array<Dictionary <String, AnyObject>> {
                             // Unwrapped as an array of dictionaries of complex types, run through all the subditionaries and map the complex subtype accordingly
                            for subDictValue in subObjectArray {
                                if let complexTypeValue = _UTMapperHelper.classFromString(subCollectionType, data: subDictValue) {
                                    appendData(complexTypeValue, dataType, nil)
                                }
                            }
                        } else if let complexTypeValue = _UTMapperHelper.classFromString(subCollectionType, data: data as! Dictionary<String, AnyObject>) {
                            // Unwrapped as a dictionary for a complex type and mapped accordingly
                            appendData(complexTypeValue, dataType, nil)
                        }
                    }
                    
                    if let subDictionary = value as? Dictionary <String, AnyObject> {
                        // Unwrapped as a dictionary
                        mapDataToDefinedType(subCollectionType, subDictionary)
                    } else if let subValueArray = value as? Array<AnyObject> {
                        // Attempt unwrapping it as an array
                        mapDataToDefinedType(subCollectionType, subValueArray)
                    }
                    
                    // Check which of the two has content, and set the value accordingly in the properties dictionary
                    if valueArray.count > 0 {
                        propertyValueDictionary[propertyKey] = valueArray
                    } else if valueDictionary.keys.count > 0 {
                        propertyValueDictionary[propertyKey] = valueDictionary
                    }
                }
            } else if let complexTypeValue = _UTMapperHelper.classFromString(dataType, data: value as! Dictionary<String, AnyObject>) {
                // Unwrapped as a dictionary for a complex type and mapped accordingly, since it is not a simple type or a collection type
                propertyValueDictionary[propertyKey] = complexTypeValue
            }
        }
    }
    
    class func recursiveValueForKeys(propertyKey : String, inout keys : [String], data : Dictionary<String, AnyObject>) -> AnyObject? {
        
        var nestedDictionary = data
        
        for index in 0..<keys.count {
            if index >= (keys.count - 1) {
                if let finalValue = nestedDictionary[keys[index]] {
                    return finalValue
                }
            } else {
                if let nextLevelDictionary = nestedDictionary[keys[index]] as? Dictionary<String, AnyObject> {
                    nestedDictionary = nextLevelDictionary
                }
            }
        }
    
        return nil
    }
    
    class func isPropertyNonOptional(mapping : Dictionary<String, AnyObject>) -> Bool {
        if let optionalMappingValue = mapping[UTMapperNonOptionalKey] as? NSString {
            let isNonOptional = optionalMappingValue.boolValue as Bool
            return isNonOptional
        }
        
        return false
    }
    
    class func validateNonOptionalValues(className : String, propertyValueDictionary : Dictionary<String, AnyObject>) -> Bool {
        
        let mappingConfiguration = UTMapper.mappingConfiguration(className)
        let propertyNameKeys = mappingConfiguration.keys.array
        
        // If there were no properties mapped, validation failed
        if propertyNameKeys.count == 0 {
            return false
        }
        
        for propertyKey in propertyNameKeys {
            if let propertyMapping : Dictionary<String, AnyObject> = mappingConfiguration[propertyKey] {
                // Check to see if user defined the property as non-optional
                if UTMapper.isPropertyNonOptional(propertyMapping) {
                    if let _ = propertyValueDictionary[propertyKey] {
                        // If value was mapped, continue with validation
                        continue
                    } else {
                        // No mapped, or default value found, validation failed
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    class func mappingConfiguration(className : String) -> Dictionary<String, Dictionary<String, AnyObject>> {
        if let mappingconfiguration = propertyMappings[className] {
            // Return cached mapping configuration
            return mappingconfiguration
        } else {
            // Ensure mapping configuration exists
            if let mappingPath = NSBundle.mainBundle().pathForResource(className, ofType: "plist") {
                let tempMapping = NSDictionary(contentsOfFile: mappingPath) as? Dictionary<String, Dictionary<String, AnyObject>>
                
                // Cache the mapping configuration for reuse
                propertyMappings[className] = tempMapping
                return tempMapping!
            } else {
                // Return Blank Mapping, and Warn the User
                return Dictionary<String, Dictionary<String, AnyObject>>()
            }
        }
    }
    
    class func convertDefaultValue(value : AnyObject, type : DataType) -> AnyObject?  {
        switch type {
        case .String:
            if let stringObject = value as? String {
                return stringObject
            }else if let stringObject = value as? NSNumber {
                return String(stringObject.doubleValue)
            }
            return value
        case .Double:
            return Double(value.doubleValue)
        case .Float:
            return Float(value.floatValue)
        case .Int:
            return Int(value.integerValue)
        case .Bool:
            return value.boolValue
        }
    }
    
    class func typeCast<U>(object: AnyObject?) -> U? {
        if let typed = object as? U {
            return typed
        }
        return nil
    }
}