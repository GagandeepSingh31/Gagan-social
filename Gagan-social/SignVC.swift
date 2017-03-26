//
//  SignVC.swift
//  Gagan-social
//
//  Created by Gagandeep Singh on 3/26/17.
//  Copyright © 2017 Gagandeep Singh. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class SignVC : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Gagan: Unable to authenticate with facebook -\(error)")
            }else if result?.isCancelled == true {
                print("Gagan: User cancelled facebook authentication")
            }else {
                print("Gagan: Successfully authenticated with facebook")
                
                let credential  = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            
            }
        }
    }
    
    func firebaseAuth(_ credentail : FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credentail, completion: { (user, error) in
            if error != nil {
                print("Gagan: Unable to authenticate with firebase -\(error)")
            }else {
                print(" Gagan: Successfully authenticated with firebase")
            }
            
        })
        
    }
}

