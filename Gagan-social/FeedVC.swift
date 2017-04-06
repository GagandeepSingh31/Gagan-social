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
    
    var posts = [Post]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //Go to the firebase database posts.
        DataService.ds.REF_POSTS.observe(.value, with : { (snapshot) in
            // print(snapshot.value)  // This is showing all the posts json of the firebase database
            
           if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                        
                    }
                }
            }
            self.tableView.reloadData()
            })
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
          let post = posts[indexPath.row]
//        print("Gagan: \(post.caption)")
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.configureCell(post: post)
            return cell
        }else {
            return PostCell()
        }
        
        //return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
   
    

    
    @IBAction func signOutBtnTapped(_ sender: Any) {
        
       let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Gagan: ID removed from  keychain \(keyChainResult)")
         try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
        
    }

}
