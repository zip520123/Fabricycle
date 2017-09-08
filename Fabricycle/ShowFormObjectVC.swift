//
//  ShowFormObjectVC.swift
//  Fabricycle
//
//  Created by Slin on 2017/9/8.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit

class ShowFormObjectVC: UIViewController {
    var fromObject : FormObject!
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if fromObject == nil {
            fromObject = FormObject(clothList: [])
        }
        
        var displayString = ""
        displayString.append("Name : \(fromObject.userName)\n")
        displayString.append("recycle Cloth Number : \(fromObject.recycleClothNumber)\n")
        displayString.append("phoneNumber : \(fromObject.phoneNumber)\n")
        displayString.append("address : \(fromObject.address)\n")
        displayString.append("status : \(fromObject.status.rawValue)\n")
        displayString.append("clothList : \n")
        for item in fromObject.clothList {
            displayString.append("  price : \(item.price)\n")
            displayString.append("  description : \(item.descr)\n")
            displayString.append("------\n")
        }
        textView.text = displayString
    }



}
