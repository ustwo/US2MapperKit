//
//  ComplexValueArrayMapper.swift
//  US2MapperKit
//
//  Created by Anton on 7/17/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

import Foundation

final class ComplexValueArrayParser {
    
    // MARK Maps array representation of complex objects from an Array of Dictionary objects
   
    class func arrayRepresentation(collectionSubType : String?, data : [Dictionary<String, AnyObject>], instantiator : US2GeneratorProtocol) -> [AnyObject] {
       
        var valueArray : [AnyObject] = []
        
        for subArrayValue in data {
            if let complexTypeValue: AnyObject = instantiator.newInstance(ofType: collectionSubType!, withValue: subArrayValue) {
                valueArray.append(complexTypeValue)
            }
        }
        return valueArray
    }
    
    // MARK array representation of complex objects from a Dictionary of Dictionary objects
    
    class func arrayRepresentation(collectionSubType : String?, data : Dictionary<String, Dictionary<String, AnyObject>>, instantiator : US2GeneratorProtocol) -> [AnyObject] {
       
        var valueArray : [AnyObject] = []
        
        for (_, subDictValue) in data {
            if let complexTypeValue: AnyObject = instantiator.newInstance(ofType: collectionSubType!, withValue: subDictValue) {
                valueArray.append(complexTypeValue)
            }
        }
        return valueArray
    }
}