//
//  AddNewFormVC.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/19.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON

class AddNewFormVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    static var apiKey = ""
    static let apiURL = "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)"
    var clothList = [Cloth]()
    var uid : String!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pointLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadApikey()
        self.uid = getUserId()!
        setUpTableView()
        
    }
    
    func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
//        let formItemsRef = FIRDatabase.database().reference(withPath: "ID/\(self.uid)/FormItems")
//        formItemsRef.observe(.value, with: { (snapshot) in
//            let json = JSON(snapshot.value)
//            print(json.description)
//        })
        
    }
    func loadApikey(){
        
        let path = Bundle.main.path(forResource: "apikey", ofType: "plist")
        let	keys = NSDictionary(contentsOfFile: path!)
        let plistApiKey = keys!["GoogleVisionApiKey"] as! String
        AddNewFormVC.apiKey = plistApiKey
        
    }

    @IBAction func submitButtonClick(_ sender: Any) {
        if clothList.count == 0 {return}
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)

        var uploadCount = 0
        let formItemsRef = FIRDatabase.database().reference(withPath: "ID/\(self.uid)/FormItems")
        let newFormObject = formItemsRef.childByAutoId()
        
        for cloth in clothList {
            
            cloth.uploadAllImage(){
                uploadCount += 1
                
                let newClothObject = newFormObject.childByAutoId()
                newClothObject.setValue(cloth.imageListOnString)
                if uploadCount == self.clothList.count {
                    hud.hide(animated: true)
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        
//        let newFormObject = FIRDatabase.database().reference(withPath: "ID/\(self.uid)/FormItems").childByAutoId()
//        let emptyJson : JSON = [:]
//        let formObject = FormObject(clothList: emptyJson)
//        for item in clothList {
//            item.startUploadimage()
//        }
//        newFormObject.setValue(formObject.toAnyObject()) { (error, dbref) in
//            self.navigationController?.popViewController(animated: true)
//        }
    }
 
    @IBAction func takePicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.cameraOverlayView = UIImageView(image:#imageLiteral(resourceName: "cut-2"))
        present(picker, animated: true)
    }
    

    @IBAction func getClothFromNewCloth(segue : UIStoryboardSegue){
        if let addNewClothVC = segue.source as? AddNewClothVC {
            if addNewClothVC.cloth.imageList.count != 0 {
                clothList.append(addNewClothVC.cloth)
                pointLabel.text = "\(clothList.count)"
                self.tableView.reloadData()
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let clothTableVC = segue.destination as? ClothTableVC {
//            clothTableVC.clothList = self.clothList
//        }
    }
}
extension AddNewFormVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! AddNewFormCell
        let cloth = clothList[indexPath.row]
        cell.clothImage.image = cloth.imageList.first

        
        return cell
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
        if editingStyle == .delete {
            clothList.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
    }
}
