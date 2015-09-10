#US2MapperKit ChangeLog

###Version 0.2.0

#####Important Upgrade Notes

Please note the following API/project changes have been made:

* New method introduced to allow the developer to update instance values with a new a dictionary. A new method is generated as part of the internal model object `func updateWithDictionary(dictionary: Dictionary<String, AnyObject>)`. You can now update values on an existing instance.
	* Fixes [Issue #21](https://github.com/ustwo/US2MapperKit/issues/21)
* The `US2TransformerProtocol` has been updated with support for returning objects of `Any` type, which includes support for _Struct_, _Enums_, _Closures_, and _Tuples_.
	* Fixes [Issue #23](https://github.com/ustwo/US2MapperKit/issues/23)
	
#####Important Upgrade Notes

Be sure to update your custom transformers accordingly for continued support of custom transformers.

```
Version 0.1.0 US2TransformerProtocol Definition 

public protocol US2TransformerProtocol {
    func transformValues(inputValues : Dictionary<String, AnyObject>?) -> AnyObject?
}


Version 0.2.0 US2TransformerProtocol Definition 

public protocol US2TransformerProtocol {
    func transformValues(inputValues : Dictionary<String, Any>?) -> Any?
}

``` 

###Version 0.1.0

Initial Release

