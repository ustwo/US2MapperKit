//
//  UTCompoundValueMapper.swift
//  UTMapper
//
//  Created by Anton on 6/29/15.
//  Copyright © 2015 UTMapper. All rights reserved.
//

import Foundation

class UTCompoundValueMapper : UTMapperProtocol {
   
    static func transformValues(inputValues : [AnyObject]?) -> AnyObject? {
        var outputString : String = ""
        
        let inputArray = inputValues as! [String]
        
        for string in inputArray {
            outputString += string
        }
        
        if outputString.isEmpty {
            return nil
        }
        
        return outputString
    }
}