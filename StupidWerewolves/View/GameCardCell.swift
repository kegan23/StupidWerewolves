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
    @IBOutlet var statusLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardLbl.layer.cornerRadius = 8
        cardLbl.layer.masksToBounds = true
        
    }
    
    func forbiddenCell() {
        cardLbl.backgroundColor = UIColor.lightGray
        self.isUserInteractionEnabled = false
    }
    
    func enabledCell() {
        cardLbl.backgroundColor = UIColor.groupTableViewBackground
        self.isUserInteractionEnabled = true
    }
    
    func addDeadStatus() {
        statusLbl.text = "☠️"
    }
    
    func addSergeantStatus() {
        statusLbl.text = "🎖"
    }
    
    func removeStatus() {
        statusLbl.text = ""
    }
}
