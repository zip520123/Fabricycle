/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Firebase
import FBSDKLoginKit
import Material
import MBProgressHUD
import GoogleSignIn
class LoginViewController: UIViewController ,FBSDKLoginButtonDelegate , GIDSignInUIDelegate{
    

    // MARK: Constants
    let loginToList = "LoginToList"
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: Actions
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        FIRAuth.auth()?.signIn(withEmail: textFieldLoginEmail.text!, password: textFieldLoginPassword.text!, completion: { (firUser, error) in
            hud.hide(animated: true)
            if error != nil {
                
                UIAlertController.showErrorMsg(errorMsg: error!.localizedDescription)
                
            }
        })
        
        
    }
    
    @IBAction func sendForgetPasswordEmail(_ sender: Any) {
        let alert = UIAlertController(title: "reset password",
                                      message: nil,
                                      preferredStyle: .alert)
        
        let sendAction = UIAlertAction(title: "Send",
                                       style: .default) { action in
                                        // 1
                                        
        if let emailField = alert.textFields?[0] , let email = emailField.text {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                FIRAuth.auth()?.sendPasswordReset(withEmail: email) { (error) in
                    hud.hide(animated: true)
                    if error != nil {
                        UIAlertController.showErrorMsg(errorMsg: error!.localizedDescription)
                    }else{
                        UIAlertController.showMsg(title: nil, msg: "send email success")
                    }
                }
            }
                   
                   
                                        
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        
        alert.addAction(sendAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func signUpDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        // 1
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        
                                        // 2
                                        FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                                                   password: passwordField.text!) { user, error in
                                                                    if error == nil {
                                                                        // 3
                                                                        FIRAuth.auth()!.signIn(withEmail: self.textFieldLoginEmail.text!,
                                                                                               password: self.textFieldLoginPassword.text!)
                                                                    }else{
                                                                        let alert = UIAlertController(title: "error", message: error?.localizedDescription, preferredStyle: .alert)
                                                                        self.present(alert, animated: true, completion : nil)
                                                                    }
                                        }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
        }
        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
        view.backgroundColor = mainColor
        setUpFBbutton()
        setUpGoogleLoginButton()
    }
    let fbLoginButton = FBSDKLoginButton()
    func setUpFBbutton(){
        fbLoginButton.isHidden = true
        fbLoginButton.delegate = self
        
        view.layout(fbLoginButton).centerHorizontally()
        fbLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12).isActive = true
        fbLoginButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor, multiplier: 1).isActive = true
        fbLoginButton.heightAnchor.constraint(equalTo: loginButton.heightAnchor, multiplier: 1).isActive = true

    }
    
    let gIDSignInButton = GIDSignInButton()
    func setUpGoogleLoginButton(){
        view.layout(gIDSignInButton).centerHorizontally()
        gIDSignInButton.topAnchor.constraint(equalTo: fbLoginButton.bottomAnchor, constant: 12).isActive = true
        gIDSignInButton.widthAnchor.constraint(equalTo: fbLoginButton.widthAnchor, multiplier: 1).isActive = true
//        gIDSignInButton.heightAnchor.constraint(equalTo: loginButton.heightAnchor, multiplier: 1).isActive = true
        
    }
    // MARK: - google login
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//        if let error = error {
//            print("error : \(error.localizedDescription)")
//            return
//        }
//        
//        guard let authentication = user.authentication else {
//            print("error : user.authentication")
//            return }
//        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                       accessToken: authentication.accessToken)
//        
//        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
//            if let error = error {
//                UIAlertController.showErrorMsg(errorMsg: error.localizedDescription)
//                return
//            }
//
//        }
    }
    
    
    // MARK: - fb login button delegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

        if let error = error {
            UIAlertController.showErrorMsg(errorMsg: error.localizedDescription)
            
            print(error.localizedDescription)
            return
        }
        if result.token != nil {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: result.token.tokenString)
            FIRAuth.auth()?.signIn(with: credential, completion: { (firUser, error) in
                if error != nil {
                    return
                }else{
                    UIAlertController.showErrorMsg(errorMsg: error!.localizedDescription)
                    
                }
            })
        }else{
            print("not get fb token")
        }
        
        
        
    }
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
     */
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldLoginEmail {
            textFieldLoginPassword.becomeFirstResponder()
        }
        if textField == textFieldLoginPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
