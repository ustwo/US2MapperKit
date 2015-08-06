//
//  NativeValueDictionaryParser.swift
//  US2MapperKit
//
//  Created by Anton Doudarev on 7/17/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

import Foundation

final class NativeValueDictionaryParser {
    
    // MARK Maps Dictionary representation of native values from an Array of objects
   
    class func dictionaryRepresentation(collectionSubType : String?, data : Dictionary<String, AnyObject>, instantiator : US2InstantiatorProtocol) -> Dictionary<String, AnyObject> {
       
        var valueDictionary = Dictionary<String, AnyObject>()
        var intKey = 0
        
        for (key, subDictValue) in data {
            valueDictionary[String(key)] = subDictValue
            intKey++
        }
        
        return valueDictionary
    }
    
    // MARK Maps Dictionary representation of native values from an Array of objects
    
    class func dictionaryRepresentation(collectionSubType : String?, data : [AnyObject], instantiator : US2InstantiatorProtocol) -> Dictionary<String, AnyObject> {
       
        var valueDictionary = Dictionary<String, AnyObject>()
        var intKey = 0
        
        for subDictValue in data {
            valueDictionary[String(intKey)] = subDictValue
            intKey++
        }
        
        return valueDictionary
    }
}