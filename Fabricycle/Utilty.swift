//
//  utilty.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/25.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import Foundation
import Material
func getUserId()->String?{
    let user = FIRAuth.auth()?.currentUser
    return user?.uid
}
let mainColor : UIColor = #colorLiteral(red: 0.1615852118, green: 0.3646870852, blue: 0.5849281549, alpha: 1)
extension UIAlertController {
    class func showErrorMsg(errorMsg : String){
        let alertC = UIAlertController(title: "error", message: errorMsg, preferredStyle: .alert)
        let vc = Application.keyWindow!.rootViewController!
        vc.present(alertC, animated: true) {
            let tapGes = UITapGestureRecognizer(target: alertC, action: #selector(alertC.dismissSelf))
            alertC.view.superview?.isUserInteractionEnabled = true
            alertC.view.superview?.addGestureRecognizer(tapGes)
        }
    }
    func dismissSelf(){
        self.dismiss(animated: true, completion: nil)
    }
}
