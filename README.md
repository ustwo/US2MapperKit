# UTMapper

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
* Native and Complex DataTypes mapping supported for Arrays and Dictionaries
* Optional and Non-Optional Property Types
	* Supports User Defined Default Values for either
* Flexible Multi-Value Transformations
* Compound Property Mappings


#Basic Concept


#Setup

The basic concept behind UTMapper is a three steps :

1. Clone the [UTMapper](git@github.com:ustwo/UTMapper.git) repository (We need to work this out)
2. Create a plist file for the model class (described in the followi sectios)
3. Configure build time script, and ensure it follows "Target Dependencies" task in your build ph

```
python $PROJECT_DIR/$PROJECT_NAME/modelgen.py -i $PROJECT_DIR/UTMapper/Mapping/ -o $PROJECT_DIR/$PROJECT_NAME/Classes/

-i defines the location if you plist mappings
-o defines the output directory for the model objects

```

At Build time, the script will generate model objects based on the mappings plist, you will then need to :

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

## Team

* Development: [Anton Doudarev](mailto:anton@ustwo.com), [Matt Isaacs](mailto:matt@ustwo.com)