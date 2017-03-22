//
//  GameManager.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/3/16.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit

/**
 *  游戏管理类，用于处理游戏信息和游戏流程
 */
class GameManager: NSObject {

    var model: GameModel!        // 游戏模型
    var currentFlow: GameFlow?   // 当前流程
    
    required init(model: GameModel) {
        self.model = model
    }
    
    class func configGameFlow(config: GameConfig) -> Array<GameFlow>? {
        
        if config.gameType == .Standard {
            var flows:[GameFlow] = []
            flows.append(GameFlow.init(type: .hunterCanShootOrNot))
            flows.append(GameFlow.init(type: .prophetCheck))
            flows.append(GameFlow.init(type: .witchCureOrPoison))
            flows.append(GameFlow.init(type: .werewolfKill))
            return flows
        }
        return nil
    }
    
    /**
     *  @brief 流程开始
     *
     *  @return 流程名(若为空则无流程)
     */
    func flowStart() -> String? {
        
        if model.flows.count > 0 {
            
            if let flow = model.flows.first {
                
                currentFlow = flow
                if flow.flowType == GameFlowType.guardSomebody {
                    
                } else if flow.flowType == GameFlowType.werewolfKill {
                    
                } else if flow.flowType == GameFlowType.witchCureOrPoison {
                    
                } else if flow.flowType == GameFlowType.prophetCheck {
                    
                } else if flow.flowType == GameFlowType.hunterCanShootOrNot {
                    
                }
                model.flows.removeFirst()
                return flow.flowType.rawValue
            }
        }
        return nil
    }
    
    /**
     *  @brief 处理信息
     *
     *  @param role 角色
     */
    func handler(role: RoleModel) {
        
    }
}
