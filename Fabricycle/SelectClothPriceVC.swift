//
//  SelectClothPriceVC.swift
//  Fabricycle
//
//  Created by Slin on 2017/9/3.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit

class SelectClothPriceVC: UIViewController , UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate{
    var price = 0
    var selectPriceBlock : (Int)-> Void = {_ in }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexP = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexP) as! SelectPriceCell
        cell.priceFileld.becomeFirstResponder()
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Price".local
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return "PricingStrategy".local
        return "此處告訴使用者我們的收費機制是什麼，藉由說明頁面讓使用這清楚了解我們的收費理念。"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectPriceCell
        cell.priceFileld.text = "\(price)"

        cell.priceFileld.addTarget(self, action: #selector(textChange(textField:)), for: .editingChanged)
        cell.priceFileld.delegate = self
        cell.selectionStyle = .none
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as!SelectPriceCell
        cell.priceFileld.becomeFirstResponder()
    }
    func textChange(textField : UITextField){
        if let text = textField.text , let int = Int(text){
            selectPriceBlock(int)
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }


}

