//
//  AppDelegate.swift
//  evernote
//
//  Created by 梁树元 on 10/12/15.
//  Copyright © 2015 com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        sleep(1)
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = CollectionViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

