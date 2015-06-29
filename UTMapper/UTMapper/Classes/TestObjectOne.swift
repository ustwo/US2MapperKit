//
//  TestObjectOne.swift
//  UTMapper
//
//  Created by Anton on 6/25/15.
//  Copyright © 2015 UTMapper. All rights reserved.
//

import Foundation

class _TestObjectOne {
    var optionalString : String?
    
    required init(_optionalString: AnyObject?) {
        optionalString  = UTMapper.typeCast(_optionalString)
    }
    
    convenience init?(_ dictionary: Dictionary<String, AnyObject>) {
        let dynamicTypeString = String(self.dynamicType)
        let className = dynamicTypeString.componentsSeparatedByString(".").last
        
        if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {
            self.init(_optionalString: valuesDict["optionalString"]!)
        } else {
            return nil
        }
    }
}
