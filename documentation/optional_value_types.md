##Example - Optional Value Types

US2MapperKit supports mapping basic data types including `String`, `Int`, `Double`, `Float` and `Bool`. Let's look at a simple example for mapping basic datatypes for a `Dictionary<String, AnyObject>` response for a basic business case

**Response Dictionary**

```
{
	'business_uuid'  	 	:  9223123456754775807,
	'business_name'  		: 'UsTwo Restaurant',
	'business_rating' 	 	:  5,
	'business_longitude'  	: 40.7053319,
	'business_latitude'   	: -74.0129945,
	'business_open'    		: 1
}
```

After receiving the data dictionary, the next step is to model the response into a class and map it accordingly. Unlike other mapping frameworks, where the developer needs to model the object first prior to mapping the response, US2MapperKit takes care of generating the model by creating a plist mapping for a given model object. Let's go ahead and create a mapping for our `Business` model object, and add it to the mapping folder configured during installation. 


**Business.plist**
<br/>

![alt tag](/readme_assets/basic data_types_business.png?raw=true)
<br/>
For each property that US2MapperKit will generate in the final model object, define a dictionary within the plist to represent that property. For each property, at minimum, we must define a **key** and a **type** entry. The **key** maps to the value of the response dictionary, and **type** defines the Swift datatype for that property.

Now that the Model Mapping is defined and within our configured mapping folder, perform a build **(⌘-B)**. Next, navigate to the configured model output folder, and add the generated files to the project. NOTE: This only has to be done once, unless the name of the Model object changes. As a developer, one should not have to add the created files again, and they should change accordingly when the build script is run. 

From this example we'll find there has been created an internal `_Business.swift` file, an external `Business.swift` class that extends from the latter, and a `US2Instantiator.swift`. Lets take a take a high-level look at the output.


**_Business.swift**
<br/>

```
import Foundation
import US2MapperKit

class _Business {

	var rating : Int?
	var uuid : Double?
	var longitude : Float?
	var latitude : Float?
	var open : Bool?
	var name : String?

 	required init() {...}

 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {...}
} 
```

The internal file is where all the magic happens. At a high level, it provides a required initializer, and a [Fail-able Initializer](https://developer.apple.com/swift/blog/?id=17) which takes in a `Dictionary<String, AnyObject>` to be parsed. In the case that the parsing fails, the fail-able initializer will return nil. In the case where all of the properties are optional, and there are missing values in the response, the fail-able initializer will return an instance with the missing values accordingly.

**Business.swift**
<br/>

```
import Foundation

class Business : _Business {
	// Add Custom Logic Here
}
```

The external file is for custom logic, and is only generated once, and will go unchanged if there is an update to the mapping. As a developer, one can add properties, methods, and implement any protocol as needed. The internal class is only there to hold reference to the values from the response dictionary is is being passed.

###Default Values
To assign a default value definition for an optional property, follow the example found in the [Default Value Definitions](/documentation/default_values.md) section of this documentation.
