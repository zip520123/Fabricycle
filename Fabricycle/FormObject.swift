//
//  FormObject.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/20.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import Foundation
import SwiftyJSON
struct FormObject {
    enum statusEnum : String {
        case start
        
    }
    var clothList : JSON = [:]
    var status : String
    var ref: FIRDatabaseReference?
    
    
    init(clothList : JSON) {
        self.clothList = clothList
        self.ref = nil
        self.status = ""
    }
    init(snapshot: FIRDataSnapshot) {
//        key = snapshot.key
//        let snapshotValue = snapshot.value as! [String: AnyObject]
//        name = snapshotValue["name"] as! String
//        addedByUser = snapshotValue["addedByUser"] as! String
//        completed = snapshotValue["completed"] as! Bool
        let snapshotValue = snapshot.value as! [String: AnyObject]
        status = snapshotValue["status"] as! String
//        clothList = snapshotValue["clothList"] as! [JSON]
        clothList = JSON([:])
//        self.clothList = snapshot.value as! [String : AnyObject]
        ref = snapshot.ref
    }
    func toAnyObject() -> Any {
        return [
            "stauts" : status,
            "clothList" : clothList.dictionaryValue
        ]
//        return [
//            "name": name,
//            "addedByUser": addedByUser,
//            "completed": completed
//        ]
    }
}
