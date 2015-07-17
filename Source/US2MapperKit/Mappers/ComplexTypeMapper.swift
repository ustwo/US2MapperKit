//
//  ComplexTypeMapper.swift
//  US2MapperKit
//
//  Created by Anton on 7/17/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

import Foundation

final class ComplexTypeMapper {
    
    class func complexObject(fromValue data : Dictionary<String, AnyObject>, ofType objectType : String?, using instantiator : US2GeneratorProtocol) -> AnyObject? {
        
        if let complexTypeValue: AnyObject = instantiator.newInstance(ofType: objectType!, withValue: data) {
            return complexTypeValue
        }
        
        return nil
    }
}