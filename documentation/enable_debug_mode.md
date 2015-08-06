##Example - Enable Debug Mode

It is not always feasible to know why a a fail-able initializer may have failed to parse a response. USMapperKit provides the ability to use a build-time flag to print out failures to the console.

To enable Debug mode, add the  **-DUS2MAPPER_DEBUG** flag to the **Other Swift Flags** in your build settings.

<br>
![alt tag](/readme_assets/debug_flag.png?raw=true)
<br/>

The resulting output in the console will resemble the following:

```
Business instance could not be parsed, missing values for the following non-optional properties:
- business_uuid

Response:
[response: {
    "business_name"		: "UsTwoRestaurant";
    "business_ratings"	: [ 5, 4, 5, 4 ];
    "business_open"		: 1;
}]

```
