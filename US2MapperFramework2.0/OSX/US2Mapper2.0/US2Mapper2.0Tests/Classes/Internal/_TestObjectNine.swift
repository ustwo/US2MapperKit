import Foundation

class _TestObjectNine {

	var optionalArrayIntType : [Int]?
	var optionalArrayStringType : [String]?
	var optionalArrayDoubleType : [Double]?
	var optionalArrayFloatType : [Float]?

	var non_optionalArrayFloatType : [Float]
	var non_optionalArrayDoubleType : [Double]
	var non_optionalArrayIntType : [Int]
	var non_optionalArrayStringType : [String]

 	required init(_optionalArrayIntType : [ Int]?,
 				  _optionalArrayStringType : [ String]?,
 				  _optionalArrayDoubleType : [ Double]?,
 				  _optionalArrayFloatType : [ Float]?,
 				  _non_optionalArrayFloatType : [ Float],
 				  _non_optionalArrayDoubleType : [ Double],
 				  _non_optionalArrayIntType : [ Int],
 				  _non_optionalArrayStringType : [ String]) {
 			
 			optionalArrayIntType = _optionalArrayIntType
 			optionalArrayStringType = _optionalArrayStringType
 			optionalArrayDoubleType = _optionalArrayDoubleType
 			optionalArrayFloatType = _optionalArrayFloatType
 			non_optionalArrayFloatType = _non_optionalArrayFloatType
 			non_optionalArrayDoubleType = _non_optionalArrayDoubleType
 			non_optionalArrayIntType = _non_optionalArrayIntType
 			non_optionalArrayStringType = _non_optionalArrayStringType
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

 		let dynamicTypeString = String(self.dynamicType)
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = US2Mapper.parseJSONResponse(className!, data : dictionary) {

			var temp_optionalArrayIntType : [Int]?
			var temp_optionalArrayStringType : [String]?
			var temp_optionalArrayDoubleType : [Double]?
			var temp_optionalArrayFloatType : [Float]?

			let temp_non_optionalArrayFloatType : [Float]  = US2Mapper.typeCast(valuesDict["non_optionalArrayFloatType"])!
			let temp_non_optionalArrayDoubleType : [Double]  = US2Mapper.typeCast(valuesDict["non_optionalArrayDoubleType"])!
			let temp_non_optionalArrayIntType : [Int]  = US2Mapper.typeCast(valuesDict["non_optionalArrayIntType"])!
			let temp_non_optionalArrayStringType : [String]  = US2Mapper.typeCast(valuesDict["non_optionalArrayStringType"])!

			if let unwrapped_optionalArrayIntType = valuesDict["optionalArrayIntType"] {
 			temp_optionalArrayIntType = US2Mapper.typeCast(unwrapped_optionalArrayIntType)
 			}

			if let unwrapped_optionalArrayStringType = valuesDict["optionalArrayStringType"] {
 			temp_optionalArrayStringType = US2Mapper.typeCast(unwrapped_optionalArrayStringType)
 			}

			if let unwrapped_optionalArrayDoubleType = valuesDict["optionalArrayDoubleType"] {
 			temp_optionalArrayDoubleType = US2Mapper.typeCast(unwrapped_optionalArrayDoubleType)
 			}

			if let unwrapped_optionalArrayFloatType = valuesDict["optionalArrayFloatType"] {
 			temp_optionalArrayFloatType = US2Mapper.typeCast(unwrapped_optionalArrayFloatType)
 			}
	
 			self.init(_optionalArrayIntType : temp_optionalArrayIntType,
 				      _optionalArrayStringType : temp_optionalArrayStringType,
 				      _optionalArrayDoubleType : temp_optionalArrayDoubleType,
 				      _optionalArrayFloatType : temp_optionalArrayFloatType,
 				      _non_optionalArrayFloatType : temp_non_optionalArrayFloatType,
 				      _non_optionalArrayDoubleType : temp_non_optionalArrayDoubleType,
 				      _non_optionalArrayIntType : temp_non_optionalArrayIntType,
 				      _non_optionalArrayStringType : temp_non_optionalArrayStringType) 
 		} else {
 			return nil
 		}
 	}
} 