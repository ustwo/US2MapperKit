//
//  Mapper.swift
//  US2MapperKit
//
//  Created by Anton on 7/17/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

import Foundation

final class Mapper {
    
    class func retrieveValue(from dictionary : Dictionary<String, AnyObject>, applying propertyMapping : Dictionary<String, AnyObject>, employing instantiator : US2GeneratorProtocol) -> AnyObject? {
        
        if let jsonKey = propertyMapping[US2MapperJSONKey] as? String {
            if let dataType = propertyMapping[US2MapperTypeKey]  as? String {
                
                let subType = propertyMapping[US2MapperCollectionSubTypeKey] as? String
                
                if let retrievedValue: AnyObject = DictionaryParser.valueForKey(jsonKey, dictionary: dictionary) {
                    return parsedValue(forValue : retrievedValue, dataType, subType, instantiator : instantiator)
                } else if let retrievedDefaultValue: AnyObject = propertyMapping[US2MapperDefaultKey] {
                    return parsedValue(forValue : retrievedDefaultValue, dataType, subType, instantiator : instantiator)
                }
            }
        }
        return nil
    }
    
    class func parsedValue(forValue value : AnyObject, _ dataType : String, _ subType: String?, instantiator : US2GeneratorProtocol) -> AnyObject? {
        
        if nativeDataTypes.containsValue(dataType) {
            
            return NativeTypeMapper.nativeRepresentation(fromValue : value, asType : dataType)
            
        } else if collectionTypes.containsValue(dataType) {
            
            switch dataType {
            case US2DataTypeArray:
                return CollectionMapper.arrayRepresentation(fromValue : value, ofType : subType, using : instantiator)
            case US2DataTypeDictionary:
                return CollectionMapper.dictionaryRepresentation(fromValue : value, ofType : subType, using : instantiator)
            default:
                if let unwrappedValue = value as? Dictionary<String, AnyObject> {
                    return ComplexTypeMapper.complexObject(fromValue: unwrappedValue, ofType: subType, using : instantiator)
                }
            }
        } else {
            return instantiator.newInstance(ofType: dataType, withValue: value as! Dictionary<String, AnyObject>)
        }
        
        return nil
    }
}
