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
        return true
    }
}

