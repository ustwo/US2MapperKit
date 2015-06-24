//
//  TestModelObjectDefinitions.swift
//  UTMapper
//
//  Created by Anton on 6/24/15.
//  Copyright © 2015 UTMapper. All rights reserved.
//

import Foundation

// MARK Test Object One

class TestObjectOne : _TestObjectOne { }
class _TestObjectOne {
    var optionalString : String?
    
    required init(_optionalString: AnyObject?) {
        optionalString  = UTMapper.typeCast(_optionalString)
    }
    
    convenience init?(_ dictionary: NSDictionary) {
        let dynamicTypeString = String(self.dynamicType)
        let className = dynamicTypeString.componentsSeparatedByString(".").last
        
        if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {
            self.init(_optionalString: valuesDict["optionalString"]!)
        } else {
            return nil
        }
    }
}


// MARK Test Object Two

class TestObjectTwo : _TestObjectTwo {}
class _TestObjectTwo {
    
    var optionalString : String?
    var optionalDouble : Double?
    var optionalInt : Int?
    var optionalFloat : Float?
    var optionalBool : Bool?
    
    var non_optionalString : String
    var non_optionalInt : Int
    var non_optionalDouble : Double
    var non_optionalFloat : Float
    var non_optionalBool : Bool
    
    required init(_optionalString: AnyObject?,
        _optionalDouble: AnyObject?,
        _optionalInt: AnyObject?,
        _optionalFloat: AnyObject?,
        _optionalBool : AnyObject?,
        _non_optionalString: AnyObject,
        _non_optionalDouble: AnyObject,
        _non_optionalInt: AnyObject,
        _non_optionalFloat: AnyObject,
        _non_optionalBool : AnyObject) {
            
            optionalString  = UTMapper.typeCast(_optionalString)
            optionalDouble  = UTMapper.typeCast(_optionalDouble)
            optionalInt     = UTMapper.typeCast(_optionalInt)
            optionalFloat   = UTMapper.typeCast(_optionalFloat)
            optionalBool    = UTMapper.typeCast(_optionalBool)
            
            non_optionalString  = UTMapper.typeCast(_non_optionalString)!
            non_optionalDouble  = UTMapper.typeCast(_non_optionalDouble)!
            non_optionalInt     = UTMapper.typeCast(_non_optionalInt)!
            non_optionalFloat   = UTMapper.typeCast(_non_optionalFloat)!
            non_optionalBool    = UTMapper.typeCast(_non_optionalBool)!
    }
    
    convenience init?(_ dictionary: NSDictionary) {
        let dynamicTypeString = String(self.dynamicType)
        let className = dynamicTypeString.componentsSeparatedByString(".").last
        
        if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {
            self.init(_optionalString:      valuesDict["optionalString"]!,
                _optionalDouble:      valuesDict["optionalDouble"]!,
                _optionalInt:         valuesDict["optionalInt"]!,
                _optionalFloat:       valuesDict["optionalFloat"]!,
                _optionalBool :       valuesDict["optionalBool"]! ,
                _non_optionalString:  valuesDict["non_optionalString"]!,
                _non_optionalDouble:  valuesDict["non_optionalDouble"]!,
                _non_optionalInt:     valuesDict["non_optionalInt"]!,
                _non_optionalFloat:   valuesDict["non_optionalFloat"]!,
                _non_optionalBool :   valuesDict["non_optionalBool"]!)
        } else {
            return nil
        }
    }
}

// MARK Test Object Three

class TestObjectThree : _TestObjectThree { }

class _TestObjectThree {
    
    var optionalString : String?
    var optionalDouble : Double?
    var optionalInt : Int?
    var optionalFloat : Float?
    var optionalBool : Bool?
    
    var non_optionalString : String
    var non_optionalInt : Int
    var non_optionalDouble : Double
    var non_optionalFloat : Float
    var non_optionalBool : Bool
    
    required init(_optionalString: AnyObject?,
        _optionalDouble: AnyObject?,
        _optionalInt: AnyObject?,
        _optionalFloat: AnyObject?,
        _optionalBool : AnyObject?,
        _non_optionalString: AnyObject,
        _non_optionalDouble: AnyObject,
        _non_optionalInt: AnyObject,
        _non_optionalFloat: AnyObject,
        _non_optionalBool : AnyObject) {
            
            optionalString  = UTMapper.typeCast(_optionalString)
            optionalDouble  = UTMapper.typeCast(_optionalDouble)
            optionalInt     = UTMapper.typeCast(_optionalInt)
            optionalFloat   = UTMapper.typeCast(_optionalFloat)
            optionalBool    = UTMapper.typeCast(_optionalBool)
            
            non_optionalString  = UTMapper.typeCast(_non_optionalString)!
            non_optionalDouble  = UTMapper.typeCast(_non_optionalDouble)!
            non_optionalInt     = UTMapper.typeCast(_non_optionalInt)!
            non_optionalFloat   = UTMapper.typeCast(_non_optionalFloat)!
            non_optionalBool    = UTMapper.typeCast(_non_optionalBool)!
    }
    
    convenience init?(_ dictionary: NSDictionary) {
        let dynamicTypeString = String(self.dynamicType)
        let className = dynamicTypeString.componentsSeparatedByString(".").last
        
        if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {
            self.init(_optionalString:      valuesDict["optionalString"]!,
                _optionalDouble:      valuesDict["optionalDouble"]!,
                _optionalInt:         valuesDict["optionalInt"]!,
                _optionalFloat:       valuesDict["optionalFloat"]!,
                _optionalBool :       valuesDict["optionalBool"]! ,
                _non_optionalString:  valuesDict["non_optionalString"]!,
                _non_optionalDouble:  valuesDict["non_optionalDouble"]!,
                _non_optionalInt:     valuesDict["non_optionalInt"]!,
                _non_optionalFloat:   valuesDict["non_optionalFloat"]!,
                _non_optionalBool :   valuesDict["non_optionalBool"]!)
        } else {
            return nil
        }
    }
}


// MARK Test Object Four

class TestObjectFour : _TestObjectFour {}

class _TestObjectFour {
    
    var optionalString : String?
    var optionalDouble : Double?
    var optionalInt : Int?
    var optionalFloat : Float?
    var optionalBool : Bool?
    
    var non_optionalString : String
    var non_optionalInt : Int
    var non_optionalDouble : Double
    var non_optionalFloat : Float
    var non_optionalBool : Bool
    
    required init(_optionalString: AnyObject?,
        _optionalDouble: AnyObject?,
        _optionalInt: AnyObject?,
        _optionalFloat: AnyObject?,
        _optionalBool : AnyObject?,
        _non_optionalString: AnyObject,
        _non_optionalDouble: AnyObject,
        _non_optionalInt: AnyObject,
        _non_optionalFloat: AnyObject,
        _non_optionalBool : AnyObject) {
            
            optionalString  = UTMapper.typeCast(_optionalString)
            optionalDouble  = UTMapper.typeCast(_optionalDouble)
            optionalInt     = UTMapper.typeCast(_optionalInt)
            optionalFloat   = UTMapper.typeCast(_optionalFloat)
            optionalBool    = UTMapper.typeCast(_optionalBool)
            
            non_optionalString  = UTMapper.typeCast(_non_optionalString)!
            non_optionalDouble  = UTMapper.typeCast(_non_optionalDouble)!
            non_optionalInt     = UTMapper.typeCast(_non_optionalInt)!
            non_optionalFloat   = UTMapper.typeCast(_non_optionalFloat)!
            non_optionalBool    = UTMapper.typeCast(_non_optionalBool)!
    }
    
    convenience init?(_ dictionary: NSDictionary) {
        let dynamicTypeString = String(self.dynamicType)
        let className = dynamicTypeString.componentsSeparatedByString(".").last
        
        if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {
            self.init(_optionalString:      valuesDict["optionalString"]!,
                _optionalDouble:      valuesDict["optionalDouble"]!,
                _optionalInt:         valuesDict["optionalInt"]!,
                _optionalFloat:       valuesDict["optionalFloat"]!,
                _optionalBool :       valuesDict["optionalBool"]! ,
                _non_optionalString:  valuesDict["non_optionalString"]!,
                _non_optionalDouble:  valuesDict["non_optionalDouble"]!,
                _non_optionalInt:     valuesDict["non_optionalInt"]!,
                _non_optionalFloat:   valuesDict["non_optionalFloat"]!,
                _non_optionalBool :   valuesDict["non_optionalBool"]!)
        } else {
            return nil
        }
    }

}



