//
//  MenuVC.swift
//  Fabricycle
//
//  Created by Slin on 2017/9/16.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import LGSideMenuController
class MenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func logoutButtonClick(_ sender: Any) {
        sideMenuController!.hideLeftView()
        try! FIRAuth.auth()!.signOut()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func FabricycleButtonClick(_ sender: Any) {//preMainRoot
        let preMainRoot = self.storyboard!.instantiateViewController(withIdentifier: "preMainRoot")
//        sideMenuController?.rootViewController.setViewControllers([preMainRoot], animated: false)
        let fNC = sideMenuController!.rootViewController as? FabricycleNC
        fNC?.setViewControllers([preMainRoot], animated: false)
//        sideMenuController!.rootViewController = preMainRoot
        fNC?.setBarUI()
        fNC?.setMenuItem()
        fNC?.setProfileImte()
        sideMenuController!.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
    }
 
    @IBAction func History(_ sender: Any) {
        let history = self.storyboard!.instantiateViewController(withIdentifier: "History")
        sideMenuShowVC(vc: history)
    }
    
    @IBAction func Setting(_ sender: Any) {
    }

    @IBAction func aboutUs(_ sender: Any) {
        let aboutVC = UIStoryboard.init(name: "About", bundle: nil).instantiateInitialViewController() as! AboutVC
        aboutVC.title = "About"
        sideMenuShowVC(vc: aboutVC)
    }
    func sideMenuShowVC(vc : UIViewController){
        let fNC = sideMenuController!.rootViewController as? FabricycleNC
        fNC?.setViewControllers([vc], animated: false)
        fNC?.setBarUI()
        fNC?.setMenuItem()
        fNC?.navigationItem.setRightBarButton(nil, animated: true)
        sideMenuController!.hideLeftView(animated: true, delay: 0.0 , completionHandler: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

}
