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
class ClothProfileVC: UIViewController , iCarouselDelegate , iCarouselDataSource{
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
        let gustuer = UITapGestureRecognizer(target: self, action: #selector(self.pickerUserPhoto))
        imageView.addGestureRecognizer(gustuer)
        
        icarousel.delegate = self
        icarousel.dataSource = self
        icarousel.isPagingEnabled = true
        icarousel.bounces = false
        getData()
    }
    func pickerUserPhoto(){
        
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
        }
        let cloth = clothList[indexPath.row]

        
        cell.nameLabel.text = cloth.descr
        cell.clothImageView.sd_setImage(with: URL(string: cloth.imageListOnString.first ?? "") )
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
        var clothList : [Cloth] = []
        for item in formObjectList {
            clothList += item.clothList
        }
        let cloth = clothList[indexPath.row]
        performSegue(withIdentifier: "selectCloth", sender: cloth)
        
    }
}
