//
//  ClothProfileVC.swift
//  Fabricycle
//
//  Created by Slin on 2017/10/3.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import HMSegmentedControl
import iCarousel
import Material
import SwiftyJSON
import SDWebImage
import MBProgressHUD
class ClothProfileVC: UIViewController , iCarouselDelegate , iCarouselDataSource ,UIImagePickerControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var icarousel: iCarousel!
    @IBOutlet weak var hmSegment: HMSegmentedControl!
    var formObjectList : [FormObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hmSegment.sectionTitles = ["Selling" ,"Selled"];
        hmSegment.backgroundColor = mainColor
        hmSegment.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName:UIColor.white]
        hmSegment.selectionIndicatorColor = Color.white
        hmSegment.segmentWidthStyle = .fixed
        hmSegment.selectionStyle = .fullWidthStripe
        hmSegment.selectionIndicatorLocation = .down
        hmSegment.verticalDividerWidth = 0.5
        hmSegment.segmentEdgeInset = UIEdgeInsetsMake(10, 5, 10, 5)
        hmSegment.indexChangeBlock = {index in self.icarousel.scrollToItem(at: index, animated: true) }
        
        nameLabel.text = FIRAuth.auth()?.currentUser?.displayName ?? "user"

//        imageView.sd_setImage(with: FIRAuth.auth()?.currentUser?.photoURL)
        imageView.sd_setImage(with: FIRAuth.auth()?.currentUser?.photoURL, placeholderImage: UIImage(named: "profileImage"))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        let gustuer = UITapGestureRecognizer(target: self, action: #selector(self.pickerUserPhoto))
        imageView.addGestureRecognizer(gustuer)
        imageView.isUserInteractionEnabled = true
        icarousel.delegate = self
        icarousel.dataSource = self
        icarousel.isPagingEnabled = true
        icarousel.bounces = false
        getData()
    }
    func pickerUserPhoto(){
        // The photo library is the default source, editing not allowed
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        present(picker, animated: true)
    }
    
    
    
    func getData(){
        let formItemsRef = FIRDatabase.database().reference(withPath: "ID/\(getUserId()!)/FormItems")
        formItemsRef.observe(.value, with: { (snapshot) in
            let json = JSON(snapshot.value)
            print(json.description)
            var formObjectList : [FormObject] = []
            for (key,value) in json.dictionaryValue {
                let formObject = FormObject(json: value , id: key)
                formObjectList.append(formObject)
                
            }
            self.formObjectList = formObjectList
            self.icarousel.reloadData()
            
        })
            
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        guard let uiImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        imageView.image = uiImage
        
        let uploadRef = storageRef.child("profilePicture/\(getUserId()!)/")
        
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        var data = Data()
        data = UIImageJPEGRepresentation(uiImage, 0.8)!
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        let uploadTask = uploadRef.put(data, metadata: metaData) { (metadata, error) in
            print(error.debugDescription)
            hud.hide(animated: true, afterDelay: 3)
            guard let metadata = metadata else {
                hud.label.text = "upload error"
                
                return
            }
            hud.label.text = "success"
            
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL()
            
//            let user = FIRAuth.auth()?.currentUser?.photoURL = metaData.downloadURL()
            let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
            changeRequest?.photoURL = downloadURL
            changeRequest?.commitChanges { (error) in
                if error == nil {
                    
                }
            }
            
            
            
        }
        uploadTask.resume()
        uploadTask.observe(.success) { snapshot in
            print("upload success")
        }
    }
    
        // MARK: - icarousel
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 2
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let collection = UICollectionView(frame: carousel.frame, collectionViewLayout: UICollectionViewFlowLayout.init())
        
        collection.register(UINib(nibName: "ClothCollectionCell", bundle: nil) , forCellWithReuseIdentifier: "ClothCollectionCell")
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = Color.grey.lighten4
        return collection
    }
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        hmSegment.selectedSegmentIndex = carousel.currentItemIndex
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCloth" {
            let addNewClothVC = segue.destination as! AddNewSellClothVC
            addNewClothVC.cloth = sender as! Cloth
        }
    }
    @IBAction func getSellCloth(segue : UIStoryboardSegue){
        if let newSellClothVC = segue.source as? AddNewSellClothVC {
            
            icarousel.reloadData()
        }
    }
    
}
extension ClothProfileVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        var count = 0
        for item in formObjectList {
            count += item.clothList.count
        }
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothCollectionCell", for: indexPath) as! ClothCollectionCell
        var clothList : [Cloth] = []
        for item in formObjectList {
            clothList += item.clothList
            if clothList.count == indexPath.row {
                let cloth = clothList[indexPath.row]
                cell.nameLabel.text = cloth.descr
                cell.clothImageView.sd_setImage(with: URL(string: cloth.imageListOnString.first ?? "") )
                cell.priceLabel.text = cloth.price.description
                break
            }
        }
        
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
        var clothList : [Cloth] = []
        for item in formObjectList {
            clothList += item.clothList
        }
        let cloth = clothList[indexPath.row]
        var count = 0
        for item in formObjectList {
            count += item.clothList.count
            if count >= indexPath.row {
                if item.status == .deliver || item.status == .waitForSend {
                    performSegue(withIdentifier: "selectCloth", sender: cloth)
                }else{
                    UIAlertController.showMsg(title: "only deliver , wait for send status can modify", msg: "")
                    let alert = UIAlertController(title: "only deliver , wait for send status can modifty", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                       self.performSegue(withIdentifier: "showFormObject", sender: nil)
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alert.addAction(okAction)
                    alert.addAction(cancelAction)
                    present(alert, animated: true, completion: nil)
                    
                    
                }
            }
        }
        
        
    }
}
