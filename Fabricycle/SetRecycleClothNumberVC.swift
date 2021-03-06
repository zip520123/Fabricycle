//
//  SetRecycleClothNumberVC.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/30.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit

class SetRecycleClothNumberVC: UIViewController {

    @IBOutlet weak var bulletinLabel: UILabel!
    @IBOutlet weak var clothNumberTextField: UITextField!
    var selectInt = 0
    var selectNumberBlock : (Int)-> Void = {_ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        bulletinLabel.text = bulletinString
        clothNumberTextField.delegate = self
        clothNumberTextField.addTarget(self, action: #selector(self.setSelectInt(textField:)), for: .editingChanged)
        
    }
    func setSelectInt(textField : UITextField){
        if let text = textField.text ,  let inputNumber = Int(text) {
            self.selectInt = inputNumber
            selectNumberBlock(inputNumber)
        }
    }
    
  

    override func viewDidAppear(_ animated: Bool) {
        clothNumberTextField.becomeFirstResponder()
    }
}
extension SetRecycleClothNumberVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
}
