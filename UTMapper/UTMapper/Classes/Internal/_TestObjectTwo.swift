import Foundation

class _TestObjectTwo {



 	required init() {
 			
 	}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

 		let dynamicTypeString = String(self.dynamicType)
 		let className = dynamicTypeString.componentsSeparatedByString(".").last

 		if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {


	
 			self.init() 
 		} else {
 			return nil
 		}
 	}
} 