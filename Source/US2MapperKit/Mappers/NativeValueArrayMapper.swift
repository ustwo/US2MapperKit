//
//  NativeValueArrayMapper.swift
//  US2MapperKit
//
//  Created by Anton on 7/17/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

import Foundation

final class NativeValueArrayMapper {
   
    // Maps Array representation of native values from a Dictionary of objects
    class func arrayRepresentation(collectionSubType : String?, data : Dictionary<String, AnyObject>, instantiator : US2GeneratorProtocol) -> [AnyObject] {
      
        var valueArray : [AnyObject] = []
       
        for (_, subDictValue) in data {
            valueArray.append(subDictValue)
        }
      
        return valueArray
    }
    
    // Maps Array representation of native values from an Array of objects
    class func arrayRepresentation(collectionSubType : String?, data :[AnyObject], instantiator : US2GeneratorProtocol) -> [AnyObject] {
       
        var valueArray : [AnyObject] = []
        
        for subDictValue in data {
            valueArray.append(subDictValue)
        }
      
        return valueArray
    }
}