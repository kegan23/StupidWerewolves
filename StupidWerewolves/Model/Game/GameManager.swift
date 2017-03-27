//
//  GameManager.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/3/16.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit

let gameOverInfo_goodWin = "好人阵营获胜"
let gameOverInfo_wolfWin = "狼人阵营获胜"
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
            flows.append(GameFlow.init(flowType: .roleCheck, onlyFirstDay: true))
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
    
    
//    func handler(role: RoleModel, index: IndexPath) {
//        
//        if currentFlow?.flowType == .roleCheck {
//            
//        } else if currentFlow?.flowType == .werewolfKill {
//            oneDay?.killedOne = index
//        }
//    }
    
    // 处理信息
    func handler(completion: ((_ oneDayModel: GameOneDayModel) -> GameOneDayModel?)) {
        
        if let model = completion(oneDay!) {
            oneDay = model
        }
    }
    
    // 判断游戏是否结束
    func judgeIfGameOver(callback: @escaping (_ hasOver: Bool, _ info: String) -> Void) {
        //
        if model.numConfig.wereWolvesNum == 0 {
            callback(true, gameOverInfo_goodWin)
        }
        
        if model.numConfig.godsNum == 0 || model.numConfig.villagersNum == 0 {
            callback(true, gameOverInfo_wolfWin)
        }
        
        if model.numConfig.godsNum + model.numConfig.villagersNum < model.numConfig.wereWolvesNum {
            callback(true, gameOverInfo_wolfWin)
        }
        
        callback(false, "")
    }
}
