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
    
    @IBOutlet weak var recycleLabel: UILabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let icon = Icon.cm.arrowBack!.tint(with: Color.white)!
//        let image = UIImage(cgImage: icon.cgImage!, scale: 1.0, orientation: UIImageOrientation.up)
        
        rightArrowImageView.image = icon
        rightArrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat( Double.pi / 180 * 180));
        recycleNumberLabel.textColor = Color.white
        recycleLabel.textColor = Color.white
        bgView.backgroundColor = mainColor
//        contentView.shadowRadius = 12
        bgView.depthPreset = .depth3
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
