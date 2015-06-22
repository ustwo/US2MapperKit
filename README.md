# UTMapper

In the world of mapping data to our data model, the data may change at any time, and UTMapper is the simplest solution to solve this problem. As an extremely lightweight mapping framework, UTMapper will provide the flexibility for an ever changing development environment by mapping dictionaries to Swift compliant objects via simple plist or JSON configuration files.

##Setup

###Cloning Repository For Development

1. Clone the [UTMapper](git@github.com:ustwo/UTMapper.git) repository

###CocoaPods Repository

Will need to create a podspec later for easy integration

#Planned Features

* Flexible and lightweight
* Maps objects to `Dictionary` objects, via plist / JSON configuration
* Supports default values for non optional properties
* Supports mapping inheritance
* Flexible multi-value transformations
* Compound property mappings


#Basic Use

The basic concept behind UTMapper is a three steps :

1. Create a plist/JSON file for the model class
2. Configured Build Time Task
3. At Build time, the script will generate model objects based on the mappings plist/json file.


## Team

* Development: [Anton Doudarev](mailto:anton@ustwo.com), [Matt Isaacs](mailto:matt@ustwo.com)