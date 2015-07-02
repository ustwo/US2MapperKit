import Foundation

class _UTMapperClassInstantiator {

	class func classFromString(classname : String, data : Dictionary<String, AnyObject>) -> AnyObject? {
 		switch classname {
		case "TestObjectFive":
 			return _UTMapperClassInstantiator.createTestObjectFiveInstance(data)
		case "TestObjectFour":
 			return _UTMapperClassInstantiator.createTestObjectFourInstance(data)
		case "TestObjectSix":
 			return _UTMapperClassInstantiator.createTestObjectSixInstance(data)
		case "TestObjectThree":
 			return _UTMapperClassInstantiator.createTestObjectThreeInstance(data)
		default:
 			return nil
 		}
 	}

	class func createTestObjectFiveInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
 			return TestObjectFive(data) 
 	}

 	class func createTestObjectFourInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
 			return TestObjectFour(data) 
 	}

 	class func createTestObjectSixInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
 			return TestObjectSix(data) 
 	}

 	class func createTestObjectThreeInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
 			return TestObjectThree(data) 
 	}

 
} 