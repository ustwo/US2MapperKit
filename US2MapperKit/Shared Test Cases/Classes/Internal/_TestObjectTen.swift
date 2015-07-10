import Foundation
import US2MapperKit

class _TestObjectTen {

	var optionalDictionaryFloatType : Dictionary<String,Float>?
	var optionalDictionaryStringType : Dictionary<String,String>?
	var optionalDictionaryIntType : Dictionary<String,Int>?
	var optionalDictionaryDoubleType : Dictionary<String,Double>?

	var non_optionalDictionaryDoubleType : Dictionary<String,Double>
	var non_optionalDictionaryIntType : Dictionary<String,Int>
	var non_optionalDictionaryFloatType : Dictionary<String,Float>
	var non_optionalDictionaryStringType : Dictionary<String,String>

 	required init(_non_optionalDictionaryDoubleType : Dictionary<String, Double>,
 				  _non_optionalDictionaryIntType : Dictionary<String, Int>,
 				  _non_optionalDictionaryFloatType : Dictionary<String, Float>,
 				  _non_optionalDictionaryStringType : Dictionary<String, String>) {
 			
 			non_optionalDictionaryDoubleType = _non_optionalDictionaryDoubleType
 			non_optionalDictionaryIntType = _non_optionalDictionaryIntType
 			non_optionalDictionaryFloatType = _non_optionalDictionaryFloatType
 			non_optionalDictionaryStringType = _non_optionalDictionaryStringType
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

 		let dynamicTypeString = "\(self.dynamicType)"
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = US2Mapper.parseJSONResponse(className!, data : dictionary) {

			let temp_non_optionalDictionaryDoubleType : Dictionary<String, Double> = US2Mapper.typeCast(valuesDict["non_optionalDictionaryDoubleType"])!
			let temp_non_optionalDictionaryIntType : Dictionary<String, Int> = US2Mapper.typeCast(valuesDict["non_optionalDictionaryIntType"])!
			let temp_non_optionalDictionaryFloatType : Dictionary<String, Float> = US2Mapper.typeCast(valuesDict["non_optionalDictionaryFloatType"])!
			let temp_non_optionalDictionaryStringType : Dictionary<String, String> = US2Mapper.typeCast(valuesDict["non_optionalDictionaryStringType"])!
	
 			self.init(_non_optionalDictionaryDoubleType : temp_non_optionalDictionaryDoubleType,
 				      _non_optionalDictionaryIntType : temp_non_optionalDictionaryIntType,
 				      _non_optionalDictionaryFloatType : temp_non_optionalDictionaryFloatType,
 				      _non_optionalDictionaryStringType : temp_non_optionalDictionaryStringType) 
 		
			if let unwrapped_optionalDictionaryFloatType : AnyObject = valuesDict["optionalDictionaryFloatType"]  as AnyObject? {
 					optionalDictionaryFloatType = US2Mapper.typeCast(unwrapped_optionalDictionaryFloatType)
 			}

			if let unwrapped_optionalDictionaryStringType : AnyObject = valuesDict["optionalDictionaryStringType"]  as AnyObject? {
 					optionalDictionaryStringType = US2Mapper.typeCast(unwrapped_optionalDictionaryStringType)
 			}

			if let unwrapped_optionalDictionaryIntType : AnyObject = valuesDict["optionalDictionaryIntType"]  as AnyObject? {
 					optionalDictionaryIntType = US2Mapper.typeCast(unwrapped_optionalDictionaryIntType)
 			}

			if let unwrapped_optionalDictionaryDoubleType : AnyObject = valuesDict["optionalDictionaryDoubleType"]  as AnyObject? {
 					optionalDictionaryDoubleType = US2Mapper.typeCast(unwrapped_optionalDictionaryDoubleType)
 			}
 
 		} else {
 			self.init(_non_optionalDictionaryDoubleType : Dictionary<String,Double>(),
 				      _non_optionalDictionaryIntType : Dictionary<String,Int>(),
 				      _non_optionalDictionaryFloatType : Dictionary<String,Float>(),
 				      _non_optionalDictionaryStringType : Dictionary<String,String>())
 			return nil
 		}
 	}
} 