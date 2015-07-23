//
//  US2CompoundValueTransformer.swift
//  US2MapperKit
//
//  Created by Anton Doudarev on 6/29/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

public class US2CompoundValueTransformer : US2TransformerProtocol {
   
    public func transformValues(inputValues : Dictionary<String, AnyObject>?) -> AnyObject? {
        var outputString : String = ""
        
        if let stringDictionary = inputValues as? Dictionary<String, String> {
            for (key, value) in stringDictionary {
                outputString += value
            }
        }
        
        if outputString.isEmpty { return nil }
        return outputString
    }
}
