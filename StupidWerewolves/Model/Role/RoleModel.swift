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
    var role: RoleType!
    
    required init(type: RoleType) {
        role = type
    }
}

//MARK: - 神民
// 女巫
class Witch: RoleModel {
    
//    let role: RoleType = .Witch
    
    var hasPotion: Bool = true  // 是否有救药
    var hasPoison: Bool = true  // 是否有毒药
    
    let camp: CampType = .God
    
    convenience init() {
        self.init(type: .Witch)
    }
    
    required init(type: RoleType) {
        super.init(type: type)
    }
    
    // 救
    func potion() {
        
    }
    
    // 毒
    func poison() {
        
    }
}

// 猎人
class Hunter: RoleModel {
    
    var canShoot: Bool = true   // 是否能开枪
    
    let camp: CampType = .God
    
    convenience init() {
        self.init(type: .Hunter)
    }
    
    required init(type: RoleType) {
        super.init(type: type)
    }
    
    // 枪
    func shoot() {
        
    }
}

// 白痴
class Idiot: RoleModel {
    
    var skilled: Bool = false   // 是否翻牌（投票）
    
    let camp: CampType = .God
    
    convenience init() {
        self.init(type: .Idiot)
    }
    
    required init(type: RoleType) {
        super.init(type: type)
    }

}

// 预言家
class Prophet: RoleModel {
    
    let camp: CampType = .God
    
    convenience init() {
        self.init(type: .Prophet)
    }
    
    required init(type: RoleType) {
        super.init(type: type)
    }

    // 验
    func check() {
        
    }
}

//MARK: - 平民
class Villager: RoleModel {
    
    let camp: CampType = .Humen
    
    convenience init() {
        self.init(type: .Villager)
    }
    
    required init(type: RoleType) {
        super.init(type: type)
    }

}

//MARK: - 狼人
class WereWolf: RoleModel {
    
    let camp: CampType = .Wolf
    
    convenience init() {
        self.init(type: .WereWolf)
    }
    
    required init(type: RoleType) {
        super.init(type: type)
    }
}
