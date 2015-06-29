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

let UTMapperJSONKey                 = "key"
let UTMapperTypeKey                 = "type"
let UTMapperNonOptionalKey          = "nonoptional"
let UTMapperDefaultKey              = "default"
let UTMapperMapperKey               = "mapper"
let UTMapperCollectionSubTypeKey    = "collection_subtype"

var propertyMappings : Dictionary<String, Dictionary<String, Dictionary<String, AnyObject>>> = Dictionary()

final class UTMapper {
    
    class func parseJSONResponse(className : String, data : Dictionary<String, AnyObject>) -> Dictionary<String, AnyObject>? {
        
        // Dictionary of values to be returned
        var propertyValueDictionary = Dictionary<String, AnyObject>()
        
        // The Mapping configuration for the Class
        let mappingConfiguration = UTMapper.mappingConfiguration(className)
        
        // The Array of property keys defined in the Class
        let propertyNameKeys = mappingConfiguration.keys.array
        
        // Iterate over the properties accordingly
        for propertyKey in propertyNameKeys {
            
            // Fetch the definition for the specific property
            if let propertyMapping : Dictionary<String, AnyObject> = mappingConfiguration[propertyKey] {
                
                // Check if mapper class exists
                if let mapperClass = propertyMapping[UTMapperMapperKey] {
                    
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
                    
                    if let transformedValue = _UTMapperHelper.transformValues(mapperClass as! String, values : valueArray) {
                        propertyValueDictionary[propertyKey] = transformedValue
                    }
                    
                } else if let jsonKey = propertyMapping[UTMapperJSONKey] {
                    var newValue : AnyObject = NSNull()
                    var keys = jsonKey.componentsSeparatedByString(".")
                    
                    if let jsonValue = UTMapper.recursiveValueForKeys(propertyKey, keys : &keys, data: data) {
                        newValue = jsonValue
                    } else if let defaultValue = propertyMapping[UTMapperDefaultKey] {
                        newValue = defaultValue
                    }
                    
                    UTMapper.appendValueFor(propertyKey, mapping: propertyMapping, value: newValue, propertyValueDictionary: &propertyValueDictionary)
                }
            }
        }
        
        if UTMapper.validateNonOptionalValues(className, propertyValueDictionary: propertyValueDictionary) {
            return propertyValueDictionary
        }
        
        return nil
    }
    
    class func appendValueFor(propertyKey : String, mapping : Dictionary<String, AnyObject>, value : AnyObject, inout propertyValueDictionary : Dictionary<String, AnyObject>) {
        
        if let dataType = mapping[UTMapperTypeKey]  as? String {
            
            let nativeTypes = ["String", "Double", "Int", "Bool", "Float"]
            
            if nativeTypes.contains(dataType) {
                if let possibleNullValue = value as? NSNull {
                    propertyValueDictionary[propertyKey] = possibleNullValue
                    return
                }
                
                propertyValueDictionary[propertyKey] = UTMapper.convertDefaultValue(value, type: DataType(rawValue:dataType)!)
                
            } else if dataType == "Array" {
                
                if let subCollectionType = mapping[UTMapperCollectionSubTypeKey] as? String {
                    
                    var valueArray : [AnyObject] = []
                    
                    if let subObjectArray = value as? Array<Dictionary <String, AnyObject>> {
                        for subObject in subObjectArray {
                            if let complexTypeValue = _UTMapperHelper.classFromString(subCollectionType, data: subObject) {
                                valueArray.append(complexTypeValue)
                            }
                        }
                    } else if let subObjectDictionary = value as? Dictionary<String, Dictionary <String, AnyObject>> {
                        
                        for key in subObjectDictionary.keys {
                            if let subDictValue = subObjectDictionary[key] {
                                if let complexTypeValue = _UTMapperHelper.classFromString(subCollectionType, data: subDictValue) {
                                    valueArray.append(complexTypeValue)
                                }
                            }
                        }
                    }
                    
                    if valueArray.count > 0 {
                        propertyValueDictionary[propertyKey] = valueArray
                    }
                }
            } else if dataType == "Dictionary" {
            
                if let subCollectionType = mapping[UTMapperCollectionSubTypeKey] as? String {
                   
                    if let possibleNullValue = value as? NSNull {
                        propertyValueDictionary[propertyKey] = possibleNullValue
                        return
                    }
                    
                    var valueDictionary = Dictionary<String, AnyObject>()
                   
                    if let subObjectArray = value as? Array<Dictionary <String, AnyObject>> {
                        var intKey = 0
                        
                        for subObject in subObjectArray {
                            if let complexTypeValue = _UTMapperHelper.classFromString(subCollectionType, data: subObject) {
                                valueDictionary[String(intKey)] = complexTypeValue
                                intKey++
                            }
                        }
                    } else if let subObjectValue = value as? Dictionary <String, AnyObject> {
                        var intKey = 0
                        
                            if let complexTypeValue = _UTMapperHelper.classFromString(subCollectionType, data: subObjectValue) {
                                valueDictionary[String(intKey)] = complexTypeValue
                                intKey++
                            }
                    }
                    
                    if valueDictionary.keys.count > 0 {
                        propertyValueDictionary[propertyKey] = valueDictionary
                    }
                }
                
            } else if let _ = value as? NSNull {
                return
            } else if let complexTypeValue = _UTMapperHelper.classFromString(dataType, data: value as! Dictionary<String, AnyObject>) {
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