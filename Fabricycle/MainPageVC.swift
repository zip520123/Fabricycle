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
        let formItemsRef = FIRDatabase.database().reference(withPath: "ID/\(getUserId()!)/FormItems")
        formItemsRef.observe(.value, with: { (snapshot) in

            let json = JSON(snapshot.value)
            print(json.description)
            var formObjectList : [FormObject] = []
            for (key,value) in json.dictionaryValue {
                let formObject = FormObject(json: value , id: key)
                formObjectList.append(formObject)
                
            }
            self.formList = formObjectList
            
            self.tableView.reloadData()
        })
        
    }
    @IBAction func getNewForm(segue : UIStoryboardSegue){
        if segue.source.isKind(of: DeliverInfoVC.classForCoder()){
            
        }
    }
    @IBAction func logoutClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func addNewForm(_ sender: Any) {
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFormItem" {
            if let formVC = segue.destination as? FormItemVC {
                formVC.jsonForm = sender as! JSON
            }
        }
    }
    
}
extension MainPageVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "mainPageCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainPageCell")
        let formItem = formList[indexPath.row]
//        for (key , value) in formItem {
            cell?.textLabel?.text = formItem.uid
            cell?.detailTextLabel?.text = formItem.status.rawValue
//        }
//        let text = clothJson.arrayValue.first!.stringValue
//        cell?.textLabel?.text = text
//        let cloth = clothList[indexPath.row]
//        cell.clothImage.image = cloth.imageList.first
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
//        let formItem = jsonForms[indexPath.row]
//        performSegue(withIdentifier: "showFormItem", sender: formItem)
        
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
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            clothList.remove(at: indexPath.row)
//            tableView.reloadData()
//            
//        }
    }
}
