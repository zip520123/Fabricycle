//
//  MainPageVC.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/19.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import SwiftyJSON
class MainPageVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var uid : String!

//    var jsonForms = [JSON]()
    var formList : [FormObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = getUserId()!
        setUpTableView()
    }
    func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        FormObject.getFormObjectList {[weak self] (formList) in
            self?.formList = formList
            
            self?.tableView.reloadData()
        }
    }

    @IBAction func logoutClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func setForm(segue : UIStoryboardSegue) {
        if let formVC = segue.source as? AddNewRecycleNumber {
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewRecycleNumber" {
            if let formVC = segue.destination as? AddNewRecycleNumber {
                
                formVC.formObject = sender as! FormObject
            }
        }
    }
    
}
extension MainPageVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "mainPageCell")
        let formItem = formList[indexPath.row]

        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = formObjectDateFormatter
        let formDate = dateFomatter.date(from: formItem.uid)
        let displayFomatter = DateFormatter()
        displayFomatter.dateFormat = formDateDisplayFormatter

        cell?.textLabel?.text = displayFomatter.string(from: formDate ?? Date() )
            cell?.detailTextLabel?.text = formItem.status.toString()
        switch formItem.status {
        case .deliver , .waitForSend:
            cell?.detailTextLabel?.textColor = mainColor
            break
        case .accept , .sending , .review:
            cell?.detailTextLabel?.textColor = UIColor.gray
            break
        case .error:
            cell?.detailTextLabel?.textColor = UIColor.red
            break
        }
//        }
//        let text = clothJson.arrayValue.first!.stringValue
//        cell?.textLabel?.text = text
//        let cloth = clothList[indexPath.row]
//        cell.clothImage.image = cloth.imageList.first
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let formItem = formList[indexPath.row]
        performSegue(withIdentifier: "AddNewRecycleNumber", sender: formItem)
//        switch formItem.status {
//        case .deliver , .waitForSend:
//            let formItem = formList[indexPath.row]
//            performSegue(withIdentifier: "AddNewRecycleNumber", sender: formItem)
//        default:
//            break
//        }
        
        
        
//        // 1
//        guard let cell = tableView.cellForRow(at: indexPath) else { return }
//        // 2
//        let groceryItem = items[indexPath.row]
//        // 3
//        let toggledCompletion = !groceryItem.completed
//        // 4
//        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
//        // 5
//        groceryItem.ref?.updateChildValues([
//            "completed": toggledCompletion
//            ])
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let formItem = formList[indexPath.row]
            let alert = UIAlertController(title: "Delete form", message: "Are you sure to delete this form?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] (_) in
                formItem.ref?.removeValue()
                tableView.beginUpdates()
                self?.formList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            })
            let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            present(alert, animated: true, completion: nil)
            
        }
    }
}
