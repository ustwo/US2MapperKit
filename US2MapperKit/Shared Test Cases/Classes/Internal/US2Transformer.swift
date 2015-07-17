// US2Mapper Generated Model
// UPDATE LISCENSE HERE

import Foundation

class US2Transformer : US2GeneratorProtocol {

    static let sharedInstance : US2Transformer = US2Transformer()
   
    func newInstance(ofType classname : String, withValue data : AnyObject) -> AnyObject? {
        switch classname {
		case "TestObjectEight":
			return createTestObjectEightInstance(data as!  Dictionary<String, AnyObject>)
		case "TestObjectEleven":
			return createTestObjectElevenInstance(data as!  Dictionary<String, AnyObject>)
		case "TestObjectFive":
			return createTestObjectFiveInstance(data as!  Dictionary<String, AnyObject>)
		case "TestObjectFour":
			return createTestObjectFourInstance(data as!  Dictionary<String, AnyObject>)
		case "TestObjectNine":
			return createTestObjectNineInstance(data as!  Dictionary<String, AnyObject>)
		case "TestObjectSeven":
			return createTestObjectSevenInstance(data as!  Dictionary<String, AnyObject>)
		case "TestObjectSix":
			return createTestObjectSixInstance(data as!  Dictionary<String, AnyObject>)
		case "TestObjectTen":
			return createTestObjectTenInstance(data as!  Dictionary<String, AnyObject>)
		case "TestObjectThree":
			return createTestObjectThreeInstance(data as!  Dictionary<String, AnyObject>)
		case "TestObjectTwelve":
			return createTestObjectTwelveInstance(data as!  Dictionary<String, AnyObject>)
		case "TestObjectTwo":
			return createTestObjectTwoInstance(data as!  Dictionary<String, AnyObject>)
		default:
			return data
		}
	}
    
    func transformValues(transformer : String, values : [AnyObject]) -> AnyObject? {
        switch transformer {
        case "US2CompoundValueTransformer":
            return US2CompoundValueTransformer.transformValues(values)
        default:
            return nil
        }
    }

    func createTestObjectEightInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
		return TestObjectEight(data) 
	}

    func createTestObjectElevenInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
		return TestObjectEleven(data) 
	}

    func createTestObjectFiveInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
		return TestObjectFive(data) 
	}

    func createTestObjectFourInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
		return TestObjectFour(data) 
	}

    func createTestObjectNineInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
		return TestObjectNine(data) 
	}

    func createTestObjectSevenInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
		return TestObjectSeven(data) 
	}

    func createTestObjectSixInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
		return TestObjectSix(data) 
	}

    func createTestObjectTenInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
		return TestObjectTen(data) 
	}

    func createTestObjectThreeInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
		return TestObjectThree(data) 
	}

    func createTestObjectTwelveInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
		return TestObjectTwelve(data) 
	}

    func createTestObjectTwoInstance(data : Dictionary<String, AnyObject>) -> AnyObject? {
		return TestObjectTwo(data) 
    }
} 