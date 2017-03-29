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
import SwiftKeychainWrapper

class SignVC : UIViewController {

    
    @IBOutlet weak var emailField: FancyTextField!
    @IBOutlet weak var passField: FancyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                if let user = user {
                    let userData = ["provider": credentail.provider]
                    self.completedSignIn(id: user.uid, userData: userData)
                }
                
                
            }
            
        })
        
    }
    
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text , let pass = passField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error  == nil {
                    print("Gagan: Email user authenticated with  firebase")
                    if let user = user {
                       let userData = ["provider": user.providerID]
                        self.completedSignIn(id: user.uid , userData: userData)
                    }
                }else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
                        if error != nil {
                            print("Gagan: Unable to authenticate with Firebase using email")
                        }else {
                            print("Gagan: Successfully authenticated with Firebase")
                            if let user = user {
                               let userData = ["provider": user.providerID]
                                self.completedSignIn(id: user.uid ,userData: userData)
                            }

                        }
                    })
                }
                
                
            })
            
        }
        
    }
    
    func completedSignIn(id: String, userData : Dictionary<String , String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.defaultKeychainWrapper.set(id, forKey: KEY_UID)
        print("Gagan: Data saved to keychain ")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    
    
}

