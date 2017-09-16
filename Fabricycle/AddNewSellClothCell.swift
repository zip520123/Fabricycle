//
//  AddNewSellClothCell.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/29.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import Material
class AddNewSellClothCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var selledLabel: UILabel!
    
    @IBOutlet weak var cameraImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cameraImageView.image = Icon.cm.add?.tint(with: mainColor)
        selledLabel.textColor = mainColor
        numberLabel.textColor = mainColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
