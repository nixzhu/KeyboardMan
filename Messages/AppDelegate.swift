//
//  AppDelegate.swift
//  Messages
//
//  Created by NIX on 15/7/25.
//  Copyright (c) 2015年 nixWork. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        print("application didFinishLaunchingWithOptions")

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

        print("application applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

        print("application applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

        print("application applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

        print("application applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {

        print("application applicationWillTerminate")
    }
}

