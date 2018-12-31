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
import TwitterKit

class ViewController: UIViewController, GIDSignInUIDelegate {

    // Outlets
    
    @IBOutlet weak var userInfoLabel: UILabel!
    
    @IBOutlet weak var twitterButtonView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Google
    GIDSignIn.sharedInstance()?.uiDelegate = self
        //Twitter
        let loginTwiterButton = TWTRLogInButton { (session, error) in
            if let error = error {
                debugPrint("Could not login twitter: \(error)")
            }
            
            if let session = session {
                let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
                self.firebaseLogin(credential)
            }
        }
        //loginTwiterButton.center.x = twitterButtonView.center.x
        //twitterButtonView.addsubView(loginTwiterButton)
        

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

    //Google
    
    @IBAction func googleSignInTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func customGoogleTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()

    }
    
    //Twitter

    @IBAction func customTwitterPressed(_ sender: Any) {
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            if let error = error {
                debugPrint("Could not login twitter: \(error)")
            }
            
            if let session = session {
                let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
                self.firebaseLogin(credential)
            }
        }
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
