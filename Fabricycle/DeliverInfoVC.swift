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
        
       
    }
    

    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func doneButtonClick(_ sender: Any) {//performNewForm
        let _ = MBProgressHUD.showAdded(to: self.view, animated: true)


        uploadAllClothImage()
        
//        performSegue(withIdentifier: "performNewForm", sender: nil)
    }
    func deliverForm(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        let formUidString = dateString
        
        let formItemsRef = FIRDatabase.database().reference(withPath: "ID/\(getUserId()!)/FormItems/\(formUidString)")
        formItemsRef.setValue(formObejct.returnFormForFireBase())
//        formItemsRef.child("userPhone").setValue(formObejct.phoneNumber)
//        formItemsRef.child("userAddress").setValue(formObejct.address)
//        formItemsRef.child("tensfarType").setValue(formObejct.transferType.rawValue)
//        formItemsRef.child("status").setValue(formObejct.status.rawValue)
//        formItemsRef.child("recycleClothNumber").setValue(formObejct.recycleClothNumber)
        
        for cloth in formObejct.clothList {
            formItemsRef.child("cloths").childByAutoId().setValue(cloth.returnUrlForFireBase())
        }
        performSegue(withIdentifier: "performNewForm", sender: nil)
    }
    func uploadAllClothImage(){
        var uploadCount = 0
        if formObejct.clothList.count == 0 {
            MBProgressHUD.hide(for: self.view, animated: true)
            deliverForm()
            return
        }
        
        for cloth in formObejct.clothList {
            cloth.uploadAllImage {
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
        return 2
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

    func textViewDidChange(_ textView: UITextView) {
        formObejct.address = textView.text
        UserDefaults.standard.set(textView.text, forKey: userAddress)

    }
    let timeList = ["All day" , "09:00 - 12:00 AM" , "12:00 - 06:00 PM" , "06:00 - 09:00 PM"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! DelliverinfoCell
            cell.nameTextField.addTarget(self, action: #selector(self.setUserName), for: .editingChanged)
            cell.phoneTextField.addTarget(self, action: #selector(self.setPhone), for: .editingChanged)
            cell.addressTextView.delegate = self
            cell.nameTextField.text = UserDefaults.standard.getUserName()
            cell.phoneTextField.text = UserDefaults.standard.getUserPhone()
            cell.addressTextView.text = UserDefaults.standard.getUserAddress()
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2")!
            
            cell.textLabel?.text = timeList[indexPath.row]
            cell.textLabel?.textColor = Color.grey.darken1
            
//            switch indexPath.row {
//            case 0:
//                cell.textLabel!.text = "ConvenientToTheMerchant".local
//                cell.detailTextLabel!.text = "關渡北投店"
//                if formObejct.transferType == .conviniateMarket {
//                    cell.accessoryType = .checkmark
//                }
//            case 1:
//                cell.textLabel!.text = "ToHomeReceipt".local
//                cell.detailTextLabel!.text = "9:00 - 18:00"
//                if formObejct.transferType == .gotoHomerecive {
//                    cell.accessoryType = .checkmark
//                }
//            default:
//                break
//            }
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
//        switch indexPath.section {
//        case 1:
//            let cell = tableView.cellForRow(at: indexPath)!
//            cell.accessoryType = .checkmark
//            switch indexPath.row {
//            case 0:
//                formObejct.transferType = .conviniateMarket
//                break
//            case 1:
//                formObejct.transferType = .gotoHomerecive
//                break
//            default:
//                break
//            }
//        default:
//            break
//        }
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