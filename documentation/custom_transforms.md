##Example - Custom Transformations

To perform transformations of a single or multiple values, US2MapperKit provides the ability to map multiple values from a dictionary response, and process them using the `US2TransformerProtocol`. Currently all transformed output properties must be optional, and the script will error out with a description in the build log.

```
public protocol US2TransformerProtocol {
    func transformValues(inputValues : Dictionary<String, Any>?) -> Any?
}
```

Transformations are great approach, especially for Date transforms by reusing the NSDateFormatter - and possibly creating attributed strings by reusing NSMutableParagraphStyles. Let's observe a response with a simple user object.

**Response Dictionary**

```
{
    "user_id"		: 9223123456754776000,
    "first_name"	: "John",
    "last_name"		: "Doe"
}
```

Assuming the need to store the user's full name as a single property, the transformer implementation below takes in a user's first name and last name as a parsed dictionary of strings keyed according to the property mapping defined and transforms them into a single full name property value before being returned and assigned.


**US2TransformerProtocol Implementation**

```
let firstNameKey    = "first_name"
let lastNameKey     = "last_name"

public class US2FullNameValueTransformer : US2TransformerProtocol {
    
    public func transformValues(inputValues : Dictionary<String, Any>?) -> Any? {
        var fullNameString : String = ""
        
        if let componentDictionary = inputValues as? Dictionary<String, String> {
           
            if let firstName = componentDictionary[firstNameKey] {
                fullNameString += firstName
            }
            
            if fullNameString.isEmpty == false { fullNameString += " " }
            
            if let lastName = componentDictionary[lastNameKey] {
                fullNameString += lastName
            }
        }
        
        if fullNameString.isEmpty { return nil }
       
        return fullNameString
    }
}
```

To implement the transformer as part of the model mapping, observe how the **key** property in the mapping has become an array and takes in multiple values to transform into a fullName property. To use the custom transformer created above, add the **transformer** key to the property mapping defining which trasnformer class to use.  

**User.plist**
<br/>

![alt tag](/documentation/readme_assets/transformer_fullname_example.png?raw=true)
<br/>

Note: The the keys defined in the property mapping correspond to the keys in the dictionary of values passed to the ` public func transformValues(inputValues : Dictionary<String, Any>?) -> Any?` method defined by the protocol. 


###Compound Value Transformer

Currently the only packaged trasnformer shipped with the framework is  the `US2CompoundValueTransformer` which takes in a dictionary of values per `US2TransformerProtocol`, and creates a compound output value from the values passed into it.

There is potential for more transformers to be added in future releases.
