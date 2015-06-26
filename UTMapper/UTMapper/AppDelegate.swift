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
        let subtypeDictionary = ["non_optional_int" : 50, "non_optional_string" : "TestString", "non_optional_double" : 70.0, "non_optional_float" : 80.0, "non_optional_bool" : false]
        let dictionaryBoolValue = ["optional_subtype" : subtypeDictionary]
        
        let testObjectInstance = TestObjectFive(dictionaryBoolValue)
        return true
    }
}

