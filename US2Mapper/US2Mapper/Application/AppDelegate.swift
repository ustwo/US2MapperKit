//
//  AppDelegate.swift
//  US2Mapper
//
//  Created by Anton on 6/22/15.
//  Copyright © 2015 US2Mapper. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.mainScreen().bounds)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window!.rootViewController = UIViewController()
        window!.makeKeyAndVisible()
   
        return true
    }
}

