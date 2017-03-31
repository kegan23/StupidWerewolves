//
//  GameModel.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/2/26.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit


/**
 *  游戏模型类, 通过游戏管理类进行游戏流程
 */
class GameModel: NSObject {
    
    var roles: Array<RoleModel>!    // 身份数组
    let numConfig: GameConfig!      // 游戏设置
    var flows: Array<GameFlow>!     // 游戏流程
    
    var sergeant: IndexPath?        // 警长
    var hasLastWords: Bool = true   // 是否有遗言
    
    required init(config: GameConfig) {
        
        roles = RoleManger.sharedManager.configRoleArray(config: config)
        for (i, role) in roles.enumerated() {
            role.numberCard = "\(i + 1)"
            print("\(role.numberCard)号：\(role.role.rawValue)")
        }
        
        numConfig = config
        flows = GameManager.configGameFlow(config: config)
    }
}
