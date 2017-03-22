//
//  GameFlow.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/3/22.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit

enum GameFlowType: String {
    
    case guardSomebody          = "守卫请守人"
    case werewolfKill           = "狼人请杀人"
    case witchCureOrPoison      = "女巫请用药"
    case prophetCheck           = "预言家请验人"
    case hunterCanShootOrNot    = "猎人请睁眼"
}

/**
 *  游戏流程类, 通过游戏管理类进行不同的游戏操作
 */
class GameFlow: NSObject {

    var flowType: GameFlowType!  // 流程类型
    
    required init(type: GameFlowType) {
        flowType = type
    }
    
}
