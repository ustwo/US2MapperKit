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

 	required init(_optionalArrayIntType : AnyObject?,
 				  _optionalArrayStringType : AnyObject?,
 				  _optionalArrayDoubleType : AnyObject?,
 				  _optionalArrayFloatType : AnyObject?,
 				  _non_optionalArrayFloatType : AnyObject,
 				  _non_optionalArrayDoubleType : AnyObject,
 				  _non_optionalArrayIntType : AnyObject,
 				  _non_optionalArrayStringType : AnyObject) {

 			optionalArrayIntType = UTMapper.typeCast(_optionalArrayIntType)
 			optionalArrayStringType = UTMapper.typeCast(_optionalArrayStringType)
 			optionalArrayDoubleType = UTMapper.typeCast(_optionalArrayDoubleType)
 			optionalArrayFloatType = UTMapper.typeCast(_optionalArrayFloatType)
 			non_optionalArrayFloatType = UTMapper.typeCast(_non_optionalArrayFloatType)!
 			non_optionalArrayDoubleType = UTMapper.typeCast(_non_optionalArrayDoubleType)!
 			non_optionalArrayIntType = UTMapper.typeCast(_non_optionalArrayIntType)!
 			non_optionalArrayStringType = UTMapper.typeCast(_non_optionalArrayStringType)!
 			
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {
 		let dynamicTypeString = String(self.dynamicType)
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {
 			self.init(_optionalArrayIntType : valuesDict["optionalArrayIntType"]!,
 				      _optionalArrayStringType : valuesDict["optionalArrayStringType"]!,
 				      _optionalArrayDoubleType : valuesDict["optionalArrayDoubleType"]!,
 				      _optionalArrayFloatType : valuesDict["optionalArrayFloatType"]!,
 				      _non_optionalArrayFloatType : valuesDict["non_optionalArrayFloatType"]!,
 				      _non_optionalArrayDoubleType : valuesDict["non_optionalArrayDoubleType"]!,
 				      _non_optionalArrayIntType : valuesDict["non_optionalArrayIntType"]!,
 				      _non_optionalArrayStringType : valuesDict["non_optionalArrayStringType"]!) 
 		} else {
 			return nil
 		}
 	}
} 