import Foundation

class _TestObjectSix {

	var optionalCompoundString : String?

	var non_optionalCompoundString : String

 	required init(_optionalCompoundString : AnyObject?,
 				  _non_optionalCompoundString : AnyObject) {

 			optionalCompoundString = UTMapper.typeCast(_optionalCompoundString)
 			non_optionalCompoundString = UTMapper.typeCast(_non_optionalCompoundString)!
 			
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {
 		let dynamicTypeString = String(self.dynamicType)
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {
 			self.init(_optionalCompoundString : valuesDict["optionalCompoundString"]!,
 				      _non_optionalCompoundString : valuesDict["non_optionalCompoundString"]!) 
 		} else {
 			return nil
 		}
 	}
} 