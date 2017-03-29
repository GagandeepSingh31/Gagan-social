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

class FeedVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView : UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //Go to the firebase database posts.
        DataService.ds.REF_POSTS.observe(.value, with : { (snapshot) in
            print(snapshot.value)
            })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
   
    

    
    @IBAction func signOutBtnTapped(_ sender: Any) {
        
       let keyChainResult = KeychainWrapper.defaultKeychainWrapper.removeObject(forKey: KEY_UID)
        print("Gagan: ID removed from  keychain \(keyChainResult)")
         try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
        
    }

}
