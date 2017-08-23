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
    var uid = ""

    var jsonForm = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        setUpTableView()
    }
    func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        let formItemsRef = FIRDatabase.database().reference(withPath: "ID/\(self.uid)/FormItems")
        formItemsRef.observe(.value, with: { (snapshot) in
            let json = JSON(snapshot.value)
            print(json.description)
            
            
            
            var tempJSON = [JSON]()
            
            for (_,value) in json.dictionaryValue {
                tempJSON.append(value)

            }
//            self.displayString = tempString
            self.jsonForm = tempJSON
            self.tableView.reloadData()
        })
        
    }
    
    @IBAction func logoutClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getUser(){
        if let user = FIRAuth.auth()?.currentUser{
            uid = user.uid
        }
    }
    @IBAction func addNewForm(_ sender: Any) {
        
        
    }
    
    
}
extension MainPageVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonForm.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "mainPageCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainPageCell")
        let clothJson = jsonForm[indexPath.row]
        let text = clothJson.arrayValue.first!.stringValue
        cell?.textLabel?.text = text
//        let cloth = clothList[indexPath.row]
//        cell.clothImage.image = cloth.imageList.first
        
        
        return cell!
    }
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
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
    //    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            clothList.remove(at: indexPath.row)
//            tableView.reloadData()
//            
//        }
    }
}
