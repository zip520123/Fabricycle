//
//  AddNewSellClothDescriptionCell.swift
//  Fabricycle
//
//  Created by Slin on 2017/9/2.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import Material
class AddNewSellClothDescriptionCell: UITableViewCell {

    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rightImageView.image = Icon.cm.arrowDownward?.tint(with: Color.grey.lighten1)
    
    }

}
