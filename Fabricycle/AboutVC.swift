//
//  AboutVC.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/10/9.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = version()
        
    }
    func version() -> String {
        
        var string = ""
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        string = "\(version) (\(build))"
        
        #if DEBUG
            let debug = " debug"
            string.append(debug)
        #else
//            let apiKey = "KEY_B"
        #endif
        return string
    }


}
