import Foundation


class _TestObjectSix {

	var optionalCompoundString : String?

	var non_optionalCompoundString : String

	required init(_non_optionalCompoundString : String) {
 			
 			non_optionalCompoundString = _non_optionalCompoundString
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance, defaultsEnabled : true) {

			let temp_non_optionalCompoundString : String = typeCast(valuesDict["non_optionalCompoundString"])!
	
			self.init(_non_optionalCompoundString : temp_non_optionalCompoundString) 
		
			if let unwrapped_optionalCompoundString : Any = valuesDict["optionalCompoundString"]  {
				optionalCompoundString = typeCast(unwrapped_optionalCompoundString)
			}
 
		} else {
			return nil
		}
	}

	func updateWithDictionary(dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance, defaultsEnabled : false) {
			if let unwrapped_optionalCompoundString : Any = valuesDict["optionalCompoundString"]  {
				optionalCompoundString = typeCast(unwrapped_optionalCompoundString)
			}

			if let unwrapped_non_optionalCompoundString : Any = valuesDict["non_optionalCompoundString"] {
				non_optionalCompoundString = typeCast(unwrapped_non_optionalCompoundString)!
			}
 		} 
	}
} 