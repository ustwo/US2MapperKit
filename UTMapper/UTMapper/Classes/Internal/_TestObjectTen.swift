import Foundation

class _TestObjectTen {

	var optionalDictionaryFloatType : Dictionary<String,Float>?
	var optionalDictionaryStringType : Dictionary<String,String>?
	var optionalDictionaryIntType : Dictionary<String,Int>?
	var optionalDictionaryDoubleType : Dictionary<String,Double>?

	var non_optionalDictionaryDoubleType : Dictionary<String,Double>
	var non_optionalDictionaryIntType : Dictionary<String,Int>
	var non_optionalDictionaryFloatType : Dictionary<String,Float>
	var non_optionalDictionaryStringType : Dictionary<String,String>

 	required init(_optionalDictionaryFloatType : AnyObject?,
 				  _optionalDictionaryStringType : AnyObject?,
 				  _optionalDictionaryIntType : AnyObject?,
 				  _optionalDictionaryDoubleType : AnyObject?,
 				  _non_optionalDictionaryDoubleType : AnyObject,
 				  _non_optionalDictionaryIntType : AnyObject,
 				  _non_optionalDictionaryFloatType : AnyObject,
 				  _non_optionalDictionaryStringType : AnyObject) {

 			optionalDictionaryFloatType = UTMapper.typeCast(_optionalDictionaryFloatType)
 			optionalDictionaryStringType = UTMapper.typeCast(_optionalDictionaryStringType)
 			optionalDictionaryIntType = UTMapper.typeCast(_optionalDictionaryIntType)
 			optionalDictionaryDoubleType = UTMapper.typeCast(_optionalDictionaryDoubleType)
 			non_optionalDictionaryDoubleType = UTMapper.typeCast(_non_optionalDictionaryDoubleType)!
 			non_optionalDictionaryIntType = UTMapper.typeCast(_non_optionalDictionaryIntType)!
 			non_optionalDictionaryFloatType = UTMapper.typeCast(_non_optionalDictionaryFloatType)!
 			non_optionalDictionaryStringType = UTMapper.typeCast(_non_optionalDictionaryStringType)!
 			
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {
 		let dynamicTypeString = String(self.dynamicType)
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {
 			self.init(_optionalDictionaryFloatType : valuesDict["optionalDictionaryFloatType"]!,
 				      _optionalDictionaryStringType : valuesDict["optionalDictionaryStringType"]!,
 				      _optionalDictionaryIntType : valuesDict["optionalDictionaryIntType"]!,
 				      _optionalDictionaryDoubleType : valuesDict["optionalDictionaryDoubleType"]!,
 				      _non_optionalDictionaryDoubleType : valuesDict["non_optionalDictionaryDoubleType"]!,
 				      _non_optionalDictionaryIntType : valuesDict["non_optionalDictionaryIntType"]!,
 				      _non_optionalDictionaryFloatType : valuesDict["non_optionalDictionaryFloatType"]!,
 				      _non_optionalDictionaryStringType : valuesDict["non_optionalDictionaryStringType"]!) 
 		} else {
 			return nil
 		}
 	}
} 