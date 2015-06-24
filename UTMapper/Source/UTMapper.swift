//
//  UTMapper.swift
//  UTMapper
//
//  Created by Anton on 6/22/15.
//  Copyright © 2015 UTMapper. All rights reserved.
//

import Foundation

enum DataType: String {
    case String = "String"
    case Double = "Double"
    case Float  = "Float"
    case Bool   = "Bool"
    case Int    = "Int"
}

let UTMapperJSONKey     = "key"
let UTMapperTypeKey     = "type"
let UTMapperOptionalKey = "optional"
let UTMapperDefaultKey  = "default"
let UTMapperMapperKey   = "mapper"

var propertyMappings : Dictionary<String, Dictionary<String, Dictionary<String, String>>> = Dictionary()

final class UTMapper {
    
    class func parseJSONResponse(className : String, data : NSDictionary) -> Dictionary<String, AnyObject>? {

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
                    
                    var keys = jsonKey.componentsSeparatedByString(".")
                    
                    if let jsonValue = UTMapper.recursiveValueForKeys(propertyKey, keys : &keys, data: data) {
                        if let dataTypeConfigValue = propertyMapping[UTMapperTypeKey] {
                            propertyValueDictionary[propertyKey] = UTMapper.convertDefaultValue(jsonValue, type: DataType(rawValue:dataTypeConfigValue)!)
                            UTMapper.logDefaultValue(propertyKey, value : propertyValueDictionary[propertyKey]!)
                        } else {
                            UTMapper.logMissingDataType(propertyKey)
                        }
                    } else if let jsonValue = propertyMapping[UTMapperDefaultKey] {
                        
                        if let dataTypeConfigValue = propertyMapping[UTMapperTypeKey] {
                            propertyValueDictionary[propertyKey] = UTMapper.convertDefaultValue(jsonValue, type: DataType(rawValue:dataTypeConfigValue)!)
                            UTMapper.logDefaultValue(propertyKey, value : propertyValueDictionary[propertyKey]!)
                        } else {
                            UTMapper.logMissingDataType(propertyKey)
                        }
                        
                    } else {
                        if UTMapper.propertyNonOptional(propertyMapping) {
                            UTMapper.logMissingNonOptionalDefaultValue(propertyKey)
                        } else {
                            propertyValueDictionary[propertyKey] = NSNull()
                        }
                    }
                }
            }
        }
        
        if UTMapper.verifyNonOptionalValues(className, propertyValueDictionary: propertyValueDictionary) {
            return propertyValueDictionary
        }
        return nil
    }
    
    class func propertyNonOptional(mapping : Dictionary<String, String>) -> Bool {
        if let optionalMappingValue = mapping[UTMapperOptionalKey] as? AnyObject {
            let isNonOptional = optionalMappingValue.boolValue as Bool
            return isNonOptional
        }
        return false
    }
    
    class func verifyNonOptionalValues(className : String, propertyValueDictionary : Dictionary<String, AnyObject>) -> Bool {
        
        let mappingConfiguration = UTMapper.mappingConfiguration(className)
        let propertyNameKeys = mappingConfiguration.keys.array
        
        // If there were no properties mapped, validation failed
        if propertyNameKeys.count == 0 {
            return false
        }
        
        for propertyKey in propertyNameKeys {
            if let propertyMapping : Dictionary<String, String> = mappingConfiguration[propertyKey] {
                // Check to see if user defined the property as non-optional
                if UTMapper.propertyNonOptional(propertyMapping) {
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
                UTMapper.logMissingMappingConfiguration(className)
                return Dictionary<String, Dictionary<String, String>>()
            }
        }
    }
    
    class func recursiveValueForKeys(propertyKey : String, inout keys : [String], data : NSDictionary) -> AnyObject? {
        
        var nestedDictionary = data
        
        for index in 0..<keys.count {
            if index >= (keys.count - 1) {
                if let finalValue = nestedDictionary[keys[index]] {
                    return finalValue
                }
            } else {
                if let nextLevelDictionary = nestedDictionary[keys[index]] as? NSDictionary {
                    nestedDictionary = nextLevelDictionary
                }
            }
        }
        return nil
    }
    
    class func convertDefaultValue(value : AnyObject, type : DataType) -> AnyObject?  {
        switch type {
        case .String:
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
    
    class func logDefaultValue(propertyKey : AnyObject, value : AnyObject) {
        print("Warning: UTMapper did not find a value for property \(propertyKey), default set to \(value)\n")
    }
    
    class func logMissingDataType(propertyKey : AnyObject) {
        print("Error: UTMapper missing 'type' definition for \(propertyKey), could not map default value for property\n")
    }
    
    class func logMissingMappingConfiguration(className : AnyObject) {
        print("Error: UTMapper could not find mapping configuration for the following class \(className)\n")
    }
    
    class func logMissingNonOptionalDefaultValue(propertyKey : AnyObject) {
        print("Error: UTMapper did not find a default value for property \(propertyKey), initialization with dictioanry fail")
    }
}