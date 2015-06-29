import Foundation

class _TestObjectEight {

	var optionalDictionaryType : Dictionary<String,TestObjectFour>?

	var non_optionalDictionaryType : Dictionary<String,TestObjectFour>

 	required init(_optionalDictionaryType : AnyObject?,
 				  _non_optionalDictionaryType : AnyObject) {

 			optionalDictionaryType = UTMapper.typeCast(_optionalDictionaryType)
 			non_optionalDictionaryType = UTMapper.typeCast(_non_optionalDictionaryType)!
 			
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {
 		let dynamicTypeString = String(self.dynamicType)
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {
 			self.init(_optionalDictionaryType : valuesDict["optionalDictionaryType"]!,
 				      _non_optionalDictionaryType : valuesDict["non_optionalDictionaryType"]!) 
 		} else {
 			return nil
 		}
 	}
} 