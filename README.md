[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# US2MapperKit

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

The idead behind UTMapper is to build against the response data upfront, and relinquish responsibility for containment within the model object that is generated for you.


In the simple example above, let's pretend we are attempting to map a Person object that is coming back form the API. The first step is to manually generage a plist representing the data that is being returned. The plist defines properties, the data types per property, and the mapping key associated with the data in the response dictionary. Once defined, a build time script will generate two model object files to represent the plist mapping. 

The first class generated in the examples is the `_Person.swift` class. It contains scripted logic, and a failable initializer which takes in a `Dictionary<String, AnyObject>` value. The underscore represents an internal object that should not be modifided by the developer as the script will regenerate it everytime the project is built, and it's only intension is to support the framework in mapping the response data.

The second class generated in the example is the `Person.swift` which inherits form the  `_Person.swift` class. It is mean for developer to append their logic, appends properties, or implements protocols accordingly. This class is only generated once, and will never be overwritten during the build task. thus updating the mapping, will not affect your logic at all.



#Setup

##Carthage

```
SCRIPT_LOCATION=$(find $SRCROOT -name modelgen-swift.py | head -n 1)
python $SCRIPT_LOCATION -x 0.1 -i $PROJECT_DIR/$PROJECT_NAME/Mapping/ -o $PROJECT_DIR/$PROJECT_NAME/Model/

```
##CocoaPods

```
SCRIPT_LOCATION=$(find ${PODS_ROOT} -name modelgen-swift.py | head -n 1)
python $SCRIPT_LOCATION -v 0.1 -i $PROJECT_DIR/$PROJECT_NAME/Mapping/ -o $PROJECT_DIR/$PROJECT_NAME/Model/

```

##Plugin


##Manual


The basic concept behind UTMapper is a three steps :

1. Clone the [UTMapper](git@github.com:ustwo/UTMapper.git) repository (We need to work this out)
2. Create a plist file for the model class (described in the followi sectios)
3. Configure build time script, and ensure it follows "Target Dependencies" task in your build ph

```
python $SCRIPT_LOCATION -i $PROJECT_DIR/$PROJECT_NAME/Mapping/ -o $PROJECT_DIR/$PROJECT_NAME/Model/

-i defines the location if you plist mappings
-o defines the output directory for the model objects

```

At Build time, the script will generate model objects based on the mappings plist, you will then need to:

1. Navigate to your output directory and drag and drop the model directory into your project 
2. Then to map dictionary values to your model all your need to do is the following

```
let testObjectInstance = TestInstanceType(dataDictionary)

```

#Examples


###Basic Example

Let's look at a basic example below with a plist definition for a Person object class.

// TODO

__Result__

Once the response is received it's as easy as the following line of code to map all the values accordingly to the `Person` model class. 

```
var newPerson = Person(dataDictionary)

```

##Future Features

* Supports mapping inheritance

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