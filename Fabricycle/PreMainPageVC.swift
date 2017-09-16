//
//  PreMainPageVC.swift
//  Fabricycle
//
//  Created by Slin on 2017/9/16.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import Material
import HGCircularSlider
class PreMainPageVC: UIViewController {

    
    @IBOutlet weak var circlearSlider: CircularSlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    @IBAction func getNewForm(segue : UIStoryboardSegue){
        if segue.source.isKind(of: DeliverInfoVC.classForCoder()){
            
        }
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
