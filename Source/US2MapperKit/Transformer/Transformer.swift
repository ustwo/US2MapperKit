//
//  File.swift
//  US2MapperKit
//
//  Created by Anton on 7/17/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

import Foundation

final class Transformer : Parser {
    
    class func transformedValue(from data : Dictionary<String, AnyObject>, applying propertyMapping : Dictionary<String, AnyObject>, employing instantiator : US2GeneratorProtocol) -> AnyObject? {
        
        if let transformClass = propertyMapping[US2MapperTransformerKey] as? String {
            if let jsonKeys = propertyMapping[US2MapperJSONKey] as? [String] {
                if let transformedValue: AnyObject = transformedValueRepresentation(transformClass, jsonKeys : jsonKeys, data: data, instantiator: instantiator) {
                    return transformedValue
                }
            }
        }
        
        return nil
    }
    
    class func transformedValueRepresentation(mapperClass : String, jsonKeys : [String], data : Dictionary<String, AnyObject>, instantiator : US2GeneratorProtocol) -> AnyObject? {
        var valueArray : [AnyObject] = []
        
        for jsonKey in jsonKeys {
            if let jsonValue: AnyObject = dictionaryValueForKey(jsonKey, dictionary: data) {
                valueArray.append(jsonValue)
            }
        }
        
        if let transformedValue: AnyObject = instantiator.transformValues(mapperClass, values : valueArray) {
            return transformedValue;
        }
        
        return nil
    }
}
