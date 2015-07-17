//
//  Validator.swift
//  US2MapperKit
//
//  Created by Anton Doudarev on 7/17/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

import Foundation

public class Validator {
    
    // MARK Validates that all the non-optional values were received or defaulted
    
    final class func validateResponse(forValues retrievedValues :  Dictionary<String, AnyObject>, mappedTo mappingConfiguration : Dictionary<String, Dictionary<String, AnyObject>>, forType className : String) -> Bool {
        
        #if US2MAPPER_DEBUG
            var missingPropertyKeyArray = Array<String>()
        #endif
        
        // Validate that all non-optional properties have a value assigned
       
        for (propertyKey, propertyMapping) in mappingConfiguration {
            if let isPropertyNonOptional : AnyObject = propertyMapping[US2MapperNonOptionalKey] {
                if isPropertyNonOptional.boolValue == true {
                    if let _ = retrievedValues[propertyKey] {
                        // If value was mapped, continue with validation
                        continue
                    } else {
                        #if US2MAPPER_DEBUG
                            missingPropertyKeyArray.append(propertyKey)
                            #else
                            return false
                        #endif
                    }
                }
            }
        }
        
        #if US2MAPPER_DEBUG
            if (missingPropertyKeyArray.count > 0) {
                printDebugStatement(className, missingPropertyKeyArray: missingPropertyKeyArray)
                return false
            }
        #endif
        
        return true
    }
    
    // MARK Debug Enabled Methods
    
    final class func printDebugStatement(className : String, missingPropertyKeyArray : Array<String>){
        if (missingPropertyKeyArray.count > 0) {
            print("\n\n\(className) instance could not be parsed, missing values the following non-optional properties:")
            for propertyKey in missingPropertyKeyArray {
                print("\n- \(propertyKey)")
            }
            print("\n\n")
        }
    }
}