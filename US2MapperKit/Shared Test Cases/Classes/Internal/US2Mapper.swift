// US2Mapper Generated Model
// UPDATE LISCENSE HERE

import Foundation
import US2MapperKit

class US2Mapper : _US2Mapper {

	override class func classFromString(classname : String, data : Dictionary<String, AnyObject>) -> AnyObject? {
 		switch classname {
		case "TestObjectEight":
 			return US2Mapper.createTestObjectEightInstance(data)
		case "TestObjectEleven":
 			return US2Mapper.createTestObjectElevenInstance(data)
		case "TestObjectFive":
 			return US2Mapper.createTestObjectFiveInstance(data)
		case "TestObjectFour":
 			return US2Mapper.createTestObjectFourInstance(data)
		case "TestObjectNine":
 			return US2Mapper.createTestObjectNineInstance(data)
		case "TestObjectSeven":
 			return US2Mapper.createTestObjectSevenInstance(data)
		case "TestObjectSix":
 			return US2Mapper.createTestObjectSixInstance(data)
		case "TestObjectTen":
 			return US2Mapper.createTestObjectTenInstance(data)
		case "TestObjectThree":
 			return US2Mapper.createTestObjectThreeInstance(data)
		case "TestObjectTwelve":
 			return US2Mapper.createTestObjectTwelveInstance(data)
		case "TestObjectTwo":
 			return US2Mapper.createTestObjectTwoInstance(data)
		default:
 			return nil
 		}
 	}

	class func createTestObjectEightInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
 			return TestObjectEight(data) 
 	}

 	class func createTestObjectElevenInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
 			return TestObjectEleven(data) 
 	}

 	class func createTestObjectFiveInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
 			return TestObjectFive(data) 
 	}

 	class func createTestObjectFourInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
 			return TestObjectFour(data) 
 	}

 	class func createTestObjectNineInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
 			return TestObjectNine(data) 
 	}

 	class func createTestObjectSevenInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
 			return TestObjectSeven(data) 
 	}

 	class func createTestObjectSixInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
 			return TestObjectSix(data) 
 	}

 	class func createTestObjectTenInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
 			return TestObjectTen(data) 
 	}

 	class func createTestObjectThreeInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
 			return TestObjectThree(data) 
 	}

 	class func createTestObjectTwelveInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
 			return TestObjectTwelve(data) 
 	}

 	class func createTestObjectTwoInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
 			return TestObjectTwo(data) 
 	}

 	override class func transformValues(transformer : String, values : [AnyObject]) -> AnyObject? {
		switch transformer {
			case "US2CompoundValueMapper":
 				return US2CompoundValueMapper.transformValues(values)
 			default:
 			 	return nil
		}
 	}

} 