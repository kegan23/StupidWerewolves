//
//  GameViewController.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/3/16.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit

private let cell_col: CGFloat = 3.0
private let cell_height: CGFloat = 146.5

/**
 *  游戏界面, 必须传参GameModel
 */
class GameViewController: UIViewController {

    var model: GameModel!
    var manager: GameManager!
    
    @IBOutlet var gameTitle: UILabel!               // 游戏标题
    @IBOutlet var collection: UICollectionView!     // 号码牌
    @IBOutlet var gameInfoTV: UITextView!           // 游戏提示
    @IBOutlet var gameCard: GameCardView!           // 信息卡
    
    var numberArr: [String]!                        // 显示的号码牌
    
    var checkNum: Int = 0                           // 有多少人查看了号码牌
    var hasCheckedCells: [GameCardCell]! = []       // 查看了号码牌的cell
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initdata()
        startGame()
    }

    func initdata() {
        manager = GameManager.init(model: model)
        
        weak var weakSelf = self
        gameCard.HideGameCardHandler = {
            weakSelf?.hideGameCard()
        }
        
        var tempNumArr: [String] = []
        for i in 1...model.numConfig.gamerNum {
            tempNumArr.append("\(i)")
        }
        numberArr = tempNumArr
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func back() {
        let alertC = UIAlertController.init(title: nil, message: "确定要结束游戏吗？", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertC.addAction(cancelAction)
        let sureAction = UIAlertAction.init(title: "确定", style: .destructive) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertC.addAction(sureAction)
        self.present(alertC, animated: true, completion: nil)
    }
    
    func startGame() {
        if let flowDict = manager.flowStart() {
            DispatchQueue.main.async(execute: { 
                self.gameTitle.text = flowDict[flowTitleKey] as? String
                self.gameInfoTV.text = flowDict[flowDetailKey] as! String
            })
        }
    }
    
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCardCell", for: indexPath) as! GameCardCell
        cell.cardLbl.text = numberCard(index: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(self.view.bounds.width/cell_col) ,height:cell_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let role = roleModel(index: indexPath) {
            
            if let flow = manager.currentGameFlow() {
                playGame(flow: flow, with: role, at: indexPath)
            } else {
                startGame()
            }
                
//            manager.handler(role: role, index: indexPath)
            
        }
    }
    
    // 获取角色信息
    func roleModel(index: IndexPath) -> RoleModel? {
        
        if index.row < model.roles.count {
            return model.roles[index.row]
        }
        return nil
    }
    
    // 获取号码牌
    func numberCard(index: IndexPath) -> String? {
        if index.row < numberArr.count {
            return numberArr[index.row]
        }
        return nil
    }
}

extension GameViewController {
    
    // 游戏流程
    func playGame(flow: GameFlow, with role: RoleModel, at index: IndexPath) {
        
        if flow.flowType == GameFlowType.roleCheck {
            // 查看身份牌
            roleCheckFlow(with: role, at: index)
        } else if flow.flowType == GameFlowType.guardSomebody {
            // 守卫守人
            
        } else if flow.flowType == GameFlowType.werewolfKill {
            // 狼人杀人
            werewolfKill(with: role, at: index)
        }
    }
    
    // 流程：查看身份牌
    func roleCheckFlow(with role: RoleModel, at index: IndexPath) {
        // 显示角色卡
        showRoleCard(role)
        // 显示已查看过的号码牌
        let cell = collection.cellForItem(at: index) as! GameCardCell
        cell.forbiddenCell()
        hasCheckedCells.append(cell)
        // 记录查看过的号码牌
        checkNum += 1
        // 所有号码牌都已查看
        if checkNum == model.numConfig.gamerNum {
            // 播放语音
            // 显示一个倒计时动画
            // 游戏开始
            for cell in hasCheckedCells {
                cell.enabledCell()
            }
            startGame()
        }
    }
    
    // 流程：狼人杀人
    func werewolfKill(with role: RoleModel, at index: IndexPath) {
        
        let num = numberCard(index: index)
        
        weak var weakSelf = self
        showKillingInfo(num!) { (hasKilled) in
            if hasKilled {
                weakSelf?.manager.handler(completion: { (oneDay) -> GameOneDayModel? in
                    oneDay.deadOne = index
                    return oneDay
                })
                weakSelf?.startGame()
            }
            weakSelf?.hideGameCard()
        }
    }
    
}

// MARK: - GameCard delegate
extension GameViewController: GameCardDelegate {
    
    // 显示角色卡
    func showRoleCard(_ role: RoleModel) {
        gameCard.configWithRole(model: role)
        showGameCard()
    }
    
    // 显示刀的信息
    func showKillingInfo(_ number: String, completion: @escaping ((_ hasKilled: Bool) -> Void)) {
        
        gameCard.configKillingInfo(number: number, leftCompletion: {
            completion(true)
        }, rightCompletion: {
            completion(false)
        })
        showGameCard()
    }
    
    // 显示游戏卡片
    func showGameCard() {
        UIView.animate(withDuration: 0.2) {
            self.view.bringSubview(toFront: self.gameCard)
        }
    }
    func hideGameCard() {
        UIView.animate(withDuration: 0.2) { 
            self.view.sendSubview(toBack: self.gameCard)
        }
    }
    func leftBtnClicked() {
        
    }
    func rightBtnClicked() {
        
    }
}
