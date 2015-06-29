//
//  AppDelegate.swift
//  UTMapper
//
//  Created by Anton on 6/22/15.
//  Copyright © 2015 UTMapper. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.mainScreen().bounds)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window!.rootViewController = UIViewController()
        window!.makeKeyAndVisible()
        /*
        // TestObjectSEven has an array of TestObjectFour(s)
        let object1Dictionary = ["non_optional_int" : 50, "non_optional_string"  : "TestString1", "non_optional_double" : 60.0, "non_optional_float" : 70.0, "non_optional_bool" : true]
        
        let dataDictionary = ["optional_sub_object_dictionary" : object1Dictionary]
        
        let testObjectInstance = TestObjectEight(dataDictionary)
    */
        return true
    }
}

