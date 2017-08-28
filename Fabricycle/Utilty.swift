//
//  utilty.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/25.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import Foundation
func getUserId()->String?{
    let user = FIRAuth.auth()?.currentUser
    return user?.uid
}
extension UIAlertController {

}
