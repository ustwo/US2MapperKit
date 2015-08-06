//
//  NativeValueArrayParser.swift
//  US2MapperKit
//
//  Created by Anton Doudarev on 7/17/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

import Foundation

final class NativeValueArrayParser {
   
    // MARK Maps Array representation of native values from a Dictionary of objects
   
    class func arrayRepresentation(collectionSubType : String?, data : Dictionary<String, AnyObject>, instantiator : US2InstantiatorProtocol) -> [AnyObject] {
      
        var valueArray : [AnyObject] = []
       
        for (_, subDictValue) in data {
            valueArray.append(subDictValue)
        }
      
        return valueArray
    }
    
    // MARK Maps Array representation of native values from an Array of objects
   
    class func arrayRepresentation(collectionSubType : String?, data :[AnyObject], instantiator : US2InstantiatorProtocol) -> [AnyObject] {
       
        var valueArray : [AnyObject] = []
        
        for subDictValue in data {
            valueArray.append(subDictValue)
        }
      
        return valueArray
    }
}