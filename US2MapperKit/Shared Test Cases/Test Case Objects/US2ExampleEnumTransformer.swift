//
//  US2ExampleEnumTransformer.swift
//  US2MapperKit
//
//  Created by Anton on 9/3/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

import Foundation

public class US2ExampleEnumTransformer : US2TransformerProtocol {
    public func transformValues(inputValues : Dictionary<String, Any>?) -> Any? {

        if let enumValue = inputValues!["enumValue"] as? Int {
            return EnumExample(rawValue : enumValue)!
        }
        
        return nil
    }
}