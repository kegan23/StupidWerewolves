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
    var oneDay: GameOneDayModel = GameOneDayModel() {
        didSet {
            
        }
    }
    
    // 当前流程
    private var currentFlow: GameFlow?
    
    required init(model: GameModel) {
        self.model = model
    }
    
    class func configGameFlow(config: GameConfig) -> Array<GameFlow>? {
        
        var flows:[GameFlow] = []
        
        if config.gameType == .Standard {
            // 标准局
//            flows.append(GameFlow.init(flowType: .roleCheck, onlyOnce: true))
            flows.append(GameFlow.init(flowType: .werewolfKill, onlyOnce: false))
            flows.append(GameFlow.init(flowType: .witchCureOrPoison, onlyOnce: false))
            flows.append(GameFlow.init(flowType: .prophetCheck, onlyOnce: false))
            flows.append(GameFlow.init(flowType: .hunterCanShootOrNot, onlyOnce: false))
            flows.append(GameFlow.init(flowType: .sergeantCampaign, onlyOnce: true))
            flows.append(GameFlow.init(flowType: .deadInfo, onlyOnce: false))
            flows.append(GameFlow.init(flowType: .lastWordTime, onlyOnce: true))
            flows.append(GameFlow.init(flowType: .showTime, onlyOnce: false))
            flows.append(GameFlow.init(flowType: .voteTime, onlyOnce: false))
            flows.append(GameFlow.init(flowType: .lastWordTime, onlyOnce: false))
        }
        return flows
    }
    
    /**
     *  @brief 流程开始
     *
     *  @return 流程名
     */
    func flowStart(completion:((_ flow: GameFlow?) -> Void)?) {
        if model.flows.count > 0 {
            
            judgeIfGameOver { [weak self] (hasOver, info) in
                if hasOver {
                    
                    
                } else {
                    var voiceText = ""
                    if self?.currentFlow != nil {
                        voiceText = (self?.currentFlow?.flowInfo[flowEndVoiceKey])!
                    }
                    
                    if let flow = self?.model.flows.first {
                        self?.currentFlow = flow
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
                        self?.model.flows.removeFirst()
                        if !flow.onlyOnce {
                            self?.model.flows.append(flow)
                        }
                        
                        print("current flow: \(flow.flowInfo[flowTitleKey])")
                        completion?(flow)
                        if flow.flowInfo[flowStartVoiceKey]!.characters.count > 0 || voiceText.characters.count > 0 {
                            voiceText += ("。" + flow.flowInfo[flowStartVoiceKey]!)
                            SpeakManager.sharedManager.speak(voiceText, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    
    /**
     *  @brief 流程结束
     *
     *  @param completion 结束成功的回调
     */
    func flowEnd(completion: @escaping (() -> Void)) {
        
        judgeIfGameOver { [weak self] (hasOver, info) in
            if hasOver {
                
                
            } else {
                if self?.currentFlow != nil {
                    let speakText = self?.currentFlow?.flowInfo[flowEndVoiceKey]
                    SpeakManager.sharedManager.speak(speakText!, completion: {
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
//    func handler(completion: ((_ oneDayModel: GameOneDayModel) -> GameOneDayModel?)) {
//        
//        if let model = completion(oneDay!) {
//            oneDay = model
//        }
//    }
    
    /**
     *  @brief 计算减员
     *
     *  @param role 减员角色
     */
    func reduce(index: IndexPath) {
        
        if let role = roleModel(index: index) {
            
            role.hasDead = true
            
            if role.camp == CampType.God {
                model.numConfig.godsNum -= 1
            } else if role.camp == CampType.Humen {
                model.numConfig.villagersNum -= 1
            } else {
                model.numConfig.wereWolvesNum -= 1
            }
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
        
        if model.numConfig.godsNum + model.numConfig.villagersNum <= model.numConfig.wereWolvesNum {
            callback(true, gameOverInfo_wolfWin)
        }
        
        callback(false, "")
    }
}

// MARK: 功能部分
extension GameManager {
    
    // 女巫救人
    func witchPotioned() {
        
        if let role = roleModel(index: oneDay.killedOne!) {
        
            role.hasDead = false
            
            if role.camp == CampType.God {
                model.numConfig.godsNum += 1
            } else if role.camp == CampType.Humen {
                model.numConfig.villagersNum += 1
            } else {
                model.numConfig.wereWolvesNum += 1
            }
            
            oneDay.killedOne = nil
        }
    }
    
    // 猎人能否开枪
    func ifHunterCanShoot(hunterIndex: IndexPath) -> Bool {
        let hunter = roleModel(index: hunterIndex) as! Hunter
        
        if oneDay.poisonOne == hunterIndex {
            hunter.canShoot = false
        }
        return hunter.canShoot
    }

    // 当选警长
    func becomeSergeant(index: IndexPath) {
        
        model.sergeant = index
    }
    
    // 显示死亡信息
    func configDeadInfo(deadRoles roles: [RoleModel], completion: (() -> Void)?) -> String {
        
        var deadInfo: String = ""
        
        if roles.count == 0 {
            
            if model.sergeant != nil {
                let exInfo = randomOne(arr: ["左", "右"]) as! String
                deadInfo = "昨夜平安夜，从警\(exInfo)玩家开始发言"
            } else {
                let exInfo = randomOne(arr: ["小", "大"]) as! String
                deadInfo = "昨夜平安夜，从\(exInfo)号玩家开始发言"
            }
            
            skipFlow()
            
        } else {
            
            var deadNum: String = ""
            if roles.count == 1 {
                deadNum = (roles.first?.numberCard)! + "号"
            } else {
                let reversedRoles = Array(roles.reversed())
//                    NSArray.init(array: roles.reversed())
//                    Array.init(arrayLiteral: roles.reversed())
                let tempRoles = randomOne(arr: [roles, reversedRoles]) as! [RoleModel]
                
                for role in tempRoles {
                    if role.numberCard != nil {
                        deadNum += role.numberCard! + "号"
                    }
                }
            }
                
            var sergeantDead = false
            if model.sergeant == oneDay.killedOne || model.sergeant == oneDay.poisonOne {
                sergeantDead = true
            }
            
            var lastWord = ""
            if model.hasLastWords {
                model.hasLastWords = false
                lastWord = "请死者发表遗言"
            }
            if sergeantDead {
                deadInfo = "昨夜死亡的是\(deadNum)，\(lastWord)，请移交警徽"
                // 增加移交流程
                insertFlow(GameFlow.transferSergeant())
            } else {
                deadInfo = "昨夜死亡的是\(deadNum)，\(lastWord)"
            }
        }
        
        SpeakManager.sharedManager.speak(deadInfo, completion: {
            completion?()
        })
        return deadInfo
    }
    
    // 随机一个发言顺序
    func randomVoteOrder(completion: (() -> Void)?) {
        var speak = ""
        if model.sergeant == nil {
            let exInfo = randomOne(arr: ["小", "大"]) as! String
            speak = "从\(exInfo)号玩家开始发言"
        } else {
            let exInfo = randomOne(arr: ["左", "右"]) as! String
            speak = "从警\(exInfo)玩家开始发言"
        }
        
        SpeakManager.sharedManager.speak(speak, completion: completion)
    }
}




// MARK: 辅助工具
extension GameManager {
    
    // 随机获取一个数据
    func randomOne(arr: Array<Any>) -> Any {
        
        let randomSeed = Int(arc4random() % UInt32(arr.count))
        return arr[randomSeed]
    }
    
    // 获取角色信息
    func roleModel(index: IndexPath) -> RoleModel? {
        
        if index.row < model.roles.count {
            return model.roles[index.row]
        }
        return nil
    }
    
    // 插入流程
    func insertFlow(_ flow: GameFlow) {
        model.flows.insert(flow, at: 1)
    }
    
    // 跳过下一流程
    func skipFlow() {
        flowStart(completion: nil)
    }
    
    // 获取死亡时能发动技能的角色
    func specialRoles(inDeadedRoles roles: [RoleModel]) -> [RoleModel] {
        
        var speacialRoles: [RoleModel] = []
        if roles.count > 0 {
            for roleModel in roles {
                // 可枪猎人
                if let hunter = roleModel as? Hunter, hunter.canShoot == true {
                    speacialRoles.append(roleModel)
                }
            }
        }
        return speacialRoles
    }
}
