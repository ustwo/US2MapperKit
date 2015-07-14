import Foundation
import US2MapperKit

class _TestObjectSeven {

	var optionalArrayType : [TestObjectFour]?

	var non_optionalArrayType : [TestObjectFour]

	required init(_non_optionalArrayType : [TestObjectFour]) {
 			
 			non_optionalArrayType = _non_optionalArrayType
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.parseJSONResponse(className!, data : dictionary) {

			let temp_non_optionalArrayType : [TestObjectFour]  = US2Mapper.typeCast(valuesDict["non_optionalArrayType"])!
	
			self.init(_non_optionalArrayType : temp_non_optionalArrayType) 
		
			if let unwrapped_optionalArrayType : AnyObject = valuesDict["optionalArrayType"] as AnyObject? {
				optionalArrayType = US2Mapper.typeCast(unwrapped_optionalArrayType)
			}
 
		} else {
			return nil
		}
	}
} 