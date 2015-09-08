#US2MapperKit ChangeLog

###Version 0.1.0

Initial Release

###Version 0.2.0

#####Important Upgrade Notes

Please note the following API/project changes have been made:

* New method introduced to allow the developer to update instance values with a new a dictionary. A new method is generated as part of the internal model object `func updateWithDictionary(dictionary: Dictionary<String, AnyObject>)`. You can now update values on an existing instance.

* The `US2TransformerProtocol` has been updated with support returning objects of `Any` type, which includes support for Struct, Enums, Closures, and Tuples.

***Version 0.1.0***

```
public protocol US2TransformerProtocol {
    func transformValues(inputValues : Dictionary<String, AnyObject>?) -> AnyObject?
}

``` 
***Version 0.2.0***

```
public protocol US2TransformerProtocol {
    func transformValues(inputValues : Dictionary<String, Any>?) -> Any?
}

``` 
Ensure to update your custom transformers accordingly for continued support of custom transformers.
	

