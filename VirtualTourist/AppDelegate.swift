//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by manar AL-Towaim on 26/06/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DataController.shard.load()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       saveData()
    }

    func applicationWillTerminate(_ application: UIApplication) {
      saveData()
    }
    
    func saveData () {
        do {
            try DataController.shard.viewContaxt.save()
        } catch {
            print ("error! problem in saving data")
        }
    }


}

