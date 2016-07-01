//
//  US2Mapper.swift
//  US2Mapper
//
//  Created by Anton Doudarev on 6/22/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

import Foundation

public protocol US2InstantiatorProtocol {
    func newInstance(ofType classname : String, withValue data : Dictionary<String, AnyObject>) -> AnyObject?
    func transformerFromString(classString: String) -> US2TransformerProtocol?
    func mappingForClass(classString: String) ->  Dictionary<String, Dictionary<String, AnyObject>>?
}

public protocol US2TransformerProtocol {
    func transformValues(inputValues : Dictionary<String, Any>?) -> Any?
}

public func typeCast<U>(object: Any?) -> U? {
    if let typed = object as? U {
        return typed
    }
    return nil
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
let US2MapperTransformerKey          = "transformer"
let US2MapperCollectionSubTypeKey    = "collection_subtype"

let US2DataTypeString        = "String"
let US2DataTypeInt           = "Int"
let US2DataTypeDouble        = "Double"
let US2DataTypeFloat         = "Float"
let US2DataTypeBool          = "Bool"
let US2DataTypeArray         = "Array"
let US2DataTypeDictionary    = "Dictionary"

let nativeDataTypes      = [US2DataTypeString, US2DataTypeInt, US2DataTypeDouble, US2DataTypeFloat, US2DataTypeBool]
let collectionTypes      = [US2DataTypeArray, US2DataTypeDictionary]

final public class US2Mapper {
    
    public class func mapValues(from dictionary : Dictionary<String, AnyObject>, forType classType : String , employing instantiator : US2InstantiatorProtocol, defaultsEnabled : Bool) -> Dictionary<String, Any>? {

        if let mappingConfiguration = retrieveMappingConfiguration(classType, employing: instantiator) {
       
            // Dictionary to store parsed values to be returned
            var retrievedValueDictionary = Dictionary<String, Any>()
            
            for (propertyKey, propertyMapping) in mappingConfiguration {
                retrievedValueDictionary[propertyKey] = Parser.retrieveValue(from : dictionary, applying : propertyMapping, employing : instantiator, defaultsEnabled : defaultsEnabled)
            }
            
            if defaultsEnabled == false {
                return retrievedValueDictionary
            }
            
            if Validator.validateResponse(forValues: retrievedValueDictionary, mappedTo : mappingConfiguration, forType : classType, withData : dictionary) {
                return retrievedValueDictionary
            }
        }
        
        return nil
    }
    
    class func retrieveMappingConfiguration(className : String,  employing instantiator : US2InstantiatorProtocol) -> Dictionary<String, Dictionary<String, AnyObject>>? {
       
        if let mappingconfiguration = propertyMappings[className] {
            return mappingconfiguration
        } else {
            
            NSProcessInfo.processInfo().arguments.containsValue("TEST")
            if NSProcessInfo.processInfo().arguments.containsValue("TEST") {
                if let mappingPath = NSBundle(forClass: self).pathForResource(className, ofType: "plist"),
                  let tempMapping = NSDictionary(contentsOfFile: mappingPath) as? Dictionary<String, Dictionary<String, AnyObject>> {
                    if tempMapping.keys.count > 0 {
                      propertyMappings[className] = tempMapping
                      return tempMapping
                    }
                    
                    return nil

                } else {
                    return nil
                }
            } else {
                if let mappingPath = NSBundle.mainBundle().pathForResource(className, ofType: "plist"),

                let tempMapping = NSDictionary(contentsOfFile: mappingPath) as? Dictionary<String, Dictionary<String, AnyObject>> {
                
                propertyMappings[className] = tempMapping
                return tempMapping
            } else {
                return nil
            }
            
            }
        }
    }
}

