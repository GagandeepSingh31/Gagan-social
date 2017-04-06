//
//  PostCell.swift
//  Gagan-social
//
//  Created by Gagandeep Singh on 3/28/17.
//  Copyright © 2017 Gagandeep Singh. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg : UIImageView!
    @IBOutlet weak var usernameLbl : UILabel!
    @IBOutlet weak var postImg : UIImageView!
    @IBOutlet weak var caption : UITextView!
    @IBOutlet weak var likesLbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell (post : Post , img : UIImage? = nil) {
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        }else {
            
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024 , completion: { (data, error) in
                
                if error != nil {
                    print("Gagan: Unable to download images from the Firebase storage")
                }else {
                     print("Gagan: Images downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
                
            })
        }
    }
    
}
