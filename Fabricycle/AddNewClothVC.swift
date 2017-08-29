//
//  AddNewClothVC.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/20.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit

class AddNewClothVC: UIViewController , UIImagePickerControllerDelegate {

    var cloth : Cloth!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBAction func cameraButtonClick(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo

        present(picker, animated: true)
    }
    //image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        //        imageView.image = nil
        guard let uiImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        
        self.cloth.imageList.append(uiImage)
        self.collectionView.reloadData()
    }
    @IBAction func doneButtonClick(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let uid = getUserId()!
        cloth = Cloth([] , userId : uid)
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
