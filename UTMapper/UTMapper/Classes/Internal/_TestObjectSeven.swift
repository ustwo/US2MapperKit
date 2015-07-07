import Foundation

class _TestObjectSeven {

	var optionalArrayType : [TestObjectFour]?

	var non_optionalArrayType : [TestObjectFour]

 	required init(_optionalArrayType : [ TestObjectFour]?,
 				  _non_optionalArrayType : [ TestObjectFour]) {
 			
 			optionalArrayType = _optionalArrayType
 			non_optionalArrayType = _non_optionalArrayType
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

 		let dynamicTypeString = String(self.dynamicType)
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {

			var temp_optionalArrayType : [TestObjectFour]?

			let temp_non_optionalArrayType : [TestObjectFour]  = UTMapper.typeCast(valuesDict["non_optionalArrayType"])!

			if let unwrapped_optionalArrayType = valuesDict["optionalArrayType"] {
 			temp_optionalArrayType = UTMapper.typeCast(unwrapped_optionalArrayType)
 			}
	
 			self.init(_optionalArrayType : temp_optionalArrayType,
 				      _non_optionalArrayType : temp_non_optionalArrayType) 
 		} else {
 			return nil
 		}
 	}
} 