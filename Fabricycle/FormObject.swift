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
    }
    init(json : JSON , id: String){
        self.uid = id
        self.status = FormObject.statusEnum(rawValue: json["status"].stringValue) ?? .error
        self.userName = json["userName"].stringValue
        self.phoneNumber = json["userPhone"].stringValue
        self.address = json["userAddress"].stringValue
        self.transferType = FormObject.TransferType(rawValue: json["tensfarType"].stringValue) ?? .unset
        self.recycleClothNumber = json["recycleClothNumber"].intValue
        var clothList : [Cloth] = []
        for (_ ,jsonCloth) in json["cloths"].dictionaryValue {
            let cloth = Cloth(json: jsonCloth)
            clothList.append(cloth)
        }
        self.clothList = clothList
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot , id : String) {
        let json = JSON(snapshot.value)
        self.uid = id
        self.status = FormObject.statusEnum(rawValue: json["status"].stringValue) ?? .error
        self.userName = json["userName"].stringValue
        self.phoneNumber = json["userPhone"].stringValue
        self.address = json["userAddress"].stringValue
        self.transferType = FormObject.TransferType(rawValue: json["tensfarType"].stringValue) ?? .unset
        self.recycleClothNumber = json["recycleClothNumber"].intValue
        var clothList : [Cloth] = []
        for (_ ,jsonCloth) in json["cloths"].dictionaryValue {
            let cloth = Cloth(json: jsonCloth)
            clothList.append(cloth)
        }
        self.clothList = clothList
//        key = snapshot.key
//        let snapshotValue = snapshot.value as! [String: AnyObject]
//        name = snapshotValue["name"] as! String
//        addedByUser = snapshotValue["addedByUser"] as! String
//        completed = snapshotValue["completed"] as! Bool
//        let snapshotValue = snapshot.value as! [String: AnyObject]
//        status = snapshotValue["status"] as! String
//        clothList = snapshotValue["clothList"] as! [JSON]
//        clothList = JSON([:])
//        self.clothList = snapshot.value as! [String : AnyObject]
        self.ref = snapshot.ref
    }
//    func toAnyObject() -> Any {
//        return [
//            "stauts" : status,
//            "clothList" : clothList.dictionaryValue
//        ]
//
//    }

}
