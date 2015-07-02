import Foundation

class _TestObjectSeven {

	var optionalArrayType : [TestObjectFour]?

	var non_optionalArrayType : [TestObjectFour]

 	required init(_optionalArrayType : AnyObject?,
 				  _non_optionalArrayType : AnyObject) {

 			optionalArrayType = UTMapper.typeCast(_optionalArrayType)
 			non_optionalArrayType = UTMapper.typeCast(_non_optionalArrayType)!
 			
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {
 		let dynamicTypeString = String(self.dynamicType)
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {
 			self.init(_optionalArrayType : valuesDict["optionalArrayType"]!,
 				      _non_optionalArrayType : valuesDict["non_optionalArrayType"]!) 
 		} else {
 			return nil
 		}
 	}
} 