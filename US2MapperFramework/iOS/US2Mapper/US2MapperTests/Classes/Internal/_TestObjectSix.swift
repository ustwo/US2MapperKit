import Foundation

class _TestObjectSix {

	var optionalCompoundString : String?

	var non_optionalCompoundString : String

 	required init(_non_optionalCompoundString : String) {
 			
 			non_optionalCompoundString = _non_optionalCompoundString
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

 		let dynamicTypeString = "\(self.dynamicType)"
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = US2Mapper.parseJSONResponse(className!, data : dictionary) {

			let temp_non_optionalCompoundString : String = US2Mapper.typeCast(valuesDict["non_optionalCompoundString"])!
	
 			self.init(_non_optionalCompoundString : temp_non_optionalCompoundString) 
 		
			if let unwrapped_optionalCompoundString : AnyObject = valuesDict["optionalCompoundString"] as AnyObject? {
 					optionalCompoundString = US2Mapper.typeCast(unwrapped_optionalCompoundString)
 			}
 
 		} else {
 			self.init(_non_optionalCompoundString : String())
 			return nil
 		}
 	}
} 