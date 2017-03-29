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
    var selectedNumber: String?     // 点击的号码牌
    
    var needSelectedMore: Bool = false  // 是否需要二次操作
    
    required init(gameCard: GameCardView) {
        self.gameCard = gameCard
    }
    
    func config(index: IndexPath, role: RoleModel, number: String) {
        self.selectedIndex = index
        self.selectedRole = role
        self.selectedNumber = number
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
        
        gameCard.configKillingInfo(number: selectedNumber!, leftCompletion: {
            completion(true)
        }, rightCompletion: {
            completion(false)
        })
        gameCard.ShowGameCardHandler()
    }
    
    // 显示死亡信息
    func showKilledInfo(oneDayModel: GameOneDayModel, killedNum: String, completion: @escaping (_ potion: Bool, _ poison: Bool, _ poisonedOne: NSIndexPath?) -> Void) {
        
        if let witch = selectedRole as? Witch {
            
            weak var weakSelf = self
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
            
            gameCard.configKilledInfo(number: selectedNumber!, leftCompletion: leftCallback, rightCompletion: rightCallback)
            gameCard.ShowGameCardHandler()
        }
    }
    
    // 显示毒杀信息
    func showPoisonInfo(completion: @escaping ((_ hasPoison: Bool) -> Void)) {
        
        gameCard.configPoisonInfo(number: selectedNumber!, leftCompletion: {
            completion(true)
        }, rightCompletion: {
            completion(false)
        })
        gameCard.ShowGameCardHandler()
    }
    
    // 显示验人信息
    func showCheckedInfo(completion: @escaping (() -> Void)) {
        
        gameCard.configCheckedInfo(model: selectedRole!, number: selectedNumber!)
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
