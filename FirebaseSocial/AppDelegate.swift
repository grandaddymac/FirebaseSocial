//
//  AppDelegate.swift
//  FirebaseSocial
//
//  Created by gdm on 12/30/18.
//  Copyright © 2018 gdm. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import TwitterKit
import TwitterCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , GIDSignInDelegate{
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        //Google
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        //Twitter
        let key = Bundle.main.object(forInfoDictionaryKey: "consumerKey")
        let secret = Bundle.main.object(forInfoDictionaryKey: "consumerSecret")
        if let key = key as? String, let secret = secret as? String {
            TWTRTwitter.sharedInstance().start(withConsumerKey: key, consumerSecret: secret)
        }
        
        return true
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            debugPrint("Could not login with Google: \(error)")
        } else {
            guard let controller = GIDSignIn.sharedInstance()?.uiDelegate as? ViewController else { return }
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            controller.firebaseLogin(credential)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let returnGoogle = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        let returnTwitter = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        
        return returnGoogle || returnTwitter
    }
   
}

