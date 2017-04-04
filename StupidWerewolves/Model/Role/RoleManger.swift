//
//  RoleManger.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/2/26.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit

let Default_Gamer_Num = 9
let Min_Gamer_Num = 9
let Max_Gamer_Num = 15

/**
 *  角色管理类, 用于创建游戏所需的角色信息
 */
class RoleManger: NSObject {

    private var godArray: [RoleModel] = [Witch.init(), Prophet.init(), Hunter.init(), Idiot.init()]
    
    // 获取神职数组
    private func configGodArray(num: Int) -> [RoleModel] {
        if num < godArray.count {
            let tempGod = godArray[0..<num]
            return Array(tempGod)
        }
        return godArray
    }
    
    // 获取狼人数组
    private func configWereWolfArray(num: Int) -> [RoleModel] {
        var wolves:[RoleModel] = []
        for _ in 0..<num {
            wolves.append(WereWolf.init())
        }
        return wolves
    }
    
    // 获取村民数组
    private func configVillagerArray(num: Int) -> [RoleModel] {
        
        var villagers:[RoleModel] = []
        for _ in 0..<num {
            villagers.append(Villager.init())
        }
        return villagers
    }
    
    // 暂时这么写, 写得好low
    // 配置角色数组并乱序
    func configRoleArray(config: GameConfig) -> [RoleModel] {
        
        let role: NSMutableArray = NSMutableArray()
        role.addObjects(from: configGodArray(num: config.godsNum))
        role.addObjects(from: configVillagerArray(num: config.villagersNum))
        role.addObjects(from: configWereWolfArray(num: config.wereWolvesNum))
        
        let roleArr = Array(role) as! [RoleModel]
        
        return roleArr.shuffle()
    }
}

// 乱序方法
extension Array {
    public func shuffle() -> Array {
        var list = self
        for index in 0..<list.count {
            let newIndex = Int(arc4random_uniform(UInt32(list.count-index))) + index
            if index != newIndex {
                swap(&list[index], &list[newIndex])
            }
        }
        return list
    }
}
