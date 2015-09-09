import Foundation


class _TestObjectTen {

	var optionalDictionaryFloatType : Dictionary<String,Float>?
	var optionalDictionaryStringType : Dictionary<String,String>?
	var optionalDictionaryIntType : Dictionary<String,Int>?
	var optionalDictionaryDoubleType : Dictionary<String,Double>?

	var non_optionalDictionaryDoubleType : Dictionary<String,Double>
	var non_optionalDictionaryIntType : Dictionary<String,Int>
	var non_optionalDictionaryFloatType : Dictionary<String,Float>
	var non_optionalDictionaryStringType : Dictionary<String,String>

	required init(_non_optionalDictionaryDoubleType : Dictionary<String, Double>,
				  _non_optionalDictionaryIntType : Dictionary<String, Int>,
				  _non_optionalDictionaryFloatType : Dictionary<String, Float>,
				  _non_optionalDictionaryStringType : Dictionary<String, String>) {
 			
 			non_optionalDictionaryDoubleType = _non_optionalDictionaryDoubleType
 			non_optionalDictionaryIntType = _non_optionalDictionaryIntType
 			non_optionalDictionaryFloatType = _non_optionalDictionaryFloatType
 			non_optionalDictionaryStringType = _non_optionalDictionaryStringType
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance, defaultsEnabled : true) {

			let temp_non_optionalDictionaryDoubleType : Dictionary<String, Double> = typeCast(valuesDict["non_optionalDictionaryDoubleType"])!
			let temp_non_optionalDictionaryIntType : Dictionary<String, Int> = typeCast(valuesDict["non_optionalDictionaryIntType"])!
			let temp_non_optionalDictionaryFloatType : Dictionary<String, Float> = typeCast(valuesDict["non_optionalDictionaryFloatType"])!
			let temp_non_optionalDictionaryStringType : Dictionary<String, String> = typeCast(valuesDict["non_optionalDictionaryStringType"])!
	
			self.init(_non_optionalDictionaryDoubleType : temp_non_optionalDictionaryDoubleType,
					 _non_optionalDictionaryIntType : temp_non_optionalDictionaryIntType,
					 _non_optionalDictionaryFloatType : temp_non_optionalDictionaryFloatType,
					 _non_optionalDictionaryStringType : temp_non_optionalDictionaryStringType) 
		
			if let unwrapped_optionalDictionaryFloatType : Any = valuesDict["optionalDictionaryFloatType"]  {
				optionalDictionaryFloatType = typeCast(unwrapped_optionalDictionaryFloatType)
			}

			if let unwrapped_optionalDictionaryStringType : Any = valuesDict["optionalDictionaryStringType"]  {
				optionalDictionaryStringType = typeCast(unwrapped_optionalDictionaryStringType)
			}

			if let unwrapped_optionalDictionaryIntType : Any = valuesDict["optionalDictionaryIntType"]  {
				optionalDictionaryIntType = typeCast(unwrapped_optionalDictionaryIntType)
			}

			if let unwrapped_optionalDictionaryDoubleType : Any = valuesDict["optionalDictionaryDoubleType"]  {
				optionalDictionaryDoubleType = typeCast(unwrapped_optionalDictionaryDoubleType)
			}
 
 		} else {
 			self.init(_non_optionalDictionaryDoubleType : Dictionary<String,Double>(),
				  _non_optionalDictionaryIntType : Dictionary<String,Int>(),
				  _non_optionalDictionaryFloatType : Dictionary<String,Float>(),
				  _non_optionalDictionaryStringType : Dictionary<String,String>())

			return nil
		}
	}

	func updateWithDictionary(dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance, defaultsEnabled : false) {
			if let unwrapped_non_optionalDictionaryDoubleType : Any = valuesDict["non_optionalDictionaryDoubleType"] {
				non_optionalDictionaryDoubleType = typeCast(unwrapped_non_optionalDictionaryDoubleType)!
			}

			if let unwrapped_optionalDictionaryFloatType : Any = valuesDict["optionalDictionaryFloatType"]  {
				optionalDictionaryFloatType = typeCast(unwrapped_optionalDictionaryFloatType)
			}

			if let unwrapped_optionalDictionaryStringType : Any = valuesDict["optionalDictionaryStringType"]  {
				optionalDictionaryStringType = typeCast(unwrapped_optionalDictionaryStringType)
			}

			if let unwrapped_optionalDictionaryIntType : Any = valuesDict["optionalDictionaryIntType"]  {
				optionalDictionaryIntType = typeCast(unwrapped_optionalDictionaryIntType)
			}

			if let unwrapped_non_optionalDictionaryIntType : Any = valuesDict["non_optionalDictionaryIntType"] {
				non_optionalDictionaryIntType = typeCast(unwrapped_non_optionalDictionaryIntType)!
			}

			if let unwrapped_non_optionalDictionaryFloatType : Any = valuesDict["non_optionalDictionaryFloatType"] {
				non_optionalDictionaryFloatType = typeCast(unwrapped_non_optionalDictionaryFloatType)!
			}

			if let unwrapped_non_optionalDictionaryStringType : Any = valuesDict["non_optionalDictionaryStringType"] {
				non_optionalDictionaryStringType = typeCast(unwrapped_non_optionalDictionaryStringType)!
			}

			if let unwrapped_optionalDictionaryDoubleType : Any = valuesDict["optionalDictionaryDoubleType"]  {
				optionalDictionaryDoubleType = typeCast(unwrapped_optionalDictionaryDoubleType)
			}
 		} 
	}
} 