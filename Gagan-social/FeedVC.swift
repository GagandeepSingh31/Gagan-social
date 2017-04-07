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

class FeedVC: UIViewController , UITableViewDelegate, UITableViewDataSource , UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var imageAdded: RoundImageView!
    @IBOutlet weak var captionField: FancyTextField!
    
    var posts = [Post]()
    var imagePicker : UIImagePickerController!
    var imageSelected = false
    
    //To make it Globally , we use static
    static var imageCache : NSCache<NSString, UIImage> = NSCache()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        
        // This is to allow editing like croping, etc
        imagePicker.allowsEditing = true
        
        imagePicker.delegate = self
        
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
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
                return cell
            }else {
                cell.configureCell(post: post, img: nil)
                return cell
            }
           
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
    
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdded.image = image
            imageSelected = true
            
        }else {
            print("Gagan: A valid image wasn't selected")
        }
         imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true , completion: nil)
        
    }
    
    
    @IBAction func postBtnTapped(_ sender: Any) {
        
        guard let caption = captionField.text , caption != ""
            else {
                print("Gagan: Caption field must be filled")
                return
        }
        guard let img = imageAdded.image, imageSelected == true
            else {
                print("Gagan: Image must be selected")
                return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metaData) { (metaData, error) in
            
                if error != nil {
                    print("Gagan: Unable to upload to firebase Storage")
                }else {
                    print("Gagan: Images  successfully uploaded to firebase")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                       self.postToFirebase(imgUrl: url)
                    }
                    
                    
                }
            
            }
        }
    }
    
    func postToFirebase(imgUrl: String ) {
        
        let post : Dictionary<String, AnyObject> = [
        "caption": captionField.text as AnyObject,
        "imageUrl": imgUrl as AnyObject,
        "likes": 0 as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdded.image = UIImage(named: "add-image")
        
        tableView.reloadData()
    }

    @IBAction func signOutBtnTapped(_ sender: Any) {
        
       let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Gagan: ID removed from  keychain \(keyChainResult)")
         try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
        
    }

}
