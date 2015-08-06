##Example - Defining Default Values
When there is need to fallback to a default value for optional or non-optional properties, define a default value by appending **default** to the property definition in the model mapping. In the example below, if the response dictionary does not have a value for the **open** property while mapping, it will default to false.

**Business.plist**
<br/>

![alt tag](/documentation/readme_assets/default_value_example.png?raw=true)
<br/>
