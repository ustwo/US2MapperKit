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

		if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Instantiator.sharedInstance) {

			let temp_non_optionalSubType : TestObjectThree = typeCast(valuesDict["non_optionalSubType"])!
	
			self.init(_non_optionalSubType : temp_non_optionalSubType) 
		
			if let unwrapped_optionalSubType : AnyObject = valuesDict["optionalSubType"] as AnyObject? {
				optionalSubType = typeCast(unwrapped_optionalSubType)
			}
 
 		} else {
 			self.init(_non_optionalSubType : TestObjectThree(Dictionary<String, AnyObject>())!)

			return nil
		}
	}
} 