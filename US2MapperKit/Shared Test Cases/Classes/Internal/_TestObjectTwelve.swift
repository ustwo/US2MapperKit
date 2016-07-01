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

		if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance, defaultsEnabled : true) {

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
		
			if let unwrapped_optionalInt : Any = valuesDict["optionalInt"]  {
				optionalInt = typeCast(unwrapped_optionalInt)
			}

			if let unwrapped_optionalBool : Any = valuesDict["optionalBool"]  {
				optionalBool = typeCast(unwrapped_optionalBool)
			}

			if let unwrapped_optionalString : Any = valuesDict["optionalString"]  {
				optionalString = typeCast(unwrapped_optionalString)
			}

			if let unwrapped_optionalDouble : Any = valuesDict["optionalDouble"]  {
				optionalDouble = typeCast(unwrapped_optionalDouble)
			}

			if let unwrapped_optionalFloat : Any = valuesDict["optionalFloat"]  {
				optionalFloat = typeCast(unwrapped_optionalFloat)
			}
 
		} else {
			return nil
		}
	}

	func updateWithDictionary(dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance, defaultsEnabled : false) {
			if let unwrapped_non_optionalDouble : Any = valuesDict["non_optionalDouble"] {
				non_optionalDouble = typeCast(unwrapped_non_optionalDouble)!
			}

			if let unwrapped_optionalInt : Any = valuesDict["optionalInt"]  {
				optionalInt = typeCast(unwrapped_optionalInt)
			}

			if let unwrapped_non_optionalFloat : Any = valuesDict["non_optionalFloat"] {
				non_optionalFloat = typeCast(unwrapped_non_optionalFloat)!
			}

			if let unwrapped_non_optionalInt : Any = valuesDict["non_optionalInt"] {
				non_optionalInt = typeCast(unwrapped_non_optionalInt)!
			}

			if let unwrapped_optionalBool : Any = valuesDict["optionalBool"]  {
				optionalBool = typeCast(unwrapped_optionalBool)
			}

			if let unwrapped_optionalString : Any = valuesDict["optionalString"]  {
				optionalString = typeCast(unwrapped_optionalString)
			}

			if let unwrapped_optionalDouble : Any = valuesDict["optionalDouble"]  {
				optionalDouble = typeCast(unwrapped_optionalDouble)
			}

			if let unwrapped_optionalFloat : Any = valuesDict["optionalFloat"]  {
				optionalFloat = typeCast(unwrapped_optionalFloat)
			}

			if let unwrapped_non_optionalBool : Any = valuesDict["non_optionalBool"] {
				non_optionalBool = typeCast(unwrapped_non_optionalBool)!
			}

			if let unwrapped_non_optionalString : Any = valuesDict["non_optionalString"] {
				non_optionalString = typeCast(unwrapped_non_optionalString)!
			}
 		} 
	}
} 