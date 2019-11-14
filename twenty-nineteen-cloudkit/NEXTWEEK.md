#  <#Title#>

/// Called for push notifications
 /// In this case, we are getting the changed record from cloudkit and then creating a new notification
 func application(_ application: UIApplication,
                  didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                  fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
   
   // Get the APS notification data
   print(userInfo)
   let aps = userInfo["aps"] as! [String: AnyObject]
   print("APS: \(aps)")
   
   let contentAvailable = aps["content-available"] as! Int
   
   if contentAvailable == 1 {
     
     // Pull data
     let cloudKitInfo = userInfo["ck"] as! [String: AnyObject]
     let recordId = cloudKitInfo["qry"]?["rid"] as! String
     let field = cloudKitInfo["qry"]?["af"] as! [String: AnyObject]
     let message = field["message"] as! String
     
     // Create notification content
     let content = UNMutableNotificationContent()
     content.title = "Joke of the Day"
     content.subtitle = "Local from Silent"
     content.body = message
     content.sound = UNNotificationSound.default()
     
     // Set up trigger
     let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,repeats: false)
     
     // Create the notification request
     let center = UNUserNotificationCenter.current()
     let identifier = recordId
     let request = UNNotificationRequest(identifier: identifier,
                                         content: content, trigger: trigger)
     center.add(request, withCompletionHandler: { (error) in
       if let error = error {
         print("Something went wrong: \(error)")
       }
     })

     completionHandler(.newData)

   } else {
     completionHandler(.noData)
   }
 }





//  func registerSubscriptionsWithIdentifier(_ identifier: String) {
//
//    let uuid: UUID = UIDevice().identifierForVendor!
//    let identifier = "\(uuid)-creation"
//
//    // Create the notification that will be delivered
//    let notificationInfo = CKNotificationInfo()
//    notificationInfo.alertBody = "A new joke was added."
//    notificationInfo.shouldBadge = true
//    notificationInfo.shouldSendContentAvailable = true
//
//    let subscription = CKQuerySubscription(recordType: "joke",
//                                           predicate: NSPredicate(value: true),
//                                           subscriptionID: identifier,
//                                           options: [.firesOnRecordCreation])
//    subscription.notificationInfo = notificationInfo
//    CKContainer.default().publicCloudDatabase.save(subscription, completionHandler: ({returnRecord, error in
//      if let err = error {
//        print("subscription failed \(err.localizedDescription)")
//      } else {
//        print("subscription set up")
//      }
//    }))
//  }




//  func registerSilentSubscriptionsWithIdentifier(_ identifier: String) {
//
//    let uuid: UUID = UIDevice().identifierForVendor!
//    let identifier = "\(uuid)-delete"
//
//    // Create the notification that will be delivered
//    let notificationInfo = CKNotificationInfo()
//    notificationInfo.shouldSendContentAvailable = true
//
//    let subscription = CKQuerySubscription(recordType: "joke",
//                                           predicate: NSPredicate(value: true),
//                                           subscriptionID: identifier,
//                                           options: [.firesOnRecordCreation])
//    subscription.notificationInfo = notificationInfo
//    CKContainer.default().publicCloudDatabase.save(subscription, completionHandler: ({returnRecord, error in
//      if let err = error {
//        print("subscription failed \(err.localizedDescription)")
//      } else {
//        print("subscription set up")
//      }
//    }))
//  }
//
