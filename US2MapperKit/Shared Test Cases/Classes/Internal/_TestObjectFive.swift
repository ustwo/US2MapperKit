import Foundation


class _TestObjectFive {

	var optionalSubType : TestObjectThree?

	var non_optionalSubType : TestObjectThree

	required init(_non_optionalSubType : TestObjectThree) {
 			
 			non_optionalSubType = _non_optionalSubType
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance, defaultsEnabled : true) {

			let temp_non_optionalSubType : TestObjectThree = typeCast(valuesDict["non_optionalSubType"])!
	
			self.init(_non_optionalSubType : temp_non_optionalSubType) 
		
			if let unwrapped_optionalSubType : Any = valuesDict["optionalSubType"]  {
				optionalSubType = typeCast(unwrapped_optionalSubType)
			}
 
 		} else {
 			self.init(_non_optionalSubType : TestObjectThree(Dictionary<String, AnyObject>())!)

			return nil
		}
	}

	func updateWithDictionary(dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance, defaultsEnabled : false) {
			if let unwrapped_optionalSubType : Any = valuesDict["optionalSubType"]  {
				optionalSubType = typeCast(unwrapped_optionalSubType)
			}

			if let unwrapped_non_optionalSubType : Any = valuesDict["non_optionalSubType"] {
				non_optionalSubType = typeCast(unwrapped_non_optionalSubType)!
			}
 		} 
	}
} 