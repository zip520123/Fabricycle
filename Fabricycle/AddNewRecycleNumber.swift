//
//  AddNewRecycleNumber.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/29.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import SwiftyJSON
class AddNewRecycleNumber: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
//    var clothList = [Cloth]()
//    var recycleClothNumber = 0
    var formObject = FormObject(clothList: [])
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        
        collectionView.delegate = self
        collectionView.dataSource = self
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        collectionView.reloadData()
    }
    @IBAction func getRecycleNumber(segue : UIStoryboardSegue){
        if let setRecycleNumberVC = segue.source as? SetRecycleClothNumberVC {
            formObject.recycleClothNumber = setRecycleNumberVC.selectInt
            tableView.reloadData()
            
        }
    }
    @IBAction func getSellCloth(segue : UIStoryboardSegue){
        if let newSellClothVC = segue.source as? AddNewSellClothVC {
            if formObject.clothList.index(of: newSellClothVC.cloth) == nil {
                formObject.clothList.append(newSellClothVC.cloth)
            }

            self.tableView.reloadData()
            collectionView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setRecycleNumber"{
            let setNuberVC = segue.destination as! SetRecycleClothNumberVC
            setNuberVC.selectInt = formObject.recycleClothNumber
            setNuberVC.selectNumberBlock = { selectInt in
                self.formObject.recycleClothNumber = selectInt
                self.tableView.reloadData()
            }
        }
        if segue.identifier == "selectCloth" {
            let addNewClothVC = segue.destination as! AddNewSellClothVC
            addNewClothVC.cloth = sender as! Cloth
        }
        if segue.identifier == "deliverInfo"{
            let deVC = segue.destination as! DeliverInfoVC
            
            deVC.formObejct = formObject
            
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
            
            cell.recycleNumberLabel.text = String(format : "%02d",formObject.recycleClothNumber)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewSellClothCell") as! AddNewSellClothCell
            cell.numberLabel.text = String(format : "%02d", formObject.clothList.count)
            
            return cell
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleClothCell") as! SingleClothCell
            let cloth = formObject.clothList[indexPath.row - 2]
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
            formObject.clothList.remove(at: indexPath.row - 2)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()

        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 1 {
            performSegue(withIdentifier: "selectCloth", sender: formObject.clothList[indexPath.row - 2])
        }
    }

}
extension AddNewRecycleNumber : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return formObject.clothList.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothCell", for: indexPath) as! ClothCollectionCell
        
        let cloth = formObject.clothList[indexPath.row]
        
        cell.nameLabel.text = cloth.descr
        cell.clothImageView.image = cloth.imageList.first
        cell.priceLabel.text = cloth.price.description
        return cell
    
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let size = CGSize(width: collectionView.width / 2 - 25, height: collectionView.height * 0.8)
        return size
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        let inset = UIEdgeInsetsMake(20, 20, 10, 20)
        return inset
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        performSegue(withIdentifier: "selectCloth", sender: formObject.clothList[indexPath.row ])
        
    }
}
