//
//  TestObjectOne.swift
//  US2Mapper
//
//  Created by Anton on 6/25/15.
//  Copyright © 2015 US2Mapper. All rights reserved.
//

import Foundation

class _TestObjectOne {
    var optionalString : String?
    
    required init(_optionalString: AnyObject?) {
        optionalString  = US2Mapper.typeCast(_optionalString)
    }
    
    convenience init?(_ dictionary: Dictionary<String, AnyObject>) {
        let dynamicTypeString = "\(self.dynamicType)"
        let className = dynamicTypeString.componentsSeparatedByString(".").last
        
        if let valuesDict = US2Mapper.parseJSONResponse(className!, data : dictionary) {
            self.init(_optionalString: valuesDict["optionalString"]!)
        } else {
            return nil
        }
    }
}
