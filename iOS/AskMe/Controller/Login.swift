//
//  Login.swift
//  AskMe
//
//  Created by Maryam Jafari on 11/23/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class Login: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    // Stephen =====>
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    // <===== Stephen
    
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var userName: UITextField!
    var hasProfile = false
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let user = Auth.auth().currentUser
            if let user = user {
                
                let uid = user.uid
                let email = user.email
         
                
            }
            let photoURL = Auth.auth().currentUser?.photoURL
            DBProvider.Instance.userExists(userId: user!.uid){(url ) in
                
                if (url == false){
                    
                    DBProvider.Instance.saveUser(withID: user!.uid, email : (user?.email)!, photoURL : String(describing: photoURL!), hasProfile: self.hasProfile, major: "", interest: "", schoolYear: "", address: "", interest2: "", interest3 : "", interest4 : "", interest5: "", interest6: "", notificationToken : self.appDelegate.notificationToken == nil ? "" :  self.appDelegate.notificationToken!)
                    self.performSegue(withIdentifier: "Profile", sender: "")
                    
                }
                else{
                    DBProvider.Instance.updateNotificationToken(userID : user!.uid, token : self.appDelegate.notificationToken == nil ? "" :  self.appDelegate.notificationToken!)
                    DBProvider.Instance.userHasProfile(userId: user!.uid){(url ) in
                        
                        if(url == true){
                            self.performSegue(withIdentifier: "FirstPage", sender: user!.uid)
                        }
                        else if (url == false){
                            self.performSegue(withIdentifier: "Profile", sender: "")
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Searching"{
            if let destination = segue.destination as? Searching{
                destination.reciverID = Auth.auth().currentUser?.uid
                destination.email = Auth.auth().currentUser?.email
                destination.photURL = Auth.auth().currentUser?.photoURL!
                
            }
        }
        if segue.identifier == "Profile"{
            if let destination = segue.destination as? ProfileViewController{
                destination.userID = Auth.auth().currentUser?.uid
                destination.email = Auth.auth().currentUser?.email
                destination.photURL = Auth.auth().currentUser?.photoURL!
                destination.showStart = true
                
            }
        }
        if segue.identifier == "FirstPage"{
            if let destination = segue.destination as? Start{
                destination.userID = Auth.auth().currentUser?.uid
                destination.email = Auth.auth().currentUser?.email
                destination.photURL = Auth.auth().currentUser?.photoURL!
                print("[Login.swift] notification token: \(String(describing: self.appDelegate.notificationToken))")
                
            }
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    @IBOutlet weak var signUp: UIButton!
    
    @IBAction func signUpClick(_ sender: Any) {
        
        if userName.text != "" && pass.text != ""{
            AuthProvider.Instance.signUP(withEmail: userName.text!, password: pass.text!, loginHandler: { (message) in
                
                if message != nil  {
                    self.alertTheUser(title: "Problem With Creating User", message: message!)
                }
                else{
                    
                    
                }
            })
        }
        
        
    }
    @IBOutlet weak var login: UIButton!
    @IBAction func logInClick(_ sender: Any) {
        if userName.text != "" && pass.text != ""{
            AuthProvider.Instance.logIn(withEmail: userName.text!, password: pass.text!, loginHandler: { (message) in
                if message != nil {
                    
                    self.alertTheUser(title: "Problem With Authentication", message: message!)
                }
                else{
                    self.userName.text = ""
                    self.pass.text = ""
                    self.performSegue(withIdentifier: "LogedIn", sender: self.userName.text)
                }
            })
        }
        
    }
    private func alertTheUser(title : String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction (title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
}

