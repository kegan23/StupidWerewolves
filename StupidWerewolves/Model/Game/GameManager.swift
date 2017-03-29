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

    // 游戏模型
    var model: GameModel!
    // 游戏一天数据
    var oneDay: GameOneDayModel? {
        didSet {
            
        }
    }
    
    // 当前流程
    private var currentFlow: GameFlow?
    
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
//                if flow.flowType == GameFlowType.guardSomebody {
//                } else if flow.flowType == GameFlowType.werewolfKill {
//                    
//                } else if flow.flowType == GameFlowType.witchCureOrPoison {
//                    
//                } else if flow.flowType == GameFlowType.prophetCheck {
//                    
//                } else if flow.flowType == GameFlowType.hunterCanShootOrNot {
//                    
//                }
                model.flows.removeFirst()
                if !flow.onlyFirstDay {
                    model.flows.append(flow)
                }
                return flow.flowInfo
            }
        }
        return nil
    }
    
    
    /**
     *  @brief 流程结束
     *
     *  @param completion 结束成功的毁掉
     */
    func flowEnd(completion: @escaping (() -> Void)) {
        
        judgeIfGameOver { [weak self] (hasOver, info) in
            if hasOver {
                
                
            } else {
                if self?.currentFlow != nil {
                    let speakText = self?.currentFlow?.flowInfo[flowEndVoiceKey]
                    SpeakManager.speak(speakText!, completion: {
                        completion()
                    })
                } else {
                    completion()
                }
            }
        }
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
    
    /**
     *  @brief 计算减员
     *
     *  @param role 减员角色
     */
    func reduce(roleModel role: RoleModel) {
        
        if role.camp == CampType.God {
            model.numConfig.godsNum -= 1
        } else if role.camp == CampType.Humen {
            model.numConfig.villagersNum -= 1
        } else {
            model.numConfig.wereWolvesNum -= 1
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

// MARK: - 功能部分
extension GameManager {
    
    // 女巫救人
    func witchPotioned() {
        
        let role = roleModel(index: (oneDay?.killedOne)!)
        
        if role?.camp == CampType.God {
            model.numConfig.godsNum += 1
        } else if role?.camp == CampType.Humen {
            model.numConfig.villagersNum += 1
        } else {
            model.numConfig.wereWolvesNum += 1
        }
        
        oneDay?.killedOne = nil
    }
    
    // 猎人能否开枪
    func ifHunterCanShoot(hunterIndex: IndexPath) -> Bool {
        let hunter = roleModel(index: hunterIndex) as! Hunter
        
        if oneDay?.poisonOne == hunterIndex {
            hunter.canShoot = false
        }
        return hunter.canShoot
    }

    // 当选警长
    func becomeSergeant(index: IndexPath) {
        
        model.sergeant = index
    }
    
    // 显示死亡信息
    func showDeadInfo(deadNumbers nums: [String], completion: @escaping ((_ speacialRole: RoleModel?) -> Void)) {
        
        let randomSeed = Int(arc4random() % 2)
        
        var returnStr: String
        if nums.count == 0 {
            
            let exInfo = randomOne(arr: ["左", "右"]) as! String
            
            returnStr = "昨夜平安夜，从警\(exInfo)玩家开始发言"
            SpeakManager.speak(returnStr, completion: {
                completion(nil)
            })
        } else {
            
            var deadInfo: String = ""
            if randomSeed == 0 {
                for num in nums {
                    deadInfo += num
                }
            } else {
                for num in nums.reversed() {
                    deadInfo += num
                }
            }
            
            var sergeantDead = false
            if model.sergeant == oneDay?.killedOne || model.sergeant == oneDay?.poisonOne {
                sergeantDead = true
            }
            
            let killedOne = roleModel(index: (oneDay?.killedOne)!)
            if killedOne?.role == RoleType.Hunter {
                
            }
            if sergeantDead {
                let exInfo = randomOne(arr: ["小", "大"]) as! String
                returnStr = "昨夜死亡的是\(deadInfo)，从\(exInfo)号玩家开始发言"
                SpeakManager.speak(returnStr, completion: {
                    completion(nil)
                })
            } else {
                let exInfo = randomOne(arr: ["左", "右"]) as! String
                returnStr = "昨夜死亡的是\(deadInfo)，从警\(exInfo)玩家开始发言"
                SpeakManager.speak(returnStr, completion: {
                    completion(nil)
                })
            }
        }
    }
    
    // 获取角色信息
    func roleModel(index: IndexPath) -> RoleModel? {
        
        if index.row < model.roles.count {
            return model.roles[index.row]
        }
        return nil
    }
}

extension GameManager {
    func randomOne(arr: Array<Any>) -> Any {
        
        let randomSeed = Int(arc4random() % UInt32(arr.count))
        return arr[randomSeed]
    }
}
