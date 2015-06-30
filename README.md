# UTMapper

In the world of mapping data to our data model, the data may change at any time, and UTMapper is the simplest solution to solve this problem. As an extremely lightweight mapping framework, UTMapper will provide the flexibility for an ever changing development environment by mapping dictionaries to Swift compliant objects via simple plist or JSON configuration files.

#Features

* Flexible and lightweight
* Maps objects to `Dictionary` objects, via plist
* Supports Complex SubType mapping
* Supports Simple and Complex Type Collections
* Supports Optional and Non-Optional Properties
* Supports default values for non optional properties
* Flexible multi-value transformations
* Compound property mappings


#Basic Use

The basic concept behind UTMapper is a three steps :

1. Clone the [UTMapper](git@github.com:ustwo/UTMapper.git) repository (TBD)
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

##Model Generation


### Standard Example

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