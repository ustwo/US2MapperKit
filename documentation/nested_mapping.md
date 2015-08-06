##Example - Nested Mapping

US2MapperKit supports nested mapping for added flexibility. When mapping against a Dictionary, **dot** notation can be used to reference values in the response. Observe the following response.

**Response Dictionary**

```
{
    "business_uuid"		: 9223123456754776000,
    "business_name"		: "UsTwoRestaurant",
    "business_ratings"	: [ 5, 4, 5, 4 ],
    "business_location" : {
        "longitude" : 40.7053319,
        "latitude"  : -74.0129945
    },
    "business_open"		: 1
}
```

Although the location in the dictionary is formatted to be handled as custom Location object, assume the need to directly assign the longitude and latitude, as properties of a Business object. 

**Business.plist**
<br/>

![alt tag](/documentation/readme_assets/nested_mapping_example.png?raw=true)
<br/>

Using the **dot** notation per the example above one can map values as needed with ease. 
