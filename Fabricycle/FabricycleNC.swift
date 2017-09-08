//
//  FabricycleNC.swift
//  Fabricycle
//
//  Created by Slin on 2017/9/3.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import Material
class FabricycleNC: UINavigationController {

    @IBInspectable open var itemLocalString : String = "unset"
    @IBInspectable open var itemIcon : UIImage = Icon.close!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = mainColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tabBarItem.title = itemLocalString.local
    }


    


}
