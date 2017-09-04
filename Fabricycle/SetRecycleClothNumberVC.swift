//
//  SetRecycleClothNumberVC.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/30.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit

class SetRecycleClothNumberVC: UIViewController {

    @IBOutlet weak var clothNumberTextField: UITextField!
    var selectInt = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        clothNumberTextField.delegate = self
        clothNumberTextField.addTarget(self, action: #selector(self.setSelectInt(textField:)), for: .editingChanged)
    }
    func setSelectInt(textField : UITextField){
        if let text = textField.text ,  let inputNumber = Int(text) {
            self.selectInt = inputNumber
        }
    }

  

    override func viewDidAppear(_ animated: Bool) {
        clothNumberTextField.becomeFirstResponder()
    }
}
extension SetRecycleClothNumberVC : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
}
