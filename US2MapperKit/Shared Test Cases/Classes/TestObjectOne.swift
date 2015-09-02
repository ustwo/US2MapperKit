//
//  TestObjectOne.swift
//  US2Mapper
//
//  Created by Anton Doudarev on 6/25/15.
//  Copyright © 2015 US2Mapper. All rights reserved.
//

import Foundation

class _TestObjectOne {
    var optionalString : String?
    
    required init(_optionalString: AnyObject?) {
        optionalString  = typeCast(_optionalString)
    }
    
    convenience init?(_ dictionary: Dictionary<String, AnyObject>) {
        let dynamicTypeString = "\(self.dynamicType)"
        let className = dynamicTypeString.componentsSeparatedByString(".").last
        
        if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance, defaultsEnabled: true) {
            self.init(_optionalString: valuesDict["optionalString"]!)
        } else {
            self.init(_optionalString : nil)
            return nil
        }
    }
}
