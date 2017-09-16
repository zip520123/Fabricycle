//
//  ClothCollectionCell.swift
//  Fabricycle
//
//  Created by zip520123 on 2017/8/20.
//  Copyright © 2017年 zip520123. All rights reserved.
//

import UIKit
import Material
class ClothCollectionCell: UICollectionViewCell {
    @IBOutlet weak var clothImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dotdotdotImage: UIImageView!
    
    override func awakeFromNib() {
        dotdotdotImage.image = Icon.cm.moreVertical?.tint(with: Color.grey.lighten1)
        bgView.depthPreset = .depth2
        nameLabel.textColor = Color.grey.lighten1
        
        nameLabel.text = ""
        priceLabel.text = "0"
        
        
    }
}
