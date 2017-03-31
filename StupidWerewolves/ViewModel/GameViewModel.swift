//
//  GameViewModel.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/3/27.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit

/**
 *  游戏界面模型，用于配制游戏的界面
 */
class GameViewModel: NSObject {

    var gameCard: GameCardView!     // 必须直接配制
    
    var selectedIndex: IndexPath?   // 当前点击的IndexPath
    var selectedRole: RoleModel?    // 点击的role
    
    var needSelectedMore: Bool = false  // 是否需要二次操作
    
    /* 多次点击 */
    var numOfTap: Int = 0 {             // 记录多次点击
        didSet {
            if numOfTap == multipleSelect {
                TapBlock?()
                TapBlock = nil
                multipleSelect = 0
            }
        }
    }
    private var multipleSelect: Int = 0 // 点击次数设定
    private var TapBlock: (() -> Void)? // 达到点击数后回调
    
    required init(gameCard: GameCardView) {
        self.gameCard = gameCard
    }
    
    func config(index: IndexPath, role: RoleModel) {
        self.selectedIndex = index
        self.selectedRole = role
    }
    
    // 需要点击多个cell触发事件
    func multipleSelect(selectNum num: Int, completion:@escaping () -> Void) {
        multipleSelect = num
        numOfTap = 0
        TapBlock = completion
    }
    
    // 增加点击计数
    func addTapNum() {
        numOfTap += 1
    }
}

// 显示
extension GameViewModel {
    // 显示角色卡
    func showRoleCard(completion: @escaping (() -> Void)) {
        gameCard.configWithRole(model: selectedRole!)
        gameCard.ShowGameCardHandler()
        gameCard.GameCardCompletion = completion
    }
    
    // 显示刀的信息
    func showKillingInfo(completion: @escaping ((_ hasKilled: Bool) -> Void)) {
        
        gameCard.configKillingInfo(number: (selectedRole?.numberCard)!, leftCompletion: {
            completion(true)
        }, rightCompletion: {
            completion(false)
        })
        gameCard.ShowGameCardHandler()
    }
    
    // 显示死亡信息
    func showKilledInfo(oneDayModel: GameOneDayModel, killedNum: String, completion: @escaping (_ potion: Bool, _ poison: Bool, _ poisonedOne: NSIndexPath?) -> Void) {
        
        if let witch = selectedRole as? Witch {
            
            var leftCallback: (() -> Void)? = nil
            if witch.hasPotion && oneDayModel.killedOne != selectedIndex {
                leftCallback = { () in
                    completion(true, false, nil)
                }
            }
            
            var rightCallback: (() -> Void)? = nil
            if witch.hasPoison {
                rightCallback = { () in
                    completion(false, true, nil)
                }
            }
            
            gameCard.configKilledInfo(number: killedNum, leftCompletion: leftCallback, rightCompletion: rightCallback)
            gameCard.ShowGameCardHandler()
        }
    }
    
    // 显示毒杀信息
    func showPoisonInfo(completion: @escaping ((_ hasPoison: Bool) -> Void)) {
        
        gameCard.configPoisonInfo(number: (selectedRole?.numberCard)!, leftCompletion: {
            completion(true)
        }, rightCompletion: {
            completion(false)
        })
        gameCard.ShowGameCardHandler()
    }
    
    // 显示验人信息
    func showCheckedInfo(completion: @escaping (() -> Void)) {
        
        gameCard.configCheckedInfo(model: selectedRole!)
        gameCard.ShowGameCardHandler()
        gameCard.GameCardCompletion = completion
    }
    
    // 显示能否枪
    func showWhetherCanShoot(canShoot: Bool, completion: @escaping (() -> Void)) {
        
        gameCard.configCheckCanShootOrNot(canShoot: canShoot)
        gameCard.ShowGameCardHandler()
        gameCard.GameCardCompletion = completion
    }
    
}
