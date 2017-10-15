//
//  AddNewSellClothVC.swift
//  Fabricycle
//
//  Created by Slin on 2017/9/2.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import iCarousel
import Material
import MBProgressHUD
import ActionSheetPicker_3_0
class AddNewSellClothVC: UIViewController ,UIImagePickerControllerDelegate{
    
    
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var camerView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var takeCameraButton: UIView!
    @IBOutlet weak var doneButton: UIButton!
    var cloth : Cloth!
    
    let cellString = ["Price" , "Color" , "Gender" , "Size" , "Description"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        camerView.image = Icon.cm.photoCamera?.tint(with: Color.white)
        if cloth == nil {
            cloth = Cloth()
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        carousel.delegate = self
        carousel.dataSource = self
        carousel.isPagingEnabled = true
        carousel.clipsToBounds = true
        carousel.reloadData()
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
        if cloth.ref == nil {
            self.cloth.imageList.append(uiImage)
            if cloth.imageList.count > 3 {_ = cloth.imageList.removeFirst()}
            carousel.reloadData()
        }else {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            var data = Data()
            data = UIImageJPEGRepresentation(uiImage, 0.6)!
            
            let uuidString = UUID().uuidString
            let imageName = "\(uuidString).jpg"
            
            // Create a reference to the file you want to upload
            
            let riversRef = storageRef.child("images/\(getUserId()!)/\(imageName)")
            
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            let uploadTask = riversRef.put(data, metadata: metaData) { (metadata, error) in
                print(error.debugDescription)
                hud.hide(animated: true)
                guard let metadata = metadata else {
                    
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata.downloadURL()
                let urlString = downloadURL!.absoluteString
                self.cloth.imageListOnString.append(urlString)
                if self.cloth.imageListOnString.count > 3 {
                    let firstImage = self.cloth.imageListOnString.removeFirst()
                    if let url = URL(string : firstImage ) {
                        
                        let imageRef = storageRef.child("images/\(getUserId()!)/\(url.lastPathComponent)")
                        imageRef.delete(completion: { (error) in
                            print("delete image error:\(error?.localizedDescription)")
                        })
                    }
                }
                self.cloth.ref!.updateChildValues(self.cloth.returnUrlForFireBase() as! [AnyHashable : Any]){_ in}
                self.carousel.reloadData()
            }
            uploadTask.resume()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectClothPrice" {
            let vc = segue.destination as! SelectClothPriceVC
            vc.price = cloth.price
            vc.selectPriceBlock = { price in
                self.getPrice(price)
                self.cloth.ref!.updateChildValues(self.cloth.returnUrlForFireBase() as! [AnyHashable : Any]){_ in}
            }
        }
        if segue.identifier == "editVC" {
            let vc = segue.destination as! EditClothDescriptionVC
            vc.descr = cloth.descr
            vc.editBlock = { text in
                self.getClothDescription(text)
                self.cloth.ref!.updateChildValues(self.cloth.returnUrlForFireBase() as! [AnyHashable : Any]){_ in}
            }
        }
    }

}
extension AddNewSellClothVC: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 80
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
            cell.detailTextLabel?.textColor = Color.grey.lighten1
            cell.textLabel?.text = cellString[indexPath.row]
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.detailTextLabel?.text = "\(cloth.color)"
            cell.textLabel?.text = cellString[indexPath.row]
            cell.detailTextLabel?.textColor = Color.grey.lighten1
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.detailTextLabel?.text = "\(cloth.gender)"
            cell.textLabel?.text = cellString[indexPath.row]
            cell.detailTextLabel?.textColor = Color.grey.lighten1
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.detailTextLabel?.text = "\(cloth.size)"
            cell.textLabel?.text = cellString[indexPath.row]
            cell.detailTextLabel?.textColor = Color.grey.lighten1
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "description", for: indexPath) as! AddNewSellClothDescriptionCell
            cell.descriptionLabel.textColor = Color.grey.lighten1
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        if indexPath.row == 0 {
            performSegue(withIdentifier: "selectClothPrice", sender: nil)
            return
        }
        
        let title = cellString[indexPath.row]
        var selectRow : [String] = [""]
        
        switch indexPath.row {
        case 1:
            selectRow = ["red" , "blue" , "yellow" , "white" , "black" , "green" , "brown" , "Purple", "grey" ,"other"]
        case 2:
            selectRow = ["male" , "female" , "none"]
        case 3:
            selectRow = ["S" , "M" , "L" , "Free"]
        default:
            break
        }
        switch indexPath.row {
        case 1,2,3:
            ActionSheetMultipleStringPicker.show(withTitle: title, rows: [selectRow], initialSelection: [selectRow.count], doneBlock: {
                picker, indexes, values in
                switch indexPath.row {
                case Cloth.selectType.color.rawValue:
                    self.cloth.color = selectRow[(indexes as! [Int])[0]]
                    
                case Cloth.selectType.gender.rawValue:
                    self.cloth.gender = selectRow[(indexes as! [Int])[0]]
                case Cloth.selectType.size.rawValue:
                    self.cloth.size = selectRow[(indexes as! [Int])[0]]
                default:
                    break
                }
                
                print("values = \(values)")
                print("indexes = \(indexes)")
                print("picker = \(picker)")
                self.tableView.reloadData()
                
                return
            }, cancel: { ActionMultipleStringCancelBlock in return }, origin: self.view)
        default:
            break
        }

        
      
    }
}
extension AddNewSellClothVC: iCarouselDelegate , iCarouselDataSource {
    public func numberOfItems(in carousel: iCarousel) -> Int {
        
        
        if cloth.ref == nil {
            pageControl.numberOfPages = cloth.imageList.count
            return cloth.imageList.count
        }else {
            pageControl.numberOfPages = cloth.imageListOnString.count
            return cloth.imageListOnString.count
        }
        
        
    }

    public func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
//        let imageView = UIImageView(image: cloth.imageList[index])
        let imageView = UIImageView()
        imageView.frame = carousel.frame
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        if cloth.ref == nil {
            imageView.image = cloth.imageList[index]
        }else {
            imageView.sd_setImage(with: URL(string : cloth.imageListOnString[index] ), placeholderImage: Icon.cameraFront?.tint(with: Color.white))
        }
        
        
        return imageView
    
    }
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel){
        pageControl.currentPage = carousel.currentItemIndex
    }

}
