//
//  ProfileVC.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/28.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import MBProgressHUD
class ProfileVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
 

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        let user = FIRAuth.auth()?.currentUser
        var temp = ""
        
        
        if let user = user , let email = user.email{
            let uid = user.uid
            let photoUrl = user.photoURL
            let emailVer = user.isEmailVerified
            temp.append("uid : \(uid)\nemail : \(String(describing: email))\nphotoUrl : \(String(describing: photoUrl))\nemailVerifed : \(emailVer)")
        }
        
        textView.text = temp
    }
    @IBAction func sendVerifiedEmailButtonClick(_ sender: Any) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error) in
            hud.hide(animated: true)
            if let error = error {
                UIAlertController.showErrorMsg(errorMsg: error.localizedDescription)
            }else{
                UIAlertController.showMsg(title : "send success" , msg: nil)
            }
        })
    }
    @IBAction func logoutClick(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        dismiss(animated: true, completion: nil)
    }

}
