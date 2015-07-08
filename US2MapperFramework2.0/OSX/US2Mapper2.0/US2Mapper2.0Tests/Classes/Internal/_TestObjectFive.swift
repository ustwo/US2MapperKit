import Foundation

class _TestObjectFive {

	var optionalSubType : TestObjectThree?

	var non_optionalSubType : TestObjectThree

 	required init(_optionalSubType : TestObjectThree?,
 				  _non_optionalSubType : TestObjectThree) {
 			
 			optionalSubType = _optionalSubType
 			non_optionalSubType = _non_optionalSubType
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

 		let dynamicTypeString = String(self.dynamicType)
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = US2Mapper.parseJSONResponse(className!, data : dictionary) {

			var temp_optionalSubType : TestObjectThree?

			let temp_non_optionalSubType : TestObjectThree = US2Mapper.typeCast(valuesDict["non_optionalSubType"])!

			if let unwrapped_optionalSubType = valuesDict["optionalSubType"] {
 				temp_optionalSubType = US2Mapper.typeCast(unwrapped_optionalSubType)
 			}
	
 			self.init(_optionalSubType : temp_optionalSubType,
 				      _non_optionalSubType : temp_non_optionalSubType) 
 		} else {
 			return nil
 		}
 	}
} 