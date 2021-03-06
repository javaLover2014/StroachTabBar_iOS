//
//  AppDelegate.swift
//  Example
//
//  Created by Lukas Trümper on 29.09.17.
//  Copyright © 2017 Lukas Trümper. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let tabBarController = window?.rootViewController as? StroachTabBarController {
            let itemA = StroachTabBarItem(image: UIImage(named: "home")!);
            let itemB = StroachTabBarItem(image: UIImage(named: "map")!);
            let itemC = StroachTabBarItem(image: UIImage(named: "user")!);
            tabBarController.stroachTabBar.items = [itemA, itemB, itemC];
            
            tabBarController.stroachTabBar.backgroundColor = UIColor(red: 252.0/255.0, green: 252.0/255.0, blue: 252.0/255.0, alpha: 1.0);
            tabBarController.stroachTabBar.selectedColor = UIColor(red: 252.0/255.0, green: 76.0/255.0, blue: 2.0/255.0, alpha: 1.0);
            tabBarController.stroachTabBar.unselectedColor = UIColor(red: 41.0/255.0, green: 48.0/255.0, blue: 58.0/255.0, alpha: 1.0);
        
            tabBarController.stroachTabBar.borderColor = UIColor(red: 41.0/255.0, green: 48.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor;
            tabBarController.stroachTabBar.borderWidth = 0.5;
            
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

