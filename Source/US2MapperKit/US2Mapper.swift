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
}

public protocol US2TransformerProtocol {
    func transformValues(inputValues : [AnyObject]?) -> AnyObject?
}

public func typeCast<U>(object: AnyObject?) -> U? {
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
    
    public class func mapValues(from dictionary : Dictionary<String, AnyObject>, forType classType : String , employing instantiator : US2InstantiatorProtocol) -> Dictionary<String, AnyObject>? {

        if let mappingConfiguration = retrieveMappingConfiguration(classType) {
       
            // Dictionary to store parsed values to be returned
            var retrievedValueDictionary = Dictionary<String, AnyObject>()
            
            for (propertyKey, propertyMapping) in mappingConfiguration {
                retrievedValueDictionary[propertyKey] = Parser.retrieveValue(from : dictionary, applying : propertyMapping, employing : instantiator)
            }
            
            if Validator.validateResponse(forValues: retrievedValueDictionary, mappedTo : mappingConfiguration, forType : classType, withData : dictionary) {
                return retrievedValueDictionary
            }
        }
        
        return nil
    }
    
    class func retrieveMappingConfiguration(className : String) -> Dictionary<String, Dictionary<String, AnyObject>>? {
        if let mappingconfiguration = propertyMappings[className] {
            return mappingconfiguration
        } else {
            if let mappingPath = NSBundle(forClass: self).pathForResource(className, ofType: "plist") {
                let tempMapping = NSDictionary(contentsOfFile: mappingPath) as? Dictionary<String, Dictionary<String, AnyObject>>
                
                if tempMapping!.isEmpty { return nil }
                
                propertyMappings[className] = tempMapping
                return tempMapping!
            } else {
                return nil
            }
        }
    }
}

