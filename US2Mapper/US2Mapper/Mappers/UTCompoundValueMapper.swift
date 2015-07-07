//
//  UTCompoundValueMapper.swift
//  US2Mapper
//
//  Created by Anton on 6/29/15.
//  Copyright © 2015 US2Mapper. All rights reserved.
//

import Foundation

class UTCompoundValueMapper : US2MapperProtocol {
   
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