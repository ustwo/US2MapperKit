import Foundation
import US2MapperKit

class _TestObjectTwo {



	required init() {
 			
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = US2Mapper.parseJSONResponse(className!, data : dictionary) {

	
			self.init() 
		 
 		} else {
 			self.init()

			return nil
		}
	}
} 