import Foundation

class _TestObjectEight {

	var optionalDictionaryType : Dictionary<String,TestObjectFour>?

	var non_optionalDictionaryType : Dictionary<String,TestObjectFour>

 	required init(_non_optionalDictionaryType : Dictionary<String, TestObjectFour>) {
 			
 			non_optionalDictionaryType = _non_optionalDictionaryType
 	}


 	convenience init(_optionalDictionaryType : Dictionary<String, TestObjectFour>?,
 				  _non_optionalDictionaryType : Dictionary<String, TestObjectFour>) {
 			
 			self.init(_non_optionalDictionaryType : _non_optionalDictionaryType)

 			optionalDictionaryType = _optionalDictionaryType
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

 		let dynamicTypeString = "\(self.dynamicType)"
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = US2Mapper.parseJSONResponse(className!, data : dictionary) {

			var temp_optionalDictionaryType : Dictionary<String, TestObjectFour>?

			let temp_non_optionalDictionaryType : Dictionary<String, TestObjectFour> = US2Mapper.typeCast(valuesDict["non_optionalDictionaryType"])!

			if let unwrapped_optionalDictionaryType : AnyObject = valuesDict["optionalDictionaryType"]  as AnyObject? {
 					temp_optionalDictionaryType = US2Mapper.typeCast(unwrapped_optionalDictionaryType)
 			}
	
 			self.init(_optionalDictionaryType : temp_optionalDictionaryType,
 				      _non_optionalDictionaryType : temp_non_optionalDictionaryType) 
 		} else {
            
              self.init(_non_optionalDictionaryType : Dictionary<String,TestObjectFour>())
       
            
 			return nil
 		}
 	}
} 