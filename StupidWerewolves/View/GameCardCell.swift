//
//  GameCardCell.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/3/22.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit

class GameCardCell: UICollectionViewCell {
    
    @IBOutlet var cardLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardLbl.layer.cornerRadius = 8
        cardLbl.layer.masksToBounds = true
    }
}
