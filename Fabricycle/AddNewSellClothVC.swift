//
//  AddNewSellClothVC.swift
//  Fabricycle
//
//  Created by Slin on 2017/9/2.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit

class AddNewSellClothVC: UIViewController ,UIImagePickerControllerDelegate{

    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var imageView3: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var takeCameraButton: UIView!
    
    @IBOutlet weak var doneButton: UIButton!
    var cloth : Cloth!
    
    let cellString = ["Price" , "Color" , "Gender" , "Size" , "Description"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if cloth == nil {
            cloth = Cloth()
        }
        setImage()
        let tipGesture = UITapGestureRecognizer(target: self, action: #selector(self.takeNewCamera))
        takeCameraButton.addGestureRecognizer(tipGesture)
    }
    
    func takeNewCamera(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)

        guard let uiImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        
        self.cloth.imageList.append(uiImage)
        if cloth.imageList.count > 3 {_ = cloth.imageList.popLast()}
        setImage()
    }
    func setImage(){
        for (index,item) in cloth.imageList.enumerated() {
            if index == 0 {
                imageView1.image = item
            }else if index == 1{
                imageView2.image = item
            }else if index == 2 {
                imageView3.image = item
            }
        }
    }
    func getPrice(_ price : Int){
        cloth.price = price
        tableView.reloadData()
    }
    func getClothDescription(_ text : String){
        cloth.descr = text
        tableView.reloadData()
    }
//    @IBAction func getPriceFromSegue(_ segue : UIStoryboardSegue){
//        let vc = segue.source as! SelectClothPriceVC
//        getPrice(vc.price)
//        
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectClothPrice" {
            let vc = segue.destination as! SelectClothPriceVC
            vc.price = cloth.price
            vc.selectPriceBlock = { price in
                self.getPrice(price)
            }
        }
        if segue.identifier == "editVC" {
            let vc = segue.destination as! EditClothDescriptionVC
            vc.descr = cloth.descr
            vc.editBlock = { text in
                self.getClothDescription(text)
            }
        }
    }

}
extension AddNewSellClothVC: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 160
        }
        return 44
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellString.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.detailTextLabel?.text = "\(cloth.price)"
            cell.textLabel?.text = cellString[indexPath.row]
            return cell
//        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.detailTextLabel?.text = "\(cloth.price)"
//        case 2:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.detailTextLabel?.text = "\(cloth.price)"
//        case 3:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.detailTextLabel?.text = "\(cloth.price)"
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "description", for: indexPath) as! AddNewSellClothDescriptionCell
           	cell.descriptionLabel.text = cloth.descr
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let detailText = ""
            cell.textLabel?.text = cellString[indexPath.row]
            cell.detailTextLabel?.text = detailText
            return cell
        }

        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "selectClothPrice", sender: nil)
        }
    }
}
