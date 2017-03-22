//
//  GameConfig.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/2/26.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit

enum GameType {
    case Standard       // 标准局：天黑-狼人-女巫-预言家-猎人
    //    case Special       // 三方阵营
}

/**
 *  游戏配置类, 用于配置游戏模型
 */
class GameConfig: NSObject {

    // 游戏类型
    var gameType: GameType!
    // 总人数
    var gamerNum: Int = 0 {
        didSet {
            if gameType == .Standard {
                // 标准局
                wereWolvesNum = gamerNum / 3
                godsNum = wereWolvesNum
                villagersNum = gamerNum - godsNum - wereWolvesNum
            }
        }
    }
    
    var wereWolvesNum: Int!     // 狼人人数
    var godsNum: Int!           // 神职人数
    var villagersNum: Int!      // 村民人数
//    var othersNum: Int!         // 第三方人数
    
    required init(type: GameType) {
        
        gameType = type
//        gamerNum = totalNum
    }
    
}
