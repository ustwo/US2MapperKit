//
//  CollectionMapper.swift
//  US2MapperKit
//
//  Created by Anton on 7/17/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

import Foundation

final class CollectionParser {
    
    // MARK Determines the type of representation to be mapped to an Array
    
    class func arrayRepresentation(fromValue data : AnyObject, ofType collectionSubType : String?, using instantiator : US2GeneratorProtocol) -> [AnyObject] {
       
        if nativeDataTypes.containsValue(collectionSubType!) {
            if let unwrappedData = data as? Dictionary<String, AnyObject> {
                return NativeValueArrayParser.arrayRepresentation(collectionSubType, data : unwrappedData, instantiator : instantiator)
            } else if let unwrappedData = data as? [AnyObject] {
                return NativeValueArrayParser.arrayRepresentation(collectionSubType, data : unwrappedData, instantiator : instantiator)
            }
        }
        
        if let unwrappedData = data as? Dictionary<String, Dictionary<String, AnyObject>> {
            return ComplexValueArrayParser.arrayRepresentation(collectionSubType, data : unwrappedData, instantiator: instantiator)
        } else if let unwrappedData = data as? [Dictionary<String, AnyObject>] {
            return ComplexValueArrayParser.arrayRepresentation(collectionSubType, data : unwrappedData, instantiator: instantiator)
        }
        
        return []
    }
    
    // MARK Determines the type of representation to be mapped to a Dictionary
    
    class func dictionaryRepresentation(fromValue data : AnyObject, ofType collectionSubType : String?, using instantiator : US2GeneratorProtocol) -> Dictionary<String, AnyObject> {
       
        if nativeDataTypes.containsValue(collectionSubType!) {
            if let unwrappedData = data as? Dictionary<String, AnyObject> {
                return NativeValueDictionaryParser.dictionaryRepresentation(collectionSubType, data : unwrappedData, instantiator: instantiator)
            } else if let unwrappedData = data as? [AnyObject] {
                return NativeValueDictionaryParser.dictionaryRepresentation(collectionSubType, data : unwrappedData, instantiator: instantiator)
            }
        }
        
        if let unwrappedData = data as? Dictionary<String, Dictionary<String, AnyObject>> {
            return ComplexValueDictionaryParser.dictionaryRepresentation(collectionSubType, data: unwrappedData, instantiator: instantiator)
        } else if let unwrappedData = data as? Dictionary<String, AnyObject> {
            return ComplexValueDictionaryParser.dictionaryRepresentation(collectionSubType, data : unwrappedData, instantiator: instantiator)
        } else if let unwrappedData = data as? [Dictionary<String, AnyObject>] {
            return ComplexValueDictionaryParser.dictionaryRepresentation(collectionSubType, data : unwrappedData, instantiator: instantiator)
        }
        
        return [:]
    }
}
