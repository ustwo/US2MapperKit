// US2MapperKit Generated Model
// UPDATE LISCENSE HERE

import Foundation

enum US2MapperClassEnum: String {
	case _TestObjectEight 	= "TestObjectEight"
	case _TestObjectEleven 	= "TestObjectEleven"
	case _TestObjectFive 	= "TestObjectFive"
	case _TestObjectFour 	= "TestObjectFour"
	case _TestObjectNine 	= "TestObjectNine"
	case _TestObjectSeven 	= "TestObjectSeven"
	case _TestObjectSix 	= "TestObjectSix"
	case _TestObjectTen 	= "TestObjectTen"
	case _TestObjectThree 	= "TestObjectThree"
	case _TestObjectTwelve 	= "TestObjectTwelve"
	case _TestObjectTwo 	= "TestObjectTwo"
	case _None				= "None"

	func createObject(data : Dictionary<String, AnyObject>) -> AnyObject? {
		switch self {
		case ._TestObjectEight:
			return TestObjectEight(data)
		case ._TestObjectEleven:
			return TestObjectEleven(data)
		case ._TestObjectFive:
			return TestObjectFive(data)
		case ._TestObjectFour:
			return TestObjectFour(data)
		case ._TestObjectNine:
			return TestObjectNine(data)
		case ._TestObjectSeven:
			return TestObjectSeven(data)
		case ._TestObjectSix:
			return TestObjectSix(data)
		case ._TestObjectTen:
			return TestObjectTen(data)
		case ._TestObjectThree:
			return TestObjectThree(data)
		case ._TestObjectTwelve:
			return TestObjectTwelve(data)
		case ._TestObjectTwo:
			return TestObjectTwo(data)
		case ._None:
			return nil
		}
	}
}

enum US2TransformerEnum: String {
	case _US2CompoundValueTransformer = "US2CompoundValueTransformer"
	case _None = "None"

	func transformer() -> US2TransformerProtocol? {
		switch self {
		case ._US2CompoundValueTransformer:
			return US2CompoundValueTransformer()

		case ._None:
			return nil		}
	} 
}

class US2Instantiator : US2InstantiatorProtocol {

	static let sharedInstance : US2Instantiator = US2Instantiator()

	func newInstance(ofType classname : String, withValue data : Dictionary<String, AnyObject>) -> AnyObject? {
		return US2MapperClassEnum(rawValue: classname)?.createObject(data)
	}

	func transformerFromString(classString: String) -> US2TransformerProtocol? {
		return US2TransformerEnum(rawValue: classString)!.transformer()
	}
}