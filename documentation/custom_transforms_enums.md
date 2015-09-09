##Example - Enums Transformations

As of version 0.2.0 of U2MapperKit, the ability to map enums via the `US2TransformerProtocol` as support was added. This ensures that we can return an a value of `Any` type. Let's look at a dictionary for a business object, and see how we can map an enum to represent the type business:

**Response Dictionary**

```
{
	'business_uuid'  	 	: 9223123456754775807,
	'business_name'  		: 'UsTwo Restaurant',
	'business_type'			: 'Lounge'
}
```

Unlike the model objects, US2MapperKit does not autogenerate enums, due to the fact they would be uncustomizable. This would prevent the developer from using the many features Swift offers with enums. For the purposes of the example, let's assume that a business_type key value parsed can be 'Lounge', 'Dinner', and 'Coffee Shop'. First, create an enum to represent the business type for our custom Business Object:

**Enum Definition**

```
enum BusinessType : Int {
    case Unknown = 0, Lounge, Dinner, CoffeeShop
}
```

Once we have defined a BusinessType enum, create a mapper that parses out the values from the response and return the BusinessType type enum value. 

**US2ExampleCoordinateTransformer Implementation**

```
let businessTypeKey    = "business_type"

public class US2ExampleBusinessTypeTransformer : US2TransformerProtocol {
    public func transformValues(inputValues : Dictionary<String, Any>?) -> Any? {
        
        if let typeValue = inputValues![businessTypeKey] as? String {
            switch typeValue {
                case "Lounge":
                    return BusinessType.Lounge
                case "Dinner":
                    return BusinessType.Dinner
                case "CoffeeShop":
                    return BusinessType.CoffeeShop
                default:
                    return BusinessType.Unknown
            }
        }
        return nil
    }
}
```

Now that we have created a transformeer let's create some mapping for our business Object:

**Business.plist**
<br/>

![alt tag](/documentation/readme_assets/enum_example_plist.png?raw=true)
<br/>

After the creation of the mapping, perform a build **(⌘-B)**. The changes should be reflected accordingly in the internal `_Business.swift` class.


```
import Foundation
import US2MapperKit

class _Business {
	var uuid : Double?
	var name : String?
	var businessType : BusinessType?

 	required init() {...}

 	convenience init?(_ dictionary: Dictionary<String, Any>) {...}
} 

```
After calling the fail-able initializer - or udpateWithDictionary method with a dictionary representation - US2MapperKit will use the custom transformer to map the enumerator accordingly.


Note: The the keys defined in the property mapping correspond to the keys in the dictionary of values passed to the ` public func transformValues(inputValues : Dictionary<String, Any>?) -> Any?` method defined by the protocol. 
