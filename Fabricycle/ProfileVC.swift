//
//  ProfileVC.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/28.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func logoutClick(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        dismiss(animated: true, completion: nil)
    }

}
