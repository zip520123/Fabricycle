//
//  FormObject.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/20.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import Foundation
import SwiftyJSON
class FormObject {
    enum statusEnum : String {
        case deliver
        case waitForSend
        case sending
        case review
        case accept
        case error
        func toString()->String {
            switch self {
            case .deliver:
                return "Processing"
            case .waitForSend :
                return "On The Way"
            case .sending :
                return "Delivering"
            case .review :
                return "Reviewing"
            case .accept:
                return "Finished"
            default:
                return "error"
            }
        }
    }
    enum TransferType : String{
        case unset
        case conviniateMarket
        case gotoHomerecive
    }

    var recycleClothNumber : Int
    var userName : String
    var phoneNumber : String
    var address : String
    var clothList : [Cloth]
    
    var status : statusEnum
    var ref: FIRDatabaseReference?
    var transferType : TransferType
    
    var deliverTimeScale : String
    var uid = "0"
    init(clothList : [Cloth]) {
        self.clothList = clothList
        self.ref = nil
        self.status = .deliver
        
        recycleClothNumber = 0
        userName = UserDefaults.standard.getUserName()
        phoneNumber = UserDefaults.standard.getUserPhone()
        address = UserDefaults.standard.getUserAddress()
        
        transferType = .unset
        deliverTimeScale = "unset"
    }
    init(snapshot: FIRDataSnapshot , id: String ){
        let json = JSON(snapshot.value)
        self.uid = id
        self.status = FormObject.statusEnum(rawValue: json["status"].stringValue) ?? .error
        self.userName = json["userName"].stringValue
        self.phoneNumber = json["phoneNumber"].stringValue
        self.address = json["address"].stringValue
        self.transferType = FormObject.TransferType(rawValue: json["tensfarType"].stringValue) ?? .unset
        self.recycleClothNumber = json["recycleClothNumber"].intValue
        self.deliverTimeScale = json["deliverTimeScale"].stringValue
        var clothList : [Cloth] = []

        let cloths = snapshot.childSnapshot(forPath: "cloths")

        for subrest in cloths.children.allObjects as! [FIRDataSnapshot] {
            guard let restDict = subrest.value as? [String : Any] else {continue}
            let cloth = Cloth(json: JSON(restDict), ref: subrest.ref)
            clothList.append(cloth)
        }

        self.clothList = clothList
        self.ref = snapshot.ref
    }
    
//    init(snapshot: FIRDataSnapshot , id : String) {
//        let json = JSON(snapshot.value)
//        self.uid = id
//        self.status = FormObject.statusEnum(rawValue: json["status"].stringValue) ?? .error
//        self.userName = json["userName"].stringValue
//        self.phoneNumber = json["userPhone"].stringValue
//        self.address = json["userAddress"].stringValue
//        self.transferType = FormObject.TransferType(rawValue: json["tensfarType"].stringValue) ?? .unset
//        self.recycleClothNumber = json["recycleClothNumber"].intValue
//        self.deliverTimeScale = json["deliverTimeScale"].stringValue
//        var clothList : [Cloth] = []
//        for (_ ,jsonCloth) in json["cloths"].dictionaryValue {
//            let cloth = Cloth(json: jsonCloth)
//            clothList.append(cloth)
//        }
//        self.clothList = clothList
//        self.ref = snapshot.ref
//    }
    
    func returnFormForFireBase()->Any{
        return [ "status" : status.rawValue ,
                 "userName" : userName ,
                 "phoneNumber" : phoneNumber ,
                 "address" : address ,
                 "transferType" : transferType.rawValue ,
                 "recycleClothNumber" : recycleClothNumber ,
                 "deliverTimeScale" : deliverTimeScale
                ]
    }
    class func getFormObjectList(block : @escaping ([FormObject])->Void) {
        let formItemsRef = FIRDatabase.database().reference(withPath: "ID/\(getUserId()!)/FormItems")
        formItemsRef.observe(.value, with: { (snapshot) in
            
            var formObjectList : [FormObject] = []
            
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                
                let formObject = FormObject(snapshot: rest, id: rest.key)
                formObjectList.append(formObject)
            }
            block(formObjectList)

            
        })
    }


}
