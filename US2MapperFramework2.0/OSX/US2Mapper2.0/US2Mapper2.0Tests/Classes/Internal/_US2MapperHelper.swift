// US2Mapper Generated Model
// UPDATE LISCENSE HERE

import Foundation

class _US2MapperHelper {

	class func classFromString(classname : String, data : Dictionary<String, AnyObject>) -> AnyObject? {
 		switch classname {
		case "TestObjectEight":
 			return _US2MapperHelper.createTestObjectEightInstance(data)
		case "TestObjectEleven":
 			return _US2MapperHelper.createTestObjectElevenInstance(data)
		case "TestObjectFive":
 			return _US2MapperHelper.createTestObjectFiveInstance(data)
		case "TestObjectFour":
 			return _US2MapperHelper.createTestObjectFourInstance(data)
		case "TestObjectNine":
 			return _US2MapperHelper.createTestObjectNineInstance(data)
		case "TestObjectSeven":
 			return _US2MapperHelper.createTestObjectSevenInstance(data)
		case "TestObjectSix":
 			return _US2MapperHelper.createTestObjectSixInstance(data)
		case "TestObjectTen":
 			return _US2MapperHelper.createTestObjectTenInstance(data)
		case "TestObjectThree":
 			return _US2MapperHelper.createTestObjectThreeInstance(data)
		case "TestObjectTwelve":
 			return _US2MapperHelper.createTestObjectTwelveInstance(data)
		case "TestObjectTwo":
 			return _US2MapperHelper.createTestObjectTwoInstance(data)
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

 	class func transformValues(transformer : String, values : [AnyObject]) -> AnyObject? {
		switch transformer {
			case "UTCompoundValueMapper":
 				return UTCompoundValueMapper.transformValues(values)
 			default:
 			 	return nil
		}
 	}

} 