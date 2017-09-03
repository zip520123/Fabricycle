//
//  Cloth.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/20.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import Foundation
import SwiftyJSON
let storage = FIRStorage.storage()
let storageRef = storage.reference()
class Cloth : NSObject{
    let ref: FIRDatabaseReference?
    var imageList : [UIImage]!
    var imageListOnString = [String]()
    var uploadStats = false
    let userId : String
    var price = 0
    
    override init() {
        self.imageList = []
        self.imageListOnString = [String]()
        self.ref = nil
        self.uploadStats = false
        self.userId = getUserId()!
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
    func uploadAllImage(block : @escaping ()->Void){
        var uploadCount = 0
        var tempString = [String]()
        for image in self.imageList {
            var data = Data()
            data = UIImageJPEGRepresentation(image, 0.6)!
            
            let uuidString = UUID().uuidString
            let imageName = "\(uuidString).jpg"
            
            // Create a reference to the file you want to upload

            let riversRef = storageRef.child("images/\(userId)/\(imageName)")
            
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
