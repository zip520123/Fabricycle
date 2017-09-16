//
//  EditClothDescriptionVC.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/9/5.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit

class EditClothDescriptionVC: UIViewController , UITextViewDelegate {

    @IBOutlet weak var editTextView: UITextView!
    var editBlock : (String) -> Void = {_ in}
    var descr : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        editTextView.text = descr
        editTextView.delegate = self
    }
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            editBlock(text)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "edit this" {
            textView.text = ""
        }
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
