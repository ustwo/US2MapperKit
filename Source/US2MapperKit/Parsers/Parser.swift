//
//  Mapper.swift
//  US2MapperKit
//
//  Created by Anton on 7/17/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

import Foundation

class Parser {
    
    final class func retrieveValue(from dictionary : Dictionary<String, AnyObject>, applying propertyMapping : Dictionary<String, AnyObject>, employing instantiator : US2GeneratorProtocol) -> AnyObject? {
        
        if propertyMapping[US2MapperTransformerKey] != nil {
            return Transformer.transformedValue(from: dictionary, applying : propertyMapping, employing : instantiator)
        } 
        
        if let jsonKey = propertyMapping[US2MapperJSONKey] as? String {
            if let dataType = propertyMapping[US2MapperTypeKey]  as? String {
                
                let subType = propertyMapping[US2MapperCollectionSubTypeKey] as? String
                
                if let retrievedValue: AnyObject = dictionaryValueForKey(jsonKey, dictionary: dictionary) {
                    return parsedValue(forValue : retrievedValue, dataType, subType, instantiator : instantiator)
                } else if let retrievedDefaultValue: AnyObject = propertyMapping[US2MapperDefaultKey] {
                    return parsedValue(forValue : retrievedDefaultValue, dataType, subType, instantiator : instantiator)
                }
            }
        }
        return nil
    }
    
    final class func parsedValue(forValue value : AnyObject, _ dataType : String, _ subType: String?, instantiator : US2GeneratorProtocol) -> AnyObject? {
        
        if nativeDataTypes.containsValue(dataType) {
            
            return NativeTypeParser.nativeRepresentation(fromValue : value, asType : dataType)
            
        } else if collectionTypes.containsValue(dataType) {
            
            switch dataType {
            case US2DataTypeArray:
                return CollectionParser.arrayRepresentation(fromValue : value, ofType : subType, using : instantiator)
            case US2DataTypeDictionary:
                return CollectionParser.dictionaryRepresentation(fromValue : value, ofType : subType, using : instantiator)
            default:
                if let unwrappedValue = value as? Dictionary<String, AnyObject> {
                    return ComplexTypeParser.complexObject(fromValue: unwrappedValue, ofType: subType, using : instantiator)
                }
            }
        } else {
            return instantiator.newInstance(ofType: dataType, withValue: value as! Dictionary<String, AnyObject>)
        }
        
        return nil
    }
    
    final class func dictionaryValueForKey(key : String, dictionary : Dictionary<String, AnyObject>) -> AnyObject? {
        var keys = key.componentsSeparatedByString(".")
        var nestedDictionary = dictionary
        
        for var x = 0; x < keys.count; x++ {
            if x >= (keys.count - 1) {
                if let finalValue: AnyObject = nestedDictionary[keys[x]] {
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
}
