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
extension SetRecycleClothNumberVC : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text ,  let inputNumber = Int(text) {
            self.selectInt = inputNumber
        }
    }
}
