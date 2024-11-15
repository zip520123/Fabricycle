//
//  Cloth.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/20.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import Foundation
import SwiftyJSON
import SDWebImage
let storage = FIRStorage.storage()
let storageRef = storage.reference()
class Cloth : NSObject {
    enum selectType : Int {
        case color = 1
        case gender
        case size
    }
    var imageList : [UIImage]!
    var imageListOnString = [String]()
    var uploadStats = false
    var sold = false
    var selling = false
    var price = 0
    var descr : String
    
    var color : String
    var gender : String
    var size : String
    
    var ref: FIRDatabaseReference?
    var json: JSON?
    override init() {
        self.imageList = []
        self.imageListOnString = [String]()
        self.color = ""
        self.gender = ""
        self.size = ""
        self.uploadStats = false
 
        self.descr = "cloth name"
    }
    init(json : JSON , ref : FIRDatabaseReference? ){
        self.json = json
        self.imageList = []
        self.price = json["price"].intValue
        self.descr = json["descr"].stringValue
        self.color = json["color"].stringValue
        self.gender = json["gender"].stringValue
        self.size = json["size"].stringValue
        self.sold = json["sold"].boolValue
        self.selling = json["selling"].boolValue
        var clothURLs : [String] = []
        for item in json["clothURL"].arrayValue {
            clothURLs.append(item.stringValue)
            
            
        }
        self.imageListOnString = clothURLs
        self.uploadStats = false
        self.ref = ref
        super.init()
        donwloadimage()

    }
    func donwloadimage(){
        for item in imageListOnString {
            let url = URL(string: item)
            SDWebImageDownloader.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, data, error, bool) in
                if error == nil && image != nil {
                    self.imageList.append(image!)
                }
                
            })
        }
        
    }

    func returnUrlForFireBase()->Any{
        
        return [ "price" : price ,
                 "descr" : descr ,
                 "clothURL" : imageListOnString ,
                 "color" : color ,
                 "gender" : gender ,
                 "size" : size ,
                 "sold" : sold,
                 "selling" : selling
        ]
    }
//    init(snapshot: FIRDataSnapshot) {
//        ref = snapshot.ref
//        let json = JSON(snapshot.value) as! [String: AnyObject]
//        imageListOnString = json["imageListOnString"]?.array
//        key = snapshot.key
//        let snapshotValue = snapshot.value as! [String: AnyObject]
//        name = snapshotValue["name"] as! String
//        addedByUser = snapshotValue["addedByUser"] as! String
//        completed = snapshotValue["completed"] as! Bool
//        ref = snapshot.ref
//    }
    func removeExistImage(){
        for item in imageListOnString {
            print("image :\(item)")
            if let url = URL(string : item ) {
                
                let imageRef = storageRef.child("images/\(getUserId()!)/\(url.lastPathComponent)")
                imageRef.delete(completion: { (error) in
                    print("delete image error:\(error?.localizedDescription)")
                })
            }
            
        }
    }
    func uploadAllImage(block : @escaping ()->Void){
        var uploadCount = 0
        var tempString = [String]()
        removeExistImage()
        if imageList.count == 0 {
            self.imageListOnString = tempString
            allUploadSuccess(block)
            return
        }
        
        for image in self.imageList {
            var data = Data()
            data = UIImageJPEGRepresentation(image, 0.6)!
            
            let uuidString = UUID().uuidString
            let imageName = "\(uuidString).jpg"
            
            // Create a reference to the file you want to upload

            let riversRef = storageRef.child("images/\(getUserId()!)/\(imageName)")
            
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            let uploadTask = riversRef.put(data, metadata: metaData) { (metadata, error) in
                print(error.debugDescription)
                guard let metadata = metadata else {

                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata.downloadURL()
                let urlString = downloadURL!.absoluteString
                tempString.append(urlString)
                uploadCount += 1
                if uploadCount == self.imageList.count {
                    self.imageListOnString = tempString
                    self.allUploadSuccess(block)
                }

            }
            uploadTask.resume()
            uploadTask.observe(.success) { snapshot in
                print("upload success")
            }
        }
    }
    private func allUploadSuccess(_ block : ()->Void){
        for (index, item) in self.imageListOnString.enumerated() {
            print("cloth:\(index) , string: \(item)")
        }
        block()
        print("all Upload Success")
    }


    
}
