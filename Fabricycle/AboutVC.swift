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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
