import Foundation


class _TestObjectEight {

	var optionalDictionaryType : Dictionary<String,TestObjectFour>?

	var non_optionalDictionaryType : Dictionary<String,TestObjectFour>

	required init(_non_optionalDictionaryType : Dictionary<String, TestObjectFour>) {
 			
 			non_optionalDictionaryType = _non_optionalDictionaryType
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance) {

			let temp_non_optionalDictionaryType : Dictionary<String, TestObjectFour> = typeCast(valuesDict["non_optionalDictionaryType"])!
	
			self.init(_non_optionalDictionaryType : temp_non_optionalDictionaryType) 
		
			if let unwrapped_optionalDictionaryType : AnyObject = valuesDict["optionalDictionaryType"] as AnyObject? {
				optionalDictionaryType = typeCast(unwrapped_optionalDictionaryType)
			}
 
 		} else {
 			self.init(_non_optionalDictionaryType : Dictionary<String,TestObjectFour>())

			return nil
		}
	}
} 