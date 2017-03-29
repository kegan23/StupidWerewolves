//
//  GameFlow.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/3/22.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit

// flowInfo的key
let flowTitleKey = "FlowTitle"              // 流程标题
let flowDetailKey = "FlowDetail"            // 流程信息
let flowStartVoiceKey = "FlowStartVoice"    // 流程开始
let flowEndVoiceKey = "FlowEndVoice"        // 流程结束

/**
 *  枚举的rawValue为String类型, (流程题目/流程详细说明)
 */
enum GameFlowType: String {

    case roleCheck              // 查看身份
    case guardSomebody          // 守卫守人
    case werewolfKill           // 狼人杀人
    case witchCureOrPoison      // 女巫用药
    case prophetCheck           // 预言家验人
    case hunterCanShootOrNot    // 猎人睁眼
    case sergeantCampaign       // 警长竞选
    case deadInfo               // 死亡讯息
    case showTime               // 发言环节
    case voteTime               // 公投环节
}

/**
 *  游戏流程信息管理类，提供所有的游戏流程信息
 */
public class GameFlowInfoManager: NSObject {
    
    static let sharedManager = GameFlowInfoManager()
    
    var allFlowsInfo: Dictionary <String, Any>!
    
    private override init() {
        let plistPath = Bundle.main.path(forResource: "Flows", ofType: "plist")
        let dict = NSDictionary.init(contentsOfFile: plistPath!)
        allFlowsInfo = dict as! Dictionary
    }
}

/**
 *  游戏流程类, 通过游戏管理类进行不同的游戏操作
 */
class GameFlow: NSObject {
    // 流程类型
    var flowType: GameFlowType!
    var flowInfo: Dictionary <String, String>!
    
    // 仅第一夜
    var onlyFirstDay: Bool!
    
    required init(flowType: GameFlowType, onlyFirstDay: Bool) {
        self.flowType = flowType
        self.flowInfo = GameFlowInfoManager.sharedManager.allFlowsInfo[flowType.rawValue] as! Dictionary
        self.onlyFirstDay = onlyFirstDay
    }
    
}













