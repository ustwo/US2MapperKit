##Example - Complex Value Types
US2MapperKit's support for mapping complete types allows for creating object types as other objects generated. Let's assume in the example below that the business listing result returns a sub-dictionary for a location, and we would like to store it as a Location type.

**Response Dictionary**

```
{
	'business_uuid'  	 :  9223123456754775807,
	'business_name'  	 : 'UsTwo Restaurant',
	'business_rating' 	 :  5,
	'business_location   :
		{
			'longitude' : 40.7053319,
			'latitude'  : -74.0129945
		},					
	'business_open'    	 : 1
}

```

First, create a model mapping for the Location object.

**Location.plist**
<br/>

![alt tag](/documentation/readme_assets/location_plist.png?raw=true)
<br/>

Once the model mapping for a location has generated a `Location` object, and it has been added to the project, update the Business object mapping by defining a location property typed as **Location**

**Business.plist**
<br/>

![alt tag](/documentation/readme_assets/business_location_example.png?raw=true)
<br/>


When parsing the data for a `Business` object, US2MapperKit will create a `Location` instance, and will assign the resulting value to the location property of the `Business` instance before returning it :)
