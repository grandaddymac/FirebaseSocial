//
//  ViewController.swift
//  FirebaseSocial
//
//  Created by gdm on 12/30/18.
//  Copyright © 2018 gdm. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {

    // Outlets
    
    @IBOutlet weak var userInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    GIDSignIn.sharedInstance()?.uiDelegate = self
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                self.userInfoLabel.text = "No user logged in"
            } else {
                self.userInfoLabel.text = "Welcome user: \(user?.uid ?? "")"
            }
        }
    }

    @IBAction func googleSignInTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func customGoogleTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()

    }


    @IBAction func logoutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            logoutSocial()
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            debugPrint("Error signing out", signoutError)
        }
    }
    
    func firebaseLogin(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
        }
    }
    
    func logoutSocial() {
        guard let user = Auth.auth().currentUser else { return }
        for info in (user.providerData) {
            switch info.providerID {
            case GoogleAuthProviderID:
                GIDSignIn.sharedInstance()?.signOut()
                print("google")
            case TwitterAuthProviderID:
                print("twitter")
            case FacebookAuthProviderID:
                print("facebook")
            default:
                break
            }
        }
    
    }

}
