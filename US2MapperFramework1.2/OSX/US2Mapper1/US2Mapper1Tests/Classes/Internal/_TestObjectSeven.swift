import Foundation

class _TestObjectSeven {

	var optionalArrayType : [TestObjectFour]?

	var non_optionalArrayType : [TestObjectFour]

 	required init(_non_optionalArrayType : [ TestObjectFour]) {
 			
 			non_optionalArrayType = _non_optionalArrayType
 	}


 	convenience init(_optionalArrayType : [ TestObjectFour]?,
 				  _non_optionalArrayType : [ TestObjectFour]) {
 			
 			self.init(_non_optionalArrayType : _non_optionalArrayType)

 			optionalArrayType = _optionalArrayType
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

 		let dynamicTypeString = "\(self.dynamicType)"
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = US2Mapper.parseJSONResponse(className!, data : dictionary) {

			var temp_optionalArrayType : [TestObjectFour]?

			let temp_non_optionalArrayType : [TestObjectFour]  = US2Mapper.typeCast(valuesDict["non_optionalArrayType"])!

			if let unwrapped_optionalArrayType : AnyObject = valuesDict["optionalArrayType"] as AnyObject? {
 				temp_optionalArrayType = US2Mapper.typeCast(unwrapped_optionalArrayType)
 			}
	
 			self.init(_optionalArrayType : temp_optionalArrayType,
 				      _non_optionalArrayType : temp_non_optionalArrayType) 
 		} else {
            
            self.init(
                _non_optionalArrayType : [ TestObjectFour]())
 			return nil
 		}
 	}
} 