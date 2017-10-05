//
//  FabricycleTabBarC.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/28.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import Material
class FabricycleTabBarC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = mainColor
        setUpBarImage()
    }
    
    func setUpBarImage(){
        let bottomIconList = [Icon.cm.menu!,Icon.cm.settings!]
        for (index,item) in tabBar.items!.enumerated() {
            item.image = bottomIconList[index]
        }
    }
    


}
