//
//  US2ExampleClosureTransformer.swift
//  US2MapperKit
//
//  Created by Anton on 9/3/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

import Foundation
import UIKit

public class US2ExampleClosureTransformer : US2TransformerProtocol {
    public func transformValues(inputValues : Dictionary<String, Any>?) -> Any? {
        if let handlerType = inputValues!["handler_type"] as? String {
            if handlerType == "uppercase" {
              
                func returnCapitalizedString(value: String) -> String {
                    return value.uppercaseString
                }
                return returnCapitalizedString
            
            } else if handlerType == "lowercase" {
                func returnLowercaseString(value: String) -> String {
                    return value.lowercaseString
                }
                return returnLowercaseString
            }
        }

        return nil
    }
}