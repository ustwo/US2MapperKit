import Foundation

class _TestObjectFive {

	var optionalSubType : TestObjectThree?

	var non_optionalSubType : TestObjectThree

 	required init(_optionalSubType : AnyObject?,
 				  _non_optionalSubType : AnyObject) {

 			optionalSubType = UTMapper.typeCast(_optionalSubType)
 			non_optionalSubType = UTMapper.typeCast(_non_optionalSubType)!
 			
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {
 		let dynamicTypeString = String(self.dynamicType)
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {
 			self.init(_optionalSubType : valuesDict["optionalSubType"]!,
 				      _non_optionalSubType : valuesDict["non_optionalSubType"]!) 
 		} else {
 			return nil
 		}
 	}
} 