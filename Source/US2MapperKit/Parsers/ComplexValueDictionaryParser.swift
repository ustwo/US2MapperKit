//
//  ComplexValueDictionaryMapper.swift
//  US2MapperKit
//
//  Created by Anton on 7/17/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

import Foundation

final class ComplexValueDictionaryParser {
    
    // MARK Maps dictionary representation of complex objects from a Dictionary of Dictionary objects
   
    class func dictionaryRepresentation(collectionSubType : String?, data : Dictionary<String, Dictionary<String, AnyObject>>, instantiator : US2GeneratorProtocol) ->  Dictionary<String, AnyObject> {
       
        var valueDictionary : Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        
        for (key, subDictValue) in data {
            if let complexTypeValue: AnyObject = instantiator.newInstance(ofType: collectionSubType!, withValue: subDictValue) {
                valueDictionary["\(key)"] = complexTypeValue
            }
        }
        return valueDictionary
    }
    
    // MARK Maps dictionary representation of complex objects from an Array of Dictionary objects
    
    class func dictionaryRepresentation(collectionSubType : String?, data : [Dictionary<String, AnyObject>], instantiator : US2GeneratorProtocol) ->  Dictionary<String, AnyObject> {
       
        var valueDictionary : Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        var intKey = 0
        for subDictValue in data {
            if let complexTypeValue: AnyObject = instantiator.newInstance(ofType: collectionSubType!, withValue: subDictValue) {
                valueDictionary["\(intKey)"] = complexTypeValue
                intKey++
            }
        }
        return valueDictionary
    }
    
    // MARK Maps dictionary representation of complex objects from a single dictionary instance returned
   
    class func dictionaryRepresentation(collectionSubType : String?, data : Dictionary<String, AnyObject>, instantiator : US2GeneratorProtocol) ->  Dictionary<String, AnyObject> {
        
        var valueDictionary : Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        
        if let complexTypeValue: AnyObject = instantiator.newInstance(ofType: collectionSubType!, withValue: data) {
            valueDictionary["0"] = complexTypeValue
        }
        
        return valueDictionary
    }
}
