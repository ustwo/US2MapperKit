[![Cocoapods Compatible](https://img.shields.io/badge/pod-v0.1.0-blue.svg)](https://github.com/ustwo/US2MapperKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/platform-ios%20%7C%20osx-lightgrey.svg)](https://github.com/ustwo/US2MapperKit)
[![License](https://img.shields.io/badge/license-MIT-343434.svg)](https://github.com/ustwo/US2MapperKit)
#US2MapperKit
![alt tag](/documentation/readme_assets/mapperkit_header.png?raw=true)

Inspired by [CSMapper](https://github.com/marcammann/CSMapper) and [Mogenerator](https://github.com/rentzsch/mogenerator), US2MapperKit is an an extremely lightweight mapping framework designed specifically for Swift 1.2, and Swift 2.0.

Unlike previous frameworks, where an object model is manually created by the developer then retrofitted with a mapping framework at a later point, US2MapperKit takes a mapping-first approach. By mapping against dictionary data up front, US2MapperKit generates the model objects based on the mapping, and allows for the extensibility inspired by the [Protocol-Oriented Programming](https://developer.apple.com/videos/wwdc/2015/?id=408) talk at WWDC.

##Core Concept

![alt tag](/documentation/readme_assets/basic_concept_image.png?raw=true)

The simple example above demonstrates the inner workings of the US2MapperKit. In this example we will attemp to map a Person object returned in the form a dictionary. The first step is to manually generate a plist representing the data that is being returned. This plist defines properties, data types, the mapping keys associated with the response dictionary, and any transformation that needs to be applied. Once defined, a build-time script will generate two model object files representing the model mapping.

The first class generated in the diagram represents the internal `_Person.swift` class, which contains script-generated property definitions, along two initializers, one required, and one fail-able. The generated fail-able initializer takes in a `Dictionary<String, AnyObject>` input value which is parsed to the model. The internal files purpose is to support the framework by mapping the response data and should not be modified by the developer since the script will regenerate it every time the project is built.

The second class generated is the `Person.swift` which inherits from the internal `_Person.swift` class. This provides a means for developer to append any custom logic, properties, or implementations of protocols as needed during the development process. This class is only generated once, and will never be overwritten during the build task. Thus updating the model mapping will not affect any logic defined in the external class.

##Features

* Auto generation of model objects via .plists files
* Optional & Non-Optional support for:
	* String
	* Int
	* Double
	* Float
	* Bool
* Collections Support for:
	* Array\<AnyObject\>
	* Dictionary\<String, AnyObject\>
* Complex Type Support (stand alone, and in collections)
* Default Value Definitions
* Mapping Nested Values
* Custom Transformations

##Basic Use

Once configured per [Installation](/documentation/installation.md) instructions:

1. Create a plist model mapping and place it in the mapping folder defined during installation.
2. Build the target, navigate to the output directory defined during the installation process, and add the generated files to the project.
3. Map the data to an instance, call the fail-able initializer generated by US2MapperKit with the `Dictionary<String, AnyObject>` data to parse.

	```
let newInstance = TestModelObject(dataDictionary)
	```

####Examples 

Below is a list of examples for the supported features by US2MapperKit. Each provides an overall view on how to setup the model mapping file, and short examples of the outputs generated by pre-packaged script within the framework.

* [Optional Types](/documentation/optional_value_types.md)
* [Non-Optional Types](/documentation/non_optional_value_types.md) 
* [Collection Types](/documentation/collection_types.md)
* [Complex Types](/documentation/complex_value_types.md)
* [Default Value Definitions](/documentation/default_values.md)
* [Mapping Against Nested Values](/documentation/nested_mapping.md)
* [Custom Transformations](/documentation/custom_transforms.md)

##Troubleshooting

- [Enabling Debug Mode](/documentation/enable_debug_mode.md)
- [Swift 1.2 / 2.0 Compatibility](/documentation/compatibility_issues.md)

##Future Enahancements

* Mapping Inheritance (Configuration to Inherit from NSManagedObject / Realm Object)
* Xcode Plug-in

## License

     The MIT License (MIT)  
      
     Copyright (c) 2015 ustwo studio inc (www.ustwo.com)  
      
     Permission is hereby granted, free of charge, to any person obtaining a copy
     of this software and associated documentation files (the "Software"), to deal
     in the Software without restriction, including without limitation the rights
     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
     copies of the Software, and to permit persons to whom the Software is
     furnished to do so, subject to the following conditions:  
     
     The above copyright notice and this permission notice shall be included in all
     copies or substantial portions of the Software.  
      
     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
     SOFTWARE.  
