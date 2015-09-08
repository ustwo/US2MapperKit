##Example - Tuple Transformations

As of version 0.2.0 of U2MapperKit, the ability to map tuples via the `US2TransformerProtocol` as support was added by ensuring we can return an a value of `Any` type. Let's observe a dictionary for a business object, and see how we can map a the coordinates as a tuple

**Response Dictionary**

```
{
	'business_uuid'  	 	:  9223123456754775807,
	'business_name'  		: 'UsTwo Restaurant',
	'business_longitude'  	: 40.7053319,
	'business_latitude'   	: -74.0129945,
}
```

For the purposes of the example lets create a mapper that returns a tuple. First create an enum to represent the business type for our custom Business Object.


**US2TupleCoordinateExampleTransformer Implementation**

```
let longitudeKey    = "longitude"
let latitudeKey     = "latitude"

public class US2TupleCoordinateExampleTransformer : US2TransformerProtocol {

    public func transformValues(inputValues : Dictionary<String, Any>?) -> Any? {
        if let coordinateDictionary = inputValues as? Dictionary<String, Double> {
            if let unwrappedLongitude = coordinateDictionary[longitudeKey] as? Double {
                if let unwrappedLatitude = coordinateDictionary[latitudeKey] as? Double {
                    return (longitude : unwrappedLongitude, latitude : unwrappedLatitude)
                }
            }
        }
        return nil
    }
}
```

Now that we have created a transformeer let's create mapping for our business Object

**Business.plist**
<br/>

![alt tag](/documentation/readme_assets/tuple_example.png?raw=true)
<br/>

After the creation of the mapping, perform a build **(⌘-B)**, and the changes should be reflected accordingly in the internal `_Business.swift` class.


```
import Foundation
import US2MapperKit

class _Business {
	var uuid : Double?
	var name : String?
	var coordinates : (longitude : Double, latitude : Double)?

 	required init() {...}

 	convenience init?(_ dictionary: Dictionary<String, Any>) {...}
} 

```

After calling the failable initializer, or udpateWithDictionary method with a dictioanry representation, US2MapperKit will use the custom transformer to map the tuple accordingly.

Note: The the keys defined in the property mapping correspond to the keys in the dictionary of values passed to the ` public func transformValues(inputValues : Dictionary<String, Any>?) -> Any?` method defined by the protocol. 