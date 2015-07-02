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

 	required init(_optionalInt : AnyObject?,
 				  _optionalBool : AnyObject?,
 				  _optionalString : AnyObject?,
 				  _optionalDouble : AnyObject?,
 				  _optionalFloat : AnyObject?,
 				  _non_optionalDouble : AnyObject,
 				  _non_optionalFloat : AnyObject,
 				  _non_optionalInt : AnyObject,
 				  _non_optionalBool : AnyObject,
 				  _non_optionalString : AnyObject) {

 			optionalInt = UTMapper.typeCast(_optionalInt)
 			optionalBool = UTMapper.typeCast(_optionalBool)
 			optionalString = UTMapper.typeCast(_optionalString)
 			optionalDouble = UTMapper.typeCast(_optionalDouble)
 			optionalFloat = UTMapper.typeCast(_optionalFloat)
 			non_optionalDouble = UTMapper.typeCast(_non_optionalDouble)!
 			non_optionalFloat = UTMapper.typeCast(_non_optionalFloat)!
 			non_optionalInt = UTMapper.typeCast(_non_optionalInt)!
 			non_optionalBool = UTMapper.typeCast(_non_optionalBool)!
 			non_optionalString = UTMapper.typeCast(_non_optionalString)!
 			
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {
 		let dynamicTypeString = String(self.dynamicType)
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {
 			self.init(_optionalInt : valuesDict["optionalInt"]!,
 				      _optionalBool : valuesDict["optionalBool"]!,
 				      _optionalString : valuesDict["optionalString"]!,
 				      _optionalDouble : valuesDict["optionalDouble"]!,
 				      _optionalFloat : valuesDict["optionalFloat"]!,
 				      _non_optionalDouble : valuesDict["non_optionalDouble"]!,
 				      _non_optionalFloat : valuesDict["non_optionalFloat"]!,
 				      _non_optionalInt : valuesDict["non_optionalInt"]!,
 				      _non_optionalBool : valuesDict["non_optionalBool"]!,
 				      _non_optionalString : valuesDict["non_optionalString"]!) 
 		} else {
 			return nil
 		}
 	}
} 