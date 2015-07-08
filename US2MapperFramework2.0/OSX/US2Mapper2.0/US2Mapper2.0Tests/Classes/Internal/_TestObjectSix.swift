import Foundation

class _TestObjectSix {

	var optionalCompoundString : String?

	var non_optionalCompoundString : String

 	required init(_optionalCompoundString : String?,
 				  _non_optionalCompoundString : String) {
 			
 			optionalCompoundString = _optionalCompoundString
 			non_optionalCompoundString = _non_optionalCompoundString
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

 		let dynamicTypeString = String(self.dynamicType)
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = US2Mapper.parseJSONResponse(className!, data : dictionary) {

			var temp_optionalCompoundString : String?

			let temp_non_optionalCompoundString : String = US2Mapper.typeCast(valuesDict["non_optionalCompoundString"])!

			if let unwrapped_optionalCompoundString = valuesDict["optionalCompoundString"] {
 				temp_optionalCompoundString = US2Mapper.typeCast(unwrapped_optionalCompoundString)
 			}
	
 			self.init(_optionalCompoundString : temp_optionalCompoundString,
 				      _non_optionalCompoundString : temp_non_optionalCompoundString) 
 		} else {
 			return nil
 		}
 	}
} 