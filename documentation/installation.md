##US2MapperKit - Installation

####Manual Install

1. Clone the [US2MapperKit](git@github.com:ustwo/US2MapperKit.git) repository 
2. Add the contents of the Source Directory to the project
3. In the Project's Root Folder create a new folder that will contain all the mapping plist files
4. In the application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following content:
	
	``` 
SCRIPT_LOCATION=$(find ${PODS_ROOT} -name modelgen-swift.py | head -n 1)
python $SCRIPT_LOCATION -v 0.1 -i $PROJECT_DIR/$PROJECT_NAME/Mappings/ -o $PROJECT_DIR/$PROJECT_NAME/Model/

	```
	
4. Move the newly created Run Script phase to the second listing right below the "Target Dependencies" task


####CocoaPods

1. Edit the project's podfile

	```
    pod 'US2MapperKit', :git => 'https://github.com/ustwo/US2MapperKit.git' 
	```
2. Install US2MapperKit by running

    ```
    pod install
    ```
3. In the Project's Root Folder create a new folder that will contain all the mapping plist files
4. Navigate to the application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following contents:

	NOTE: The script below differs for installation via Carthage

	```
SCRIPT_LOCATION=$(find ${PODS_ROOT} -name modelgen-swift.py | head -n 1)
python $SCRIPT_LOCATION -v 0.1 -i $PROJECT_DIR/$PROJECT_NAME/Mappings/ -o $PROJECT_DIR/$PROJECT_NAME/Model/
	```
5. Move the newly created Run Script phase to the second listing right below the "Target Dependencies" task


####Carthage

The installation instruction below are a for OSX and iOS, follow the extra steps documented when installing for iOS.

#####Installation

1. Create/Update the Cartfile with with the following
	
	```
#US2MapperKit
git "https://github.com/ustwo/US2MapperKit.git"
	```
2. Run `carthage update`. This will fetch dependencies into a [Carthage/Checkouts][] folder, then build each one.
3. In the application targets’ “General” settings tab, in the “Embedded Binaries” section, drag and drop each framework for use from the Carthage/Build folder on disk.
3. In the project's root folder create a new folder that will contain all the mapping plist files
4. Navigate to the application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following contents:
	
	NOTE: The script below differs for installation via Cocoapods

	```
SCRIPT_LOCATION=$(find $SRCROOT -name modelgen-swift.py | head -n 1)
python $SCRIPT_LOCATION -v 0.1 -i $PROJECT_DIR/$PROJECT_NAME/Mapping/ -o $PROJECT_DIR/$PROJECT_NAME/Model/
	```
5. Move the newly created Run Script phase to the second listing right below the "Target Dependencies" task


#####iOS Installation

1. Follow the installation instruction above. Once complete, perform the following steps
(If you have setup a carthage build task for iOS already skip to Step 5) 
2. Navigate to the targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following content:

  	```
  	/usr/local/bin/carthage copy-frameworks
  	```
  	
3. Add the paths to the frameworks you want to use under “Input Files” within the carthage build phase as follows e.g.:

	```
 	$(SRCROOT)/Carthage/Build/iOS/US2MapperKit.framework
  	
  	```


####Script Reference

The model-building script generates a model for part of a build task within the project. Below is a reference for the input parameters.

```
Parameter Description:
-v defines the version (currently 0.1)
-i defines the location where the plist mappings are stored (`$PROJECT_DIR/$PROJECT_NAME/Mappings`)
-o defines the output directory for the model objects (`$PROJECT_DIR/$PROJECT_NAME/Model`)
```
