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

    var model: GameModel!           // 游戏模型
    var oneDay: GameOneDayModel?    // 游戏一天数据
    
    private var currentFlow: GameFlow?      // 当前流程
    
    required init(model: GameModel) {
        self.model = model
        self.oneDay = GameOneDayModel()
    }
    
    class func configGameFlow(config: GameConfig) -> Array<GameFlow>? {
        
        var flows:[GameFlow] = []
        
        if config.gameType == .Standard {
            // 标准局
//            flows.append(GameFlow.init(flowType: .roleCheck, onlyFirstDay: true))
            flows.append(GameFlow.init(flowType: .werewolfKill, onlyFirstDay: false))
            flows.append(GameFlow.init(flowType: .witchCureOrPoison, onlyFirstDay: false))
            flows.append(GameFlow.init(flowType: .prophetCheck, onlyFirstDay: false))
            flows.append(GameFlow.init(flowType: .hunterCanShootOrNot, onlyFirstDay: false))
            flows.append(GameFlow.init(flowType: .sergeantCampaign, onlyFirstDay: true))
            flows.append(GameFlow.init(flowType: .deadInfo, onlyFirstDay: false))
            flows.append(GameFlow.init(flowType: .showTime, onlyFirstDay: false))
            flows.append(GameFlow.init(flowType: .voteTime, onlyFirstDay: false))
        }
        return flows
    }
    
    /**
     *  @brief 流程开始
     *
     *  @return 流程名
     */
    func flowStart() -> Dictionary <String, Any>? {
        
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
                if !flow.onlyFirstDay {
                    model.flows.append(flow)
                }
                return flow.flowInfo
            }
        }
        return nil
    }
    
    // 获取当前游戏流程
    func currentGameFlow() -> GameFlow? {
        return currentFlow
    }
    
    /**
     *  @brief 处理信息
     *
     *  @param role 角色
     */
    func handler(role: RoleModel, index: IndexPath) {
        
        if currentFlow?.flowType == .roleCheck {
            
        } else if currentFlow?.flowType == .werewolfKill {
            oneDay?.deadOne = index
        }
    }
    
    func handler(completion: ((_ oneDayModel: GameOneDayModel) -> GameOneDayModel?)) {
        
        if let model = completion(oneDay!) {
            oneDay = model
        }
    }
}
