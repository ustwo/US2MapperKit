##Example - Non Optional Value Types
If a property is non-optional, such as the **uuid** property for the Business model object, a **nonoptional** can be added to the property definition in the model mapping. Let's take a quick peak at the `Business.plist`.

**Business.plist**
<br/>

![alt tag](/readme_assets/non_optional_business.png?raw=true)
<br/>

Once the model mapping has been updated, perform a build **(⌘-B)**, and the changes should be reflected accordingly in the internal `_Business.swift` class.

**Business.swift**
<br/>

```
import Foundation
import US2MapperKit

class _Business {

	var rating : Int?
	var longitude : Float?
	var latitude : Float?
	var open : Bool?
	var name : String?

	var uuid : Double

 	required init(_uuid : Double) {...}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {...}
} 
```

Once the script has updated the internal file, the uuid property should be a non-optional property, and been added to the required initializer as an input parameter. In the case that the response dictionary does not contain a value for the uuid, the fail-able initializer will return nil.

###Default Values
To assign a default value definition for a non-optional property, follow the example found in the [Defining Default Values](/documentation/default_values.md) section of the documentation
