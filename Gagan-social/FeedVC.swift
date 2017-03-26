//
//  FeedVC.swift
//  Gagan-social
//
//  Created by Gagandeep Singh on 3/26/17.
//  Copyright © 2017 Gagandeep Singh. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    

    
    @IBAction func signOutBtnTapped(_ sender: Any) {
        
       let keyChainResult = KeychainWrapper.defaultKeychainWrapper.removeObject(forKey: KEY_UID)
        print("Gagan: ID removed from  keychain \(keyChainResult)")
         try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
        
    }

}
