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

    @IBAction func googleSignInTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
    }
}

