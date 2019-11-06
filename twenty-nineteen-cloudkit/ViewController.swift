//
//  ViewController.swift
//  twenty-nineteen-cloudkit
//
//  Created by T. Andrew Binkowski on 11/4/19.
//  Copyright © 2019 T. Andrew Binkowski. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  // The current user's record
  var userRecordID: CKRecord.ID?
  
  var userName: String = "" {
    didSet {
      textView.text = self.userName
    }
  }
  
  
  // MARK: - Outlets and Actions
  @IBOutlet weak var textView: UITextView!
  
  @IBAction func tapAdd(_ sender: UIButton) {
    CloudKitManager.sharedInstance.addJoke("Why did the student throw a clock out the window?",
                                           response:"She wanted to see time fly.")
    
  }
  @IBAction func tapQueryAll(_ sender: UIButton) {
    //CloudKitManager.sharedInstance.getJokes()
    
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: "joke", predicate: predicate)
    CloudKitManager.sharedInstance.getJokesWithOperation(query: query, cursor: nil)
  }
  
  
  @IBAction func tapQueryUser(_ sender: UIButton) {
    if let userRecordID = self.userRecordID {
      CloudKitManager.sharedInstance.getJokesByCurrentUser(userRecordID)
    } else {
      print("No jokes...")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Get the user
    CloudKitManager.sharedInstance.getUserRecordId { (recordID, error) in
      if let userID = recordID?.recordName {
        print("iCloudID: \(userID)")
        self.userRecordID = recordID
      } else {
        print("iCloudID: nil")
      }
    }
    
    CloudKitManager.sharedInstance.getUserIdentity { (record, error) in
      print(record?.description)
    }
    
    //    CloudKitManager.sharedInstance.getUserRecordId { (recordID, error) in
    //      if let userID = recordID?.recordName {
    //        print("iCloudID: \(userID)")
    //      } else {
    //        print("iCloudID: nil")
    //      }
    //    }
    //
    //    CloudKitManager.sharedInstance.getUserIdentity { (record, error) in
    //      print(record)
    //      self.userName = record!.description
    //    }
    
  }
  
  
}

