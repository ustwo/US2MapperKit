//
//  _UTMapperTransformer.swift
//  UTMapper
//
//  Created by Anton on 6/29/15.
//  Copyright © 2015 UTMapper. All rights reserved.
//

import Foundation

class _UTMapperTransformer {
    
    class func transformValues(transformder : String, values : [AnyObject]) -> AnyObject? {
        switch transformder {
        case "UTCompoundValueMapper":
            return UTCompoundValueMapper.transformValues(values)
        default:
            return nil
        }
    }
}