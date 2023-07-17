//
//  LoginTableViewController.swift
//  LoginUI
//
//  Created by Yogesh Patel on 22/01/21.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class LoginTableViewController: UITableViewController {
    
    @IBOutlet weak var btnFacebook: FBLoginButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.dismissKeyboard()
    }
    
    
   
    
 
    
    @IBAction func btnGoogleTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
  
    
    func googleLogin(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        
        if GIDSignIn.sharedInstance().hasPreviousSignIn(){
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            print("Already Login")
        }
    }
}





extension LoginTableViewController: LoginButtonDelegate{
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name, picture, short_name, name, middle_name, name_format,age_range"], tokenString: token, version: nil, httpMethod: .get)
        request.start { (connection, result, error) in
            print("\(result)")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logout")
    }
}

extension LoginTableViewController: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("\(user.profile.email ?? "No Email")")
        
        var objvc  = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(objvc, animated: true)
        
    }
}
