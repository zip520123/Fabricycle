//
//  SignUpVC.swift
//  Fabricycle
//
//  Created by Slin on 2017/9/23.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
class SignUpVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(Icon.cm.arrowBack?.tint(with: Color.white), for: .normal)
        password.isSecureTextEntry = true
        repassword.isSecureTextEntry = true
//        nameField.placeholder = "Name"
//        emailField.placeholder = "Email"
//        password.placeholder = "Password"
//        repassword.placeholder = "Comfirm your password"
//        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}];
//        nameField.attributedPlaceholder = NSAttributedString(string: "placeholder text",attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        nameField.attributedPlaceholder = NSAttributedString(string:"Name", attributes:[NSForegroundColorAttributeName: Color.white])
        emailField.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: Color.white])
         password.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: Color.white])
         repassword.attributedPlaceholder = NSAttributedString(string:"Comfirm your password", attributes:[NSForegroundColorAttributeName: Color.white])

    }
    
    @IBAction func signUpButtonClick(_ sender: Any) {
        if password.text == repassword.text && password.text != "" {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                       password: password.text!) { user, error in
                                        hud.hide(animated: true)
                                        if error == nil {
                                            // 3
                                            FIRAuth.auth()!.signIn(withEmail: self.emailField.text!,
                                                                   password: self.password.text!)
                                            self.setUserName()
                                            self.dismiss(animated: true, completion: nil)
                                        }else{
                                            let alert = UIAlertController(title: "error", message: error?.localizedDescription, preferredStyle: .alert)
                                            self.present(alert, animated: true, completion : nil)
                                        }
            }
        }

    }
    func setUserName() {
        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
        changeRequest?.displayName = nameField.text
        changeRequest?.commitChanges { (error) in
            print("commit change error :\(error?.localizedDescription)")
        }
    }
    func sendVarifacationEmail(){
       FIRAuth.auth()?.currentUser?.sendEmailVerification { (error) in
        
        }
    }
    @IBAction func backButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }


}
