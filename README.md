[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

#US2MapperKit

In the world of mapping data to our data model, the data may change at any time, and UTMapper is the simplest solution to solve this problem. Inspired by [CSMapper](https://github.com/marcammann/CSMapper) and [Mogenerator](https://github.com/rentzsch/mogenerator), UTMapper is an an extremely lightweight mapping framework designed specifically to take advantage of Swift 2.0.

Unlike the past, where an Object Model is first created, followed by a mapping framework being retrofitted against the model, UTMapper takes a mapping first approach, where it generates your model, and allows extensibility inspiration by the [Protocol-Oriented Programming](https://developer.apple.com/videos/wwdc/2015/?id=408) talk at WWDC.

#Features

* Extremely Flexible and Lightweight
* Generates Model Objects Mapped using plists
* Supports Native Datatypes including:
	* String
	* Int
	* Double
	* Float
	* Bool
	* Arrays
	* Dictionaries
	* Complex Datatypes (i.e Any Generated Model Objects)
* Arrays and Dictionaries support for Native and Complex DataTypes
* Optional and Non-Optional Property Types
	* Supports User Defined Default Values for either
* Multi-Value Transformations
* Compound Property Mapping

#Basic Concept

![alt tag](/readme_assets/basic_concept_image.png?raw=true)

The idead behind UTMapper is to build against the response data right from the start, and relinquish responsibility for containment of your data within the model object that is generated for you.

In the simple example above, let's pretend we are attempting to map a Person object returned from the API. The first step is to manually generage a plist representing the data that is being returned. The plist defines properties, the data types, and the mapping keys associated to the data in the response dictionary. Once defined, a build time script will generate two model object files to represent the plist mapping. 

The first class generated in the examples is the `_Person.swift` class. It contains scripted logic, and a failable initializer which takes in a `Dictionary<String, AnyObject>` value. The underscore represents an internal object that should not be modifided by the developer since the script will regenerate it everytime the project is built, and all changes will disappear. The internal files only intent is to support the framework in mapping the response data.

The second class generated in the example is the `Person.swift` which inherits from the  `_Person.swift` class. This allows the mean for developer to append custom logic logic, custom properties, or implementations of protocols accordingly. This class is only generated once, and will never be overwritten during the build task. Thus updating the mapping, will not affect your logic within the externally generated file.


##Basic Use

Once configured per [Installation]() instructions:

1. Create a plist file for the model class, and add it to your mapping folder defined during installation.
2. Build your target, and using Finder navigate to the output directory defined during the installation process. Note (You only have to do this once for any newly created plist)
3. To map dictionary values to your model object, all your need to do is the following

	```
let testObjectInstance = TestInstanceType(dataDictionary)
	```

##Mapping Examples

TODO

#Installation

##Manual

1. Clone the [US2MapperKit](git@github.com:ustwo/US2MapperKit.git) repository 
2. Add the contents of the Source Directory to your project
3. In your Project's Root Folder create a new folder that will contain all your mapping plist files
4. In your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following contents:
	
	``` 
SCRIPT_LOCATION=$(find ${PODS_ROOT} -name modelgen-swift.py | head -n 1)
python $SCRIPT_LOCATION -v 0.1 -i $PROJECT_DIR/$PROJECT_NAME/Mappings/ -o $PROJECT_DIR/$PROJECT_NAME/Model/

	Parameter Description:
	-v defines the version (currently 0.1)
	-i defines the location where your plist mappings are stored (`$PROJECT_DIR/$PROJECT_NAME/Mappings`)
	-o defines the output directory for the model objects (`$PROJECT_DIR/$PROJECT_NAME/Model`)

	```
	
4. Move the newly created Run Script phaase to the second listing right below the "Target Dependencies" task


##CocoaPods
1. Edit your podfile

	```
    pod 'US2MapperKit', :git => 'https://github.com/ustwo/US2MapperKit.git' 
	```
2. Now you can install US2MapperKit
    ```
    pod install
    ```
3. In your Project's Root Folder create a new folder that will contain all your mapping plist files
4. Navigate to your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following contents:

	NOTE: The script below differs for installation via Carthage

	```
SCRIPT_LOCATION=$(find ${PODS_ROOT} -name modelgen-swift.py | head -n 1)
python $SCRIPT_LOCATION -v 0.1 -i $PROJECT_DIR/$PROJECT_NAME/Mappings/ -o $PROJECT_DIR/$PROJECT_NAME/Model/

	Parameter Description:
	-v defines the version (currently 0.1)
	-i defines the location where your plist mappings are stored (`$PROJECT_DIR/$PROJECT_NAME/Mappings`)
	-o defines the output directory for the model objects (`$PROJECT_DIR/$PROJECT_NAME/Model`)

	```
5. Move the newly created Run Script phaase to the second listing right below the "Target Dependencies" task


##Carthage OSX

1. Create/Update your a Cartfile that lists the frameworks with the following
	
	```
#US2MapperKit
git "https://github.com/ustwo/US2MapperKit.git"
	
	```
2. Run `carthage update`. This will fetch dependencies into a [Carthage/Checkouts][] folder, then build each one.
3. In your application targets’ “General” settings tab, in the “Embedded Binaries” section, drag and drop each framework you want to use from the Carthage/Build folder on disk.
3. In your Project's Root Folder create a new folder that will contain all your mapping plist files
4. Navigate to your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following contents:
	
	NOTE: The script below differs for installation via Cocoapods

	```
SCRIPT_LOCATION=$(find $SRCROOT -name modelgen-swift.py | head -n 1)
python $SCRIPT_LOCATION -v 0.1 -i $PROJECT_DIR/$PROJECT_NAME/Mapping/ -o $PROJECT_DIR/$PROJECT_NAME/Model/

	Parameter Description:
	-v defines the version (currently 0.1)
	-i defines the location where your plist mappings are stored (`$PROJECT_DIR/$PROJECT_NAME/Mapping`)
	-o defines the output directory for the model objects (`$PROJECT_DIR/$PROJECT_NAME/Model`)
	```
5. Move the newly created Run Script phaase to the second listing right below the "Target Dependencies" task


##Carthage iOS

1. Create/Update your a Cartfile that lists the frameworks with the following
	
	```
#US2MapperKit
git "https://github.com/ustwo/US2MapperKit.git"
	
	```
2.  Run `carthage update`. This will fetch dependencies into a [Carthage/Checkouts][] folder, then build each one.
3.   In your application targets’ “General” settings tab, in the “Linked Frameworks and Libraries” section, drag and drop each framework you want to use from the [Carthage/Build][] folder on disk.
4.   If you have setup a carthage build task for iOS already skip to Step 5, navigate to your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following contents:

  	```
  	/usr/local/bin/carthage copy-frameworks
  	```
  	
4. Add the paths to the frameworks you want to use under “Input Files” within your carthage build phase as follows e.g.:

	```
 	$(SRCROOT)/Carthage/Build/iOS/US2MapperKit.framework
  	
  	```
  	
4. In your Project's Root Folder create a new folder that will contain all your mapping plist files
5. Navigate to your targets’ “Build Phases” settings tab, add another task by clicking the “+” icon, and choose “New Run Script Phase”. Create a Run Script with the following contents:

	NOTE: The script below differs for installation via Cocoapods

	```
SCRIPT_LOCATION=$(find $SRCROOT -name modelgen-swift.py | head -n 1)
python $SCRIPT_LOCATION -v 0.1 -i $PROJECT_DIR/$PROJECT_NAME/Mapping/ -o $PROJECT_DIR/$PROJECT_NAME/Model/

	```
6. Move the newly created Run Script phase to the second listing right below the "Target Dependencies" task


##Future Features


* Support Mapping Inheritance
* Support Sets
* Suport Structs
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


## Team

* Development: [Anton Doudarev](mailto:anton@ustwo.com), [Matt Isaacs](mailto:matt@ustwo.com)