import Foundation


class _TestObjectTwo {



	required init() {
 			
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

        if let valuesDict = US2Mapper.mapValues(from: dictionary, forType: className!, employing: US2Transformer.sharedInstance) {

	
			self.init() 
		 
 		} else {
 			self.init()

			return nil
		}
	}
} 