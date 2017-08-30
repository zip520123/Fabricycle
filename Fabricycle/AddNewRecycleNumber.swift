//
//  AddNewRecycleNumber.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/29.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit

class AddNewRecycleNumber: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var clothList = [Cloth]()
    var recycleClothNumber = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 220

    }
    @IBAction func getRecycleNumber(segue : UIStoryboardSegue){
        if let setRecycleNumberVC = segue.source as? SetRecycleClothNumberVC {
            recycleClothNumber = setRecycleNumberVC.selectInt
            tableView.reloadData()
        }
    }
    @IBAction func getSellCloth(segue : UIStoryboardSegue){
        if let addNewClothVC = segue.source as? AddNewClothVC {
            
            clothList.append(addNewClothVC.cloth)
            
            self.tableView.reloadData()
            
        }
    }
}
extension AddNewRecycleNumber : UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecycleClothNumberCell") as! RecycleClothNumberCell
            
            cell.recycleNumberLabel.text = String(format : "%02d",self.recycleClothNumber)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewSellClothCell")
            
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleClothCell")
            
            return cell!
        }

    }

}
