//
//  ClothObjectManager.swift
//  TPE2SFO
//
//  Created by zip520123 on 2017/7/29.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import SwiftyJSON

class ClothObject: NSObject {
    // MARK: - Properties
    
    let image : UIImage
    let json : JSON
    
    var imageURLString : String
    
    // Create a root reference
    
    var aleadyUpload = false
    
    let storageRef = storage.reference()
    
    init(image : UIImage , json : JSON) {
        
        self.image = image
        self.json = json
        self.imageURLString = ""
        // Data in memory
        
    }
    func getUserId()-> String?{
        if let user = FIRAuth.auth()?.currentUser{
            return user.uid
        }else{
            return nil
        }
    }
    func startUploadimage(){
        var data = Data()
        data = UIImageJPEGRepresentation(image, 0.6)!
        
        let uuidString = UUID().uuidString
        let imageName = "\(uuidString).jpg"
        
        // Create a reference to the file you want to upload
        let userId = getUserId()
        let riversRef = storageRef.child("images/\(userId!)/\(imageName)")
        
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        let uploadTask = riversRef.put(data, metadata: metaData) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL()

            self.imageURLString = downloadURL!.absoluteString
        }
        uploadTask.resume()
        uploadTask.observe(.success) { snapshot in
            print("upload success")
            // Upload completed successfully
        }
    }
    

}
