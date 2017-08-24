//
//  FormItemVC.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/23.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import SwiftyJSON
class FormItemVC: UIViewController {
    var jsonForm : JSON = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    func setUI(){
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.translatesAutoresizingMaskIntoConstraints = false
        var displayString = ""
        let textView = UITextView()
        if let user = FIRAuth.auth()?.currentUser{
            displayString.append("userID :\(user.uid)\n")
            displayString.append("email :\(user.email!)\n")
        }
        displayString.append("image address: \n")
        
        displayString.append(jsonForm.description)
        textView.frame = self.view.frame
        textView.text = displayString
        view.addSubview(textView)
//        textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1, constant: 0).isActive = true
//        textView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: 0).isActive = true
//        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        textView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
