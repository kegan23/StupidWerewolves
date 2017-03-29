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
    
    let roles: Array<RoleModel>!    // 身份数组
    let numConfig: GameConfig!      // 游戏设置
    var flows: Array<GameFlow>!     // 游戏流程
    
    var sergeant: IndexPath?        // 警长
    
    required init(config: GameConfig) {
        
        roles = RoleManger.sharedManager.configRoleArray(config: config)
        numConfig = config
        flows = GameManager.configGameFlow(config: config)
    }
}
