import Foundation


class _TestObjectThirteen {

	var optionalStruct : StructExample?
	var optionalTuple : (Double, Double)?
	var optionalUppercaseCompletionHandler : ((value : String) -> String)?
	var optionalLowercaseCompletionHandler : ((value : String) -> String)?
	var optionalEnum : EnumExample?


	required init() {
 			
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance, defaultsEnabled : true) {

	
			self.init() 
		
			if let unwrapped_optionalStruct : Any = valuesDict["optionalStruct"]  {
				optionalStruct = typeCast(unwrapped_optionalStruct)
			}

			if let unwrapped_optionalTuple : Any = valuesDict["optionalTuple"]  {
				optionalTuple = typeCast(unwrapped_optionalTuple)
			}

			if let unwrapped_optionalUppercaseCompletionHandler : Any = valuesDict["optionalUppercaseCompletionHandler"]  {
				optionalUppercaseCompletionHandler = typeCast(unwrapped_optionalUppercaseCompletionHandler)
			}

			if let unwrapped_optionalLowercaseCompletionHandler : Any = valuesDict["optionalLowercaseCompletionHandler"]  {
				optionalLowercaseCompletionHandler = typeCast(unwrapped_optionalLowercaseCompletionHandler)
			}

			if let unwrapped_optionalEnum : Any = valuesDict["optionalEnum"]  {
				optionalEnum = typeCast(unwrapped_optionalEnum)
			}
 
 		} else {
 			self.init()

			return nil
		}
	}

	func updateWithDictionary(dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance, defaultsEnabled : false) {
			if let unwrapped_optionalStruct : Any = valuesDict["optionalStruct"]  {
				optionalStruct = typeCast(unwrapped_optionalStruct)
			}

			if let unwrapped_optionalTuple : Any = valuesDict["optionalTuple"]  {
				optionalTuple = typeCast(unwrapped_optionalTuple)
			}

			if let unwrapped_optionalUppercaseCompletionHandler : Any = valuesDict["optionalUppercaseCompletionHandler"]  {
				optionalUppercaseCompletionHandler = typeCast(unwrapped_optionalUppercaseCompletionHandler)
			}

			if let unwrapped_optionalLowercaseCompletionHandler : Any = valuesDict["optionalLowercaseCompletionHandler"]  {
				optionalLowercaseCompletionHandler = typeCast(unwrapped_optionalLowercaseCompletionHandler)
			}

			if let unwrapped_optionalEnum : Any = valuesDict["optionalEnum"]  {
				optionalEnum = typeCast(unwrapped_optionalEnum)
			}
 		} 
	}
} 