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
class LoginViewController: UIViewController ,FBSDKLoginButtonDelegate{
    

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
        view.backgroundColor = mainColor
        setUpFBbutton()
        setUpGoogleLoginButton()
    }
    func setUpFBbutton(){
        let FBloginButton = FBSDKLoginButton()
        FBloginButton.delegate = self
        view.layout(FBloginButton).centerHorizontally()
        FBloginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12).isActive = true
        FBloginButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor, multiplier: 1).isActive = true
    }
    func setUpGoogleLoginButton(){
        
    }
        // MARK: - fb login button delegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

        if let error = error {
            UIAlertController.showErrorMsg(errorMsg: error.localizedDescription)
            
            print(error.localizedDescription)
            return
        }
        
        if FBSDKAccessToken.current() != nil {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential, completion: { (firUser, error) in
                if error != nil {
                    return
                }else{
                    UIAlertController.showErrorMsg(errorMsg: error!.localizedDescription)
                    
                }
            })
        }else{
            UIAlertController.showErrorMsg(errorMsg: "FB access token nil , login fail")

            
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
