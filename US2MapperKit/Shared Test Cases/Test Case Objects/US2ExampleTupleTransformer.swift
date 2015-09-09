//
//  US2ExampleTupleTransformer.swift
//  US2MapperKit
//
//  Created by Anton on 9/3/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

import Foundation

public class US2ExampleTupleTransformer : US2TransformerProtocol {
    public func transformValues(inputValues : Dictionary<String, Any>?) -> Any? {
        
        if let valueOne = inputValues!["value_one"] as? Double {
            if let valueTwo = inputValues!["value_two"] as? Double {
                return (val1 : valueOne, val2 : valueTwo)
            }
        }
        
        return nil
    }
}