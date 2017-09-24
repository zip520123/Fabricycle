//
//  FabricycleNC.swift
//  Fabricycle
//
//  Created by Slin on 2017/9/3.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import Material
import LGSideMenuController
class FabricycleNC: UINavigationController {

    @IBInspectable open var itemLocalString : String = "unset"
    @IBInspectable open var itemIcon : UIImage = Icon.close!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = mainColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        


        
        
        setProfileImte()
        setMenuItem()
        navigationBar.isTranslucent = true
        setBarUI()
        navigationBar.shadowImage = UIImage()
        
    }
    func setMenuItem(){
        let menuItem = UIBarButtonItem(image: Icon.menu, style: .plain, target: self, action: #selector(self.showLGmenu))
        self.visibleViewController?.navigationItem.setLeftBarButton(menuItem, animated: true)
    }
    func setProfileImte(){
        let profileItem = UIBarButtonItem(image: UIImage(named: "profileImage"), style: .plain, target: self, action: nil)
        self.visibleViewController?.navigationItem.setRightBarButton(profileItem, animated: true)
    }
    func showLGmenu(){
        showLeftViewAnimated(nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tabBarItem.title = itemLocalString.local
    }


    override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        setBarUI()
        return vc
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        super.pushViewController(viewController, animated: animated)
        setBarUI()
    }
    func setBarUI(){
        if (self.visibleViewController is PreMainPageVC || self.visibleViewController is AddNewRecycleNumber) {
            
            navigationBar.setBackgroundImage(UIImage(), for: .default)
        }else{
            navigationBar.setBackgroundImage(UIImage().tint(with: mainColor), for: .default)
        }
    }

}
