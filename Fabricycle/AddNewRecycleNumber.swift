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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    @IBAction func getRecycleNumber(segue : UIStoryboardSegue){
        if let setRecycleNumberVC = segue.source as? SetRecycleClothNumberVC {
            recycleClothNumber = setRecycleNumberVC.selectInt
            tableView.reloadData()
        }
    }
    @IBAction func getSellCloth(segue : UIStoryboardSegue){
        if let newSellClothVC = segue.source as? AddNewSellClothVC {
            if clothList.index(of: newSellClothVC.cloth) == nil {
                clothList.append(newSellClothVC.cloth)
            }

            self.tableView.reloadData()
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCloth" {
            let addNewClothVC = segue.destination as! AddNewSellClothVC
            addNewClothVC.cloth = sender as! Cloth
        }
    }
}
extension AddNewRecycleNumber : UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + clothList.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecycleClothNumberCell") as! RecycleClothNumberCell
            
            cell.recycleNumberLabel.text = String(format : "%02d",self.recycleClothNumber)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewSellClothCell") as! AddNewSellClothCell
            cell.numberLabel.text = String(format : "%02d", clothList.count)
            
            return cell
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleClothCell") as! SingleClothCell
            let cloth = clothList[indexPath.row - 2]
            cell.clothImageView.image = cloth.imageList.first
            cell.clothDescripLabel.text = "Price : \(cloth.price)"
            return cell
        }

    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row > 1{
            return true
        }else{
            return false
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            clothList.remove(at: indexPath.row - 2)
            tableView.deleteRows(at: [indexPath], with: .automatic)

        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 1 {
            performSegue(withIdentifier: "selectCloth", sender: clothList[indexPath.row - 2])
        }
    }

}
