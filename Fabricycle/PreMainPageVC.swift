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
import SwiftyJSON
class PreMainPageVC: UIViewController {

    @IBOutlet weak var sellNumber: UILabel!
    
    @IBOutlet weak var recycledLabel: UILabel!
    @IBOutlet weak var recycleCountLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var labelLevelNumber: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var beamImageView: UIImageView!
    @IBOutlet weak var circlearSlider: CircularSlider!
    var formList : [FormObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetAllLabel()
        getData()
        setCircular()
    }
    func setCircular(){
        circlearSlider.isUserInteractionEnabled = false
        
    }
    func getData(){
        
        FormObject.getFormObjectList { (formList) in
            self.formList = formList
            var recycleCount = 0
            var sellCount = 0
            for form in formList{
                recycleCount += form.recycleClothNumber
                sellCount += form.clothList.count
            }
            self.recycleCountLabel.text = "\(recycleCount)"
            self.sellNumber.text = "\(sellCount)"
            var recycleCountLabelTest = ""
            var discriptionText = ""
            
            if recycleCount < 10 {
                recycleCountLabelTest = recycleCount.description + " / 10"
//                discriptionText = "Let's start to save the earth"
                self.beamImageView.image = UIImage(named: "beam")
                self.circlearSlider.minimumValue = 0
                self.circlearSlider.maximumValue = 10
                self.circlearSlider.endPointValue = CGFloat(recycleCount)
                
                
            }else if recycleCount >= 10 && recycleCount < 100{
                recycleCountLabelTest = recycleCount.description + " / 100"
//                discriptionText = "You've saved more than 20 trees"
                self.beamImageView.image = UIImage(named: "slap")
                self.circlearSlider.minimumValue = 0
                self.circlearSlider.maximumValue = 100
                self.circlearSlider.endPointValue = CGFloat(recycleCount)
                
            }else if recycleCount >= 100 {
//                discriptionText = "You've saved more than 500 trees"
                recycleCountLabelTest = recycleCount.description + " / 1000"
                self.beamImageView.image = UIImage(named: "tree")
                self.circlearSlider.minimumValue = 0
                self.circlearSlider.maximumValue = 1000
                self.circlearSlider.endPointValue = CGFloat(recycleCount)
            }
            self.labelLevelNumber.text = "\(recycleCountLabelTest)"
            self.discriptionLabel.text = discriptionText
        }
        

    }
    
    func resetAllLabel(){
        recycleCountLabel.text = "0"
        sellNumber.text = "0"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
