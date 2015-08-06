//
//  Transformer.swift
//  US2MapperKit
//
//  Created by Anton Doudarev on 7/17/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

import Foundation


var transformerInstances : Dictionary<String, US2TransformerProtocol> = Dictionary<String, US2TransformerProtocol> ()

final class Transformer : Parser {
    
    class func transformedValue(from data : Dictionary<String, AnyObject>, applying propertyMapping : Dictionary<String, AnyObject>, employing instantiator : US2InstantiatorProtocol) -> AnyObject? {
        
        if let transformClass = propertyMapping[US2MapperTransformerKey] as? String {
            if let jsonKeys = propertyMapping[US2MapperJSONKey] as? [String] {
                if let transformedValue: AnyObject = transformedValueRepresentation(transformClass, jsonKeys : jsonKeys, data: data, instantiator: instantiator) {
                    return transformedValue
                }
            }
        }
        return nil
    }

    class func transformedValueRepresentation(mapperClass : String, jsonKeys : [String], data : Dictionary<String, AnyObject>, instantiator : US2InstantiatorProtocol) -> AnyObject? {
        
        var valueDictionary : Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        
        for jsonKey in jsonKeys {
            if let jsonValue: AnyObject = dictionaryValueForKey(jsonKey, dictionary: data) {
                valueDictionary[jsonKey] = jsonValue
            }
        }
        
        if let customTransformer = customTransformer(mapperClass, instantiator: instantiator) {
            if let transformedValue: AnyObject = customTransformer.transformValues(valueDictionary) {
                return transformedValue;
            }
        }
        
        return nil
    }

    
    class func customTransformer(className : String, instantiator : US2InstantiatorProtocol) -> US2TransformerProtocol? {
        if let transformer = transformerInstances[className] {
            return transformer
        } else {
            if let transformer = instantiator.transformerFromString(className) {
                transformerInstances[className] = transformer
                return transformer
            } else {
                return nil
            }
        }
    }
}
