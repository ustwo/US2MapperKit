//
//  CollectionMapper.swift
//  US2MapperKit
//
//  Created by Anton on 7/17/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

import Foundation

final class CollectionMapper {
    
    // Determines the type of representation to be mapped
    
    class func arrayRepresentation(fromValue data : AnyObject, ofType collectionSubType : String?, using instantiator : US2GeneratorProtocol) -> [AnyObject] {
    
        if nativeDataTypes.containsValue(collectionSubType!) {
            if let unwrappedData = data as? Dictionary<String, AnyObject> {
                return NativeValueArrayMapper.arrayRepresentation(collectionSubType, data : unwrappedData, instantiator : instantiator)
            } else if let unwrappedData = data as? [AnyObject] {
                return NativeValueArrayMapper.arrayRepresentation(collectionSubType, data : unwrappedData, instantiator : instantiator)
            }
        }
        
        if let unwrappedData = data as? Dictionary<String, Dictionary<String, AnyObject>> {
            return ComplexValueArrayMapper.arrayRepresentation(collectionSubType, data : unwrappedData, instantiator: instantiator)
        } else if let unwrappedData = data as? [Dictionary<String, AnyObject>] {
            return ComplexValueArrayMapper.arrayRepresentation(collectionSubType, data : unwrappedData, instantiator: instantiator)
        }
        
        return []
    }
    
    class func dictionaryRepresentation(fromValue data : AnyObject, ofType collectionSubType : String?, using instantiator : US2GeneratorProtocol) -> Dictionary<String, AnyObject> {
       
        if nativeDataTypes.containsValue(collectionSubType!) {
            if let unwrappedData = data as? Dictionary<String, AnyObject> {
                return NativeValueDictionaryMapper.dictionaryRepresentation(collectionSubType, data : unwrappedData, instantiator: instantiator)
            } else if let unwrappedData = data as? [AnyObject] {
                return NativeValueDictionaryMapper.dictionaryRepresentation(collectionSubType, data : unwrappedData, instantiator: instantiator)
            }
        }
        
        if let unwrappedData = data as? Dictionary<String, Dictionary<String, AnyObject>> {
            return ComplexValueDictionaryMapper.dictionaryRepresentation(collectionSubType, data: unwrappedData, instantiator: instantiator)
        } else if let unwrappedData = data as? Dictionary<String, AnyObject> {
            return ComplexValueDictionaryMapper.dictionaryRepresentation(collectionSubType, data : unwrappedData, instantiator: instantiator)
        } else if let unwrappedData = data as? [Dictionary<String, AnyObject>] {
            return ComplexValueDictionaryMapper.dictionaryRepresentation(collectionSubType, data : unwrappedData, instantiator: instantiator)
        }
        
        return [:]
    }
}
