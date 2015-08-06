##US2MapperKit - Compatibility Issues

####Carthage Issues: Module Created by Older Version of The Compiler

This framework was designed to run with Swift 1.2 and 2.0. When installing using Carthage, the environment needs to be pointed to the correct instance of Xcode for the module to build correctly.

If using the **Current SDK 6.0+** (Swift 1.2), run the following command in the terminal:

```
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

If using the **Beta SDK 7.0+** (Swift 2.0), run the following command in the terminal:
	
```
sudo xcode-select -s /Applications/Xcode-beta.app/Contents/Developer
```
