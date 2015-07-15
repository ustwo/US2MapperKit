import Foundation
import US2MapperKit

class _TestObjectFive {

	var optionalSubType : TestObjectThree?

	var non_optionalSubType : TestObjectThree

	required init(_non_optionalSubType : TestObjectThree) {
 			
 			non_optionalSubType = _non_optionalSubType
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.parseJSONResponse(className!, data : dictionary) {

			let temp_non_optionalSubType : TestObjectThree = US2Mapper.typeCast(valuesDict["non_optionalSubType"])!
	
			self.init(_non_optionalSubType : temp_non_optionalSubType) 
		
			if let unwrapped_optionalSubType : AnyObject = valuesDict["optionalSubType"] as AnyObject? {
				optionalSubType = US2Mapper.typeCast(unwrapped_optionalSubType)
			}
 
 		} else {
 			self.init(_non_optionalSubType : TestObjectThree(Dictionary<String, AnyObject>())!)

			return nil
		}
	}
} 