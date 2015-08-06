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

	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance) {

			let temp_non_optionalDouble : Double = typeCast(valuesDict["non_optionalDouble"])!
			let temp_non_optionalFloat : Float = typeCast(valuesDict["non_optionalFloat"])!
			let temp_non_optionalInt : Int = typeCast(valuesDict["non_optionalInt"])!
			let temp_non_optionalBool : Bool = typeCast(valuesDict["non_optionalBool"])!
			let temp_non_optionalString : String = typeCast(valuesDict["non_optionalString"])!
	
			self.init(_non_optionalDouble : temp_non_optionalDouble,
					 _non_optionalFloat : temp_non_optionalFloat,
					 _non_optionalInt : temp_non_optionalInt,
					 _non_optionalBool : temp_non_optionalBool,
					 _non_optionalString : temp_non_optionalString) 
		
			if let unwrapped_optionalInt : AnyObject = valuesDict["optionalInt"] as AnyObject? {
				optionalInt = typeCast(unwrapped_optionalInt)
			}

			if let unwrapped_optionalBool : AnyObject = valuesDict["optionalBool"] as AnyObject? {
				optionalBool = typeCast(unwrapped_optionalBool)
			}

			if let unwrapped_optionalString : AnyObject = valuesDict["optionalString"] as AnyObject? {
				optionalString = typeCast(unwrapped_optionalString)
			}

			if let unwrapped_optionalDouble : AnyObject = valuesDict["optionalDouble"] as AnyObject? {
				optionalDouble = typeCast(unwrapped_optionalDouble)
			}

			if let unwrapped_optionalFloat : AnyObject = valuesDict["optionalFloat"] as AnyObject? {
				optionalFloat = typeCast(unwrapped_optionalFloat)
			}
 
 		} else {
 			self.init(_non_optionalDouble : Double(),
				  _non_optionalFloat : Float(),
				  _non_optionalInt : Int(),
				  _non_optionalBool : Bool(),
				  _non_optionalString : String())

			return nil
		}
	}
} 