import Foundation

class _TestObjectTwelve {

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

 	required init(_optionalInt : Int?,
 				  _optionalBool : Bool?,
 				  _optionalString : String?,
 				  _optionalDouble : Double?,
 				  _optionalFloat : Float?,
 				  _non_optionalDouble : Double,
 				  _non_optionalFloat : Float,
 				  _non_optionalInt : Int,
 				  _non_optionalBool : Bool,
 				  _non_optionalString : String) {
 			
 			optionalInt = _optionalInt
 			optionalBool = _optionalBool
 			optionalString = _optionalString
 			optionalDouble = _optionalDouble
 			optionalFloat = _optionalFloat
 			non_optionalDouble = _non_optionalDouble
 			non_optionalFloat = _non_optionalFloat
 			non_optionalInt = _non_optionalInt
 			non_optionalBool = _non_optionalBool
 			non_optionalString = _non_optionalString
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

 		let dynamicTypeString = String(self.dynamicType)
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {

			var temp_optionalInt : Int?
			var temp_optionalBool : Bool?
			var temp_optionalString : String?
			var temp_optionalDouble : Double?
			var temp_optionalFloat : Float?

			let temp_non_optionalDouble : Double = UTMapper.typeCast(valuesDict["non_optionalDouble"])!
			let temp_non_optionalFloat : Float = UTMapper.typeCast(valuesDict["non_optionalFloat"])!
			let temp_non_optionalInt : Int = UTMapper.typeCast(valuesDict["non_optionalInt"])!
			let temp_non_optionalBool : Bool = UTMapper.typeCast(valuesDict["non_optionalBool"])!
			let temp_non_optionalString : String = UTMapper.typeCast(valuesDict["non_optionalString"])!

			if let unwrapped_optionalInt = valuesDict["optionalInt"] {
 				temp_optionalInt = UTMapper.typeCast(unwrapped_optionalInt)
 			}

			if let unwrapped_optionalBool = valuesDict["optionalBool"] {
 				temp_optionalBool = UTMapper.typeCast(unwrapped_optionalBool)
 			}

			if let unwrapped_optionalString = valuesDict["optionalString"] {
 				temp_optionalString = UTMapper.typeCast(unwrapped_optionalString)
 			}

			if let unwrapped_optionalDouble = valuesDict["optionalDouble"] {
 				temp_optionalDouble = UTMapper.typeCast(unwrapped_optionalDouble)
 			}

			if let unwrapped_optionalFloat = valuesDict["optionalFloat"] {
 				temp_optionalFloat = UTMapper.typeCast(unwrapped_optionalFloat)
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
 			return nil
 		}
 	}
} 