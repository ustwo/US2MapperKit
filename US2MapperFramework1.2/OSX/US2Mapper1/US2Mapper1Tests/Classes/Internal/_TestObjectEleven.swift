import Foundation

class _TestObjectEleven {

	var optionalInt : Int?
	var optionalBool : Bool?
	var optionalString : String?
	var optionalDouble : Double?
	var optionalFloat : Float?

	var non_optionalDouble : Double
	var non_optionalFloat : Float
	var non_optionalInt : Int
	var non_optionalBool : Bool
	var non_optionalString : String

 	required init(_non_optionalDouble : Double,
 				  _non_optionalFloat : Float,
 				  _non_optionalInt : Int,
 				  _non_optionalBool : Bool,
 				  _non_optionalString : String) {
 			
 			non_optionalDouble = _non_optionalDouble
 			non_optionalFloat = _non_optionalFloat
 			non_optionalInt = _non_optionalInt
 			non_optionalBool = _non_optionalBool
 			non_optionalString = _non_optionalString
 	}


 	convenience init(_optionalInt : Int?,
 				  _optionalBool : Bool?,
 				  _optionalString : String?,
 				  _optionalDouble : Double?,
 				  _optionalFloat : Float?,
 				  _non_optionalDouble : Double,
 				  _non_optionalFloat : Float,
 				  _non_optionalInt : Int,
 				  _non_optionalBool : Bool,
 				  _non_optionalString : String) {
 			
 			self.init(_non_optionalDouble : _non_optionalDouble,
 				  _non_optionalFloat : _non_optionalFloat,
 				  _non_optionalInt : _non_optionalInt,
 				  _non_optionalBool : _non_optionalBool,
 				  _non_optionalString : _non_optionalString)

 			optionalInt = _optionalInt
 			optionalBool = _optionalBool
 			optionalString = _optionalString
 			optionalDouble = _optionalDouble
 			optionalFloat = _optionalFloat
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

 		let dynamicTypeString = "\(self.dynamicType)"
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = US2Mapper.parseJSONResponse(className!, data : dictionary) {

			var temp_optionalInt : Int?
			var temp_optionalBool : Bool?
			var temp_optionalString : String?
			var temp_optionalDouble : Double?
			var temp_optionalFloat : Float?

			let temp_non_optionalDouble : Double = US2Mapper.typeCast(valuesDict["non_optionalDouble"])!
			let temp_non_optionalFloat : Float = US2Mapper.typeCast(valuesDict["non_optionalFloat"])!
			let temp_non_optionalInt : Int = US2Mapper.typeCast(valuesDict["non_optionalInt"])!
			let temp_non_optionalBool : Bool = US2Mapper.typeCast(valuesDict["non_optionalBool"])!
			let temp_non_optionalString : String = US2Mapper.typeCast(valuesDict["non_optionalString"])!

			if let unwrapped_optionalInt : AnyObject = valuesDict["optionalInt"] as AnyObject? {
 					temp_optionalInt = US2Mapper.typeCast(unwrapped_optionalInt)
 			}

			if let unwrapped_optionalBool : AnyObject = valuesDict["optionalBool"] as AnyObject? {
 					temp_optionalBool = US2Mapper.typeCast(unwrapped_optionalBool)
 			}

			if let unwrapped_optionalString : AnyObject = valuesDict["optionalString"] as AnyObject? {
 					temp_optionalString = US2Mapper.typeCast(unwrapped_optionalString)
 			}

			if let unwrapped_optionalDouble : AnyObject = valuesDict["optionalDouble"] as AnyObject? {
 					temp_optionalDouble = US2Mapper.typeCast(unwrapped_optionalDouble)
 			}

			if let unwrapped_optionalFloat : AnyObject = valuesDict["optionalFloat"] as AnyObject? {
 					temp_optionalFloat = US2Mapper.typeCast(unwrapped_optionalFloat)
 			}
	
 			self.init(_optionalInt : temp_optionalInt,
 				      _optionalBool : temp_optionalBool,
 				      _optionalString : temp_optionalString,
 				      _optionalDouble : temp_optionalDouble,
 				      _optionalFloat : temp_optionalFloat,
 				      _non_optionalDouble : temp_non_optionalDouble,
 				      _non_optionalFloat : temp_non_optionalFloat,
 				      _non_optionalInt : temp_non_optionalInt,
 				      _non_optionalBool : temp_non_optionalBool,
 				      _non_optionalString : temp_non_optionalString) 
 		} else {
            
    
                
                self.init(
                    _non_optionalDouble : 0.0,
                    _non_optionalFloat : 0.0,
                    _non_optionalInt : 1,
                    _non_optionalBool : true,
                    _non_optionalString : "")

 			return nil
 		}
 	}
} 