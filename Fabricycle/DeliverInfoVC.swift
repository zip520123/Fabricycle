//
//  DeliverInfoVC.swift
//  Fabricycle
//
//  Created by Slin on 2017/9/3.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import Material
class DeliverInfoVC: UIViewController ,UITableViewDelegate , UITableViewDataSource , UITextViewDelegate{
    
    var formObejct = FormObject(clothList: [])
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        switch formObejct.status {
        case  .sending , .review , .accept:
            tableView.isUserInteractionEnabled = false
            doneButton.isUserInteractionEnabled = false
            doneButton.backgroundColor = Color.gray
        default:
            break
        }
       
    }
    

    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func doneButtonClick(_ sender: Any) {//performNewForm
        let _ = MBProgressHUD.showAdded(to: self.view, animated: true)
        uploadAllClothImage()

    }
    func deliverForm(){
        if formObejct.ref == nil {
            var formUidString = ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = formObjectDateFormatter
            let dateString = dateFormatter.string(from: Date())
            formUidString = dateString
            let formItemsRef = FIRDatabase.database().reference(withPath: "ID/\(getUserId()!)/FormItems/\(formUidString)")
            formItemsRef.setValue(formObejct.returnFormForFireBase())
            for cloth in formObejct.clothList {
                if cloth.ref == nil {
                    formItemsRef.child("cloths").childByAutoId().setValue(cloth.returnUrlForFireBase())
                }
            }
            if formObejct.uid == "0" {
                performSegue(withIdentifier: "performNewForm", sender: nil)
            }

        } else {
//            performSegue(withIdentifier: "setForm", sender: nil)
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            formObejct.ref?.updateChildValues(formObejct.returnFormForFireBase() as! [AnyHashable : Any], withCompletionBlock: { [weak self] (error, ref) in
                hud.hide(animated: true)
                self?.performSegue(withIdentifier: "setForm", sender: nil)
            })
        }

        
    }
    func uploadAllClothImage(){
        var uploadCount = 0
        if formObejct.ref != nil {
            deliverForm()
            return
        }
        if formObejct.clothList.count == 0 {
            MBProgressHUD.hide(for: self.view, animated: true)
            deliverForm()
            return
        }
        
        for cloth in formObejct.clothList {
            if cloth.ref == nil {
                cloth.uploadAllImage {
                    uploadCount += 1
                    if uploadCount == self.formObejct.clothList.count {
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.deliverForm()
                            
                        }
                    }
                }
            }else {
                uploadCount += 1
                if uploadCount == self.formObejct.clothList.count {
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.deliverForm()
                        
                    }
                }
                
            }
            

        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "SenderInfo".local
        case 1:
            return "Delivery time"
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "After sending this form, Fabricycle will contact you to confirm your address and the exact pick-up time. The courier will pick up your clothes at the address that you have provided to us. Please separate those clothes that you want to sell from those clothes that you just want to recycle and pack these clothes into a box. Thank you for your cooperation."
        default :
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 180
        case 1:
            return 44
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        default:
            break
        }
        return 0
    }

    func setUserName(textField : UITextField ){
        formObejct.userName = textField.text!
        UserDefaults.standard.set(textField.text, forKey: userName)
    }

    func setPhone(textField : UITextField ){
        formObejct.phoneNumber = textField.text!
        UserDefaults.standard.set(textField.text, forKey: userPhone)
    }
    func setAddress(textField : UITextField ){
        formObejct.address = textField.text!
        UserDefaults.standard.set(textField.text, forKey: userAddress)
    }
//    func textViewDidChange(_ textView: UITextView) {
//        formObejct.address = textView.text
//        UserDefaults.standard.set(textView.text, forKey: userAddress)
//
//    }
    let timeList = ["All day" , "09:00 - 12:00 AM" , "12:00 - 06:00 PM" , "06:00 - 09:00 PM"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! DelliverinfoCell
            cell.nameTextField.addTarget(self, action: #selector(self.setUserName), for: .editingChanged)
            cell.phoneTextField.addTarget(self, action: #selector(self.setPhone), for: .editingChanged)
            cell.addressTextField.addTarget(self, action: #selector(self.setAddress), for: .editingChanged)
            if formObejct.uid != "0"{
                cell.nameTextField.text = formObejct.userName
                cell.phoneTextField.text = formObejct.phoneNumber
                cell.addressTextField.text = formObejct.address
            }else{
                cell.nameTextField.text = UserDefaults.standard.getUserName()
                cell.phoneTextField.text = UserDefaults.standard.getUserPhone()
                cell.addressTextField.text = UserDefaults.standard.getUserAddress()
            }
            
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2")!
            
            cell.textLabel?.text = timeList[indexPath.row]
            cell.textLabel?.textColor = Color.grey.darken1

            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "")
            return 	cell!
        }
    }
    func deselectAllCheckMark(){
        for index in 0...3 {
            let indexP = IndexPath(row: index, section: 1)
            let cell = tableView.cellForRow(at: indexP)
            cell?.accessoryType = .none
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {return}
        tableView.deselectRow(at: indexPath, animated: true)
        deselectAllCheckMark()
        
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        formObejct.deliverTimeScale = timeList[indexPath.row]

    }


}
