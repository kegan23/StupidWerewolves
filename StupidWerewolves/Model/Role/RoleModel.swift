//
//  RoleModel.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/2/26.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit

enum RoleType: String {
    
    case WereWolf   = "狼人"
    case Villager   = "村民"
    case Witch      = "女巫"
    case Prophet    = "预言家"
    case Hunter     = "猎人"
    case Idiot      = "白痴"
    case Guard      = "守卫"
}

enum CampType {
    case God        // 神民
    case Humen      // 平民
    case Wolf       // 狼人
    
}

/**
 *  角色模型, 游戏必须
 */
class RoleModel: NSObject {

    var hasDead: Bool = false
    
}

class God: RoleModel {
    let camp: CampType = .God
}

class Human: RoleModel {
    let camp: CampType = .Humen
}

class Wolf: RoleModel {
    let camp: CampType = .Wolf
    
    // 刀
    func kill() {
        
    }
}

//MARK: - 神民
// 女巫
class Witch: God {
    
    let role: RoleType = .Witch
    
    var hasPotion: Bool = true  // 是否有救药
    var hasPoison: Bool = true  // 是否有毒药
    
    // 救
    func potion() {
        
    }
    
    // 毒
    func poison() {
        
    }
}

// 猎人
class Hunter: God {
    
    let role: RoleType = .Hunter
    
    var canShoot: Bool = true   // 是否能开枪
    
    // 枪
    func shoot() {
        
    }
}

// 白痴
class Idiot: God {
    
    let role: RoleType = .Idiot
    
    var skilled: Bool = false   // 是否翻牌（投票）
}

// 预言家
class Prophet: God {
    
    let role: RoleType = .Prophet
    
    // 验
    func check() {
        
    }
}

//MARK: - 平民
class Villager: Human {
    
    let role: RoleType = .Villager
}

//MARK: - 狼人
class WereWolf: Wolf {
    
    let role: RoleType = .WereWolf
}
