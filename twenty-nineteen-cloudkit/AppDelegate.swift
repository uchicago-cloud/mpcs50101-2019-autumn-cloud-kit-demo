//
//  AppDelegate.swift
//  twenty-nineteen-cloudkit
//
//  Created by T. Andrew Binkowski on 11/4/19.
//  Copyright © 2019 T. Andrew Binkowski. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // Register a subscription for this device
    CloudKitManager.sharedInstance.registerJokeOfTheDaySubscriptions()
    
    // Request authorization for notifications
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        print("D'oh: \(error.localizedDescription)")
      } else {
        DispatchQueue.main.async {
          application.registerForRemoteNotifications()
        }
      }
    }
    
    // Set delegate to receive notifications in all cases
    UNUserNotificationCenter.current().delegate = self
    
    
    // Parse the launch notification so that we can get the payload
    if let notification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
      let aps = notification["aps"] as! [String: AnyObject]
      print("APS: \(aps)")
    }
    
    
    return true
  }

  
  //
  // MARK: - Notifications
  //
  
  /// Call when application is open and a notification is received
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound, .badge])
  }
  
  /// Called for push notifications
  /// In this case, we are getting the changed record from cloudkit and then creating a new notification
  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
    // Get the APS notification data
    print(userInfo)
    let aps = userInfo["aps"] as! [String: AnyObject]
    
    // Do Something with the content available data
    let contentAvailable = aps["content-available"] as! Int
    if contentAvailable == 1 {
      //print("APS: \(aps)")
      //let cloudKitInfo = userInfo["ck"] as! [String: AnyObject]
      //let recordId = cloudKitInfo["qry"]?["rid"] as! String
      //let field = cloudKitInfo["qry"]?["af"] as! [String: AnyObject]
      //let message = field["message"] as! String
      completionHandler(.newData)

    } else {
      completionHandler(.noData)
    }
  }
  
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  
  
}

