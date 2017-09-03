//
//  AddNewClothVC.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/20.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit

class AddNewClothVC: UIViewController , UIImagePickerControllerDelegate , UITextFieldDelegate {

    var cloth : Cloth!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var priceTextField: UITextField!
    var price = 0
    @IBAction func cameraButtonClick(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        doneButton.isEnabled = false
        present(picker, animated: true)
    }
    //image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        guard let uiImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        
        self.cloth.imageList.append(uiImage)
        self.collectionView.reloadData()
    }
    @IBAction func doneButtonClick(_ sender: Any) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text , let clothPrice = Int(text) {
            price = clothPrice
            doneButton.isEnabled = true
        }else{
            doneButton.isEnabled = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTextField.delegate = self
        if (cloth == nil){
            cloth = Cloth()
        }
        priceTextField.text = "\(price)"
        price = cloth.price
        
        doneButton.isEnabled = cloth.price != 0
        collectionView.delegate = self
        collectionView.dataSource = self
        

        
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
extension AddNewClothVC : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothCollectionCell", for: indexPath) as! ClothCollectionCell
        cell.clothImageView.image = cloth.imageList[indexPath.row]
        return cell
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cloth.imageList.count
    }

    

}
