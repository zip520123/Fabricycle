//
//  RecycleClothNumberCell.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/29.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import Material
class RecycleClothNumberCell: UITableViewCell {

    @IBOutlet weak var recycleNumberLabel: UILabel!
    
    @IBOutlet weak var rightArrowImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        rightArrowImageView.image = Icon.cm.arrowBack?.tint(with: Color.grey.darken4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
