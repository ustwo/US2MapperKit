//
//  UTMapper.swift
//  UTMapper
//
//  Created by Anton on 6/22/15.
//  Copyright © 2015 UTMapper. All rights reserved.
//

import Foundation

let verbose = false

enum DataType: String {
    case String = "String"
    case Double = "Double"
    case Float  = "Float"
    case Bool   = "Bool"
    case Int    = "Int"
}

let UTMapperJSONKey         = "key"
let UTMapperTypeKey         = "type"
let UTMapperNonOptionalKey  = "nonoptional"
let UTMapperDefaultKey      = "default"
let UTMapperMapperKey       = "mapper"

var propertyMappings : Dictionary<String, Dictionary<String, Dictionary<String, String>>> = Dictionary()

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
            if let propertyMapping : Dictionary<String, String> = mappingConfiguration[propertyKey] {
               
                if let jsonKey = propertyMapping[UTMapperJSONKey] {
                    
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
    
    class func appendValueFor(propertyKey : String, mapping : Dictionary<String, String>, value : AnyObject, inout propertyValueDictionary : Dictionary<String, AnyObject>) {
        
        if let possibleNullValue = value as? NSNull {
            propertyValueDictionary[propertyKey] = possibleNullValue
            return
        }
    
       // if let dataType = mapping[UTMapperTypeKey] {
       //     propertyValueDictionary[propertyKey] = UTMapper.convertDefaultValue(value, type: DataType(rawValue:dataType)!)
       // }
        
        if let dataType = mapping[UTMapperTypeKey] {
            
            let nativeTypes = ["String", "Double", "Int", "Bool", "Float"]
            
            if nativeTypes.contains(dataType) {
                propertyValueDictionary[propertyKey] = UTMapper.convertDefaultValue(value, type: DataType(rawValue:dataType)!)
            } else if let complexTypeValue = _UTMapperClassInstantiator.classFromString(dataType, data: value as! Dictionary<String, AnyObject>) {
                propertyValueDictionary[propertyKey] = complexTypeValue
            } else {
                propertyValueDictionary[propertyKey] = _UTMapperClassInstantiator.classFromString(dataType, data: Dictionary<String, AnyObject>())
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
    
    class func isPropertyNonOptional(mapping : Dictionary<String, String>) -> Bool {
        if let optionalMappingValue = mapping[UTMapperNonOptionalKey] as? AnyObject {
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
            if let propertyMapping : Dictionary<String, String> = mappingConfiguration[propertyKey] {
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
    
    class func mappingConfiguration(className : String) -> Dictionary<String, Dictionary<String, String>> {
        if let mappingconfiguration = propertyMappings[className] {
            // Return cached mapping configuration
            return mappingconfiguration
        } else {
            // Ensure mapping configuration exists
            if let mappingPath = NSBundle.mainBundle().pathForResource(className, ofType: "plist") {
                let tempMapping = NSDictionary(contentsOfFile: mappingPath) as? Dictionary<String, Dictionary<String, String>>
                
                // Cache the mapping configuration for reuse
                propertyMappings[className] = tempMapping
                return tempMapping!
            } else {
                // Return Blank Mapping, and Warn the User
                return Dictionary<String, Dictionary<String, String>>()
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