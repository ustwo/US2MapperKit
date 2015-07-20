//
//  US2CompoundValueTransformer.swift
//  US2MapperKit
//
//  Created by Anton Doudarev on 6/29/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

public class US2CompoundValueTransformer : US2TransformerProtocol {
   
    public func transformValues(inputValues : [AnyObject]?) -> AnyObject? {
        
        var outputString : String = ""
        
        if let inputArray = inputValues as? [String] {
            for string in inputArray {
                outputString += string
            }
        }
    
        if outputString.isEmpty { return nil }
        
        return outputString
    }
}