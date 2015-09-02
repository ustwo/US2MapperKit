import Foundation


class _TestObjectNine {

	var optionalArrayIntType : [Int]?
	var optionalArrayStringType : [String]?
	var optionalArrayDoubleType : [Double]?
	var optionalArrayFloatType : [Float]?

	var non_optionalArrayFloatType : [Float]
	var non_optionalArrayDoubleType : [Double]
	var non_optionalArrayIntType : [Int]
	var non_optionalArrayStringType : [String]

	required init(_non_optionalArrayFloatType : [Float],
				  _non_optionalArrayDoubleType : [Double],
				  _non_optionalArrayIntType : [Int],
				  _non_optionalArrayStringType : [String]) {
 			
 			non_optionalArrayFloatType = _non_optionalArrayFloatType
 			non_optionalArrayDoubleType = _non_optionalArrayDoubleType
 			non_optionalArrayIntType = _non_optionalArrayIntType
 			non_optionalArrayStringType = _non_optionalArrayStringType
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance, defaultsEnabled : true) {

			let temp_non_optionalArrayFloatType : [Float]  = typeCast(valuesDict["non_optionalArrayFloatType"])!
			let temp_non_optionalArrayDoubleType : [Double]  = typeCast(valuesDict["non_optionalArrayDoubleType"])!
			let temp_non_optionalArrayIntType : [Int]  = typeCast(valuesDict["non_optionalArrayIntType"])!
			let temp_non_optionalArrayStringType : [String]  = typeCast(valuesDict["non_optionalArrayStringType"])!
	
			self.init(_non_optionalArrayFloatType : temp_non_optionalArrayFloatType,
					 _non_optionalArrayDoubleType : temp_non_optionalArrayDoubleType,
					 _non_optionalArrayIntType : temp_non_optionalArrayIntType,
					 _non_optionalArrayStringType : temp_non_optionalArrayStringType) 
		
			if let unwrapped_optionalArrayIntType : AnyObject = valuesDict["optionalArrayIntType"] as AnyObject? {
				optionalArrayIntType = typeCast(unwrapped_optionalArrayIntType)
			}

			if let unwrapped_optionalArrayStringType : AnyObject = valuesDict["optionalArrayStringType"] as AnyObject? {
				optionalArrayStringType = typeCast(unwrapped_optionalArrayStringType)
			}

			if let unwrapped_optionalArrayDoubleType : AnyObject = valuesDict["optionalArrayDoubleType"] as AnyObject? {
				optionalArrayDoubleType = typeCast(unwrapped_optionalArrayDoubleType)
			}

			if let unwrapped_optionalArrayFloatType : AnyObject = valuesDict["optionalArrayFloatType"] as AnyObject? {
				optionalArrayFloatType = typeCast(unwrapped_optionalArrayFloatType)
			}
 
 		} else {
 			self.init(_non_optionalArrayFloatType : [Float](),
				  _non_optionalArrayDoubleType : [Double](),
				  _non_optionalArrayIntType : [Int](),
				  _non_optionalArrayStringType : [String]())

			return nil
		}
	}

	func updateWithDictionary(dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance, defaultsEnabled : false) {
			if let unwrapped_optionalArrayIntType : AnyObject = valuesDict["optionalArrayIntType"] as AnyObject? {
				optionalArrayIntType = typeCast(unwrapped_optionalArrayIntType)
			}

			if let unwrapped_optionalArrayStringType : AnyObject = valuesDict["optionalArrayStringType"] as AnyObject? {
				optionalArrayStringType = typeCast(unwrapped_optionalArrayStringType)
			}

			if let unwrapped_non_optionalArrayFloatType : AnyObject = valuesDict["non_optionalArrayFloatType"] as AnyObject? {
				non_optionalArrayFloatType = typeCast(unwrapped_non_optionalArrayFloatType)!
			}

			if let unwrapped_non_optionalArrayDoubleType : AnyObject = valuesDict["non_optionalArrayDoubleType"] as AnyObject? {
				non_optionalArrayDoubleType = typeCast(unwrapped_non_optionalArrayDoubleType)!
			}

			if let unwrapped_non_optionalArrayIntType : AnyObject = valuesDict["non_optionalArrayIntType"] as AnyObject? {
				non_optionalArrayIntType = typeCast(unwrapped_non_optionalArrayIntType)!
			}

			if let unwrapped_non_optionalArrayStringType : AnyObject = valuesDict["non_optionalArrayStringType"] as AnyObject? {
				non_optionalArrayStringType = typeCast(unwrapped_non_optionalArrayStringType)!
			}

			if let unwrapped_optionalArrayDoubleType : AnyObject = valuesDict["optionalArrayDoubleType"] as AnyObject? {
				optionalArrayDoubleType = typeCast(unwrapped_optionalArrayDoubleType)
			}

			if let unwrapped_optionalArrayFloatType : AnyObject = valuesDict["optionalArrayFloatType"] as AnyObject? {
				optionalArrayFloatType = typeCast(unwrapped_optionalArrayFloatType)
			}
 		} 
	}
} 