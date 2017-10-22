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

let mainColor : UIColor = #colorLiteral(red: 0.03729180247, green: 0.6208408475, blue: 0.7889618278, alpha: 1)
let userName : String = "userName"
let userPhone : String = "userPhone"
let userAddress : String = "userAddress"
let formObjectDateFormatter : String = "YYYY-MM-dd HH:mm:ss"
let formDateDisplayFormatter : String = "MMMM d, YYYY"
let placeHolderImage : UIImage = Icon.arrowDownward!.tint(with: Color.white)!
var bulletinString : String = ""
extension String {
    var local: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

}
extension UserDefaults {
    func getUserName()->String{
        return self.object(forKey: userName) as? String ?? ""
    }
    func setUserName(_ name : String){
        self.set(name, forKey: userName)
    }
    func getUserPhone()->String{
        return self.object(forKey: userPhone) as? String ?? ""
    }
    func setPhone(_ phone : String){
        self.set(phone , forKey: userPhone)
    }
    func getUserAddress()->String{
        return self.object(forKey: userAddress) as? String ?? ""
    }
    func setAddress(_ address : String){
        self.set(address , forKey: userAddress)
    }
    
}
extension UIAlertController {
    class func showErrorMsg(errorMsg : String){
        UIAlertController.showMsg(title: "error" , msg : errorMsg)
    }
    
    class func showMsg(title : String? , msg : String?){
        let alertC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let vc = AppDelegate.topVC()
        vc?.present(alertC, animated: true) {
            let tapGes = UITapGestureRecognizer(target: alertC, action: #selector(alertC.dismissSelf))
            alertC.view.superview?.isUserInteractionEnabled = true
            alertC.view.superview?.addGestureRecognizer(tapGes)
        }
    }
    func dismissSelf(){
        self.dismiss(animated: true, completion: nil)
    }
}
