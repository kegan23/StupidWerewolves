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
    var viewModel: GameViewModel!
    
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
        startGame(completion: nil)
    }

    func initdata() {
        manager = GameManager.init(model: model)
        
        weak var weakSelf = self
        gameCard.HideGameCardHandler = {
            weakSelf?.hideGameCard()
        }
        gameCard.ShowGameCardHandler = {
            weakSelf?.showGameCard()
        }
        
        viewModel = GameViewModel.init(gameCard: gameCard)
        
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

    // 返回
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
    
    // 开始一个游戏流程
    func startGame(completion: (() -> Void)?) {
        
        manager.flowEnd { [weak self] in
            if let flowDict = self?.manager.flowStart() {
                SpeakManager.speak(flowDict[flowStartVoiceKey] as! String, completion: completion)
                DispatchQueue.main.async(execute: {
                    self?.gameTitle.text = flowDict[flowTitleKey] as? String
                    self?.gameInfoTV.text = flowDict[flowDetailKey] as! String
                })
            }
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
        
//        if let role = manager.roleModel(index: indexPath) {
        
            if let flow = manager.currentGameFlow() {
                setViewModelWithIndex(indexPath)
                playGame(flow: flow)
                
            } else {
                startGame(completion: nil)
            }
                
//            manager.handler(role: role, index: indexPath)
            
//        }
    }
    
    
    
    // 获取号码牌
    func numberCard(index: IndexPath) -> String? {
        if index.row < numberArr.count {
            return numberArr[index.row]
        }
        return nil
    }
    
    // 设置ViewModel
    func setViewModelWithIndex(_ index: IndexPath) {
        let role = manager.roleModel(index: index)
        let number = numberCard(index: index)
        viewModel.config(index: index, role: role!, number: number!)
    }
}

extension GameViewController {
    
    // 游戏流程
    func playGame(flow: GameFlow) {
        
        if flow.flowType == GameFlowType.roleCheck {
            // 查看身份牌
            roleCheckFlow()
        } else if flow.flowType == GameFlowType.guardSomebody {
            // 守卫守人
            
        } else if flow.flowType == GameFlowType.werewolfKill {
            // 狼人杀人
            werewolfKill()
        } else if flow.flowType == GameFlowType.witchCureOrPoison {
            // 女巫救毒
            witchCureOrPoison()
        } else if flow.flowType == GameFlowType.prophetCheck {
            // 预言家验人
            prophetCheck()
        } else if flow.flowType == GameFlowType.hunterCanShootOrNot {
            // 猎人看枪
            hunterCanShootOrNot()
        } else if flow.flowType == GameFlowType.sergeantCampaign {
            // 竞选警长
            sergeantCampaign()
        } else if flow.flowType == GameFlowType.deadInfo {
            // 死亡讯息
            deadInfo()
        } else if flow.flowType == GameFlowType.showTime {
            // 发言环节
            showTime()
        } else if flow.flowType == GameFlowType.voteTime {
            // 公投环节
            voteTime()
        }
    }
    
    // 流程：查看身份牌
    func roleCheckFlow() {
        
        // 显示已查看过的号码牌
        let cell = collection.cellForItem(at: viewModel.selectedIndex!) as! GameCardCell
        cell.forbiddenCell()
        hasCheckedCells.append(cell)
        // 记录查看过的号码牌
        checkNum += 1
        
        // 显示角色卡
        viewModel.showRoleCard { [weak self] in
            // 所有号码牌都已查看
            if self?.checkNum == self?.model.numConfig.gamerNum {
                // 播放语音
                // 显示一个倒计时动画
                // 游戏开始
                
                self?.startGame(completion: { [weak self] in
                    if let strongSelf = self {
                        for cell in (strongSelf.hasCheckedCells)! {
                            cell.enabledCell()
                        }
                    }
                })
            }
        }
    }
    
    // 流程：狼人杀人(暂不支持空刀)
    func werewolfKill() {
        
        viewModel.showKillingInfo(completion: { [weak self] (hasKilled) in
            if hasKilled {
                let killedRole = self?.viewModel.selectedRole
                self?.manager.reduce(roleModel: killedRole!)
                self?.manager.oneDay?.killedOne = self?.viewModel.selectedIndex!
                self?.startGame(completion: nil)
            }
            self?.hideGameCard()
        })
    }
    
    // 流程：女巫用药
    func witchCureOrPoison() {
        
        if viewModel.needSelectedMore == true {
            viewModel.showPoisonInfo(completion: { [weak self] (hasPoison) in
                if hasPoison {
                    self?.manager.reduce(roleModel: (self?.viewModel.selectedRole)!)
                    self?.manager.oneDay?.poisonOne = self?.viewModel.selectedIndex
                    self?.startGame(completion: nil)
                }
                self?.hideGameCard()
            })
            
        } else {
            if let witch = manager.roleModel(index: viewModel.selectedIndex!) as? Witch {
                
                if let oneDay = manager.oneDay {
                    
                    if let killedNum = numberCard(index: oneDay.killedOne!) {
                        viewModel.showKilledInfo(oneDayModel: oneDay, killedNum: killedNum, completion: {[weak self] (potion, poison, poisonOne) in
                            
                            self?.hideGameCard()
                            if potion == true {
                                self?.manager.witchPotioned()
                                witch.hasPotion = false
                                self?.startGame(completion: nil)
                            }
                            
                            if poison == true {
                                self?.viewModel.needSelectedMore = true
                                witch.hasPoison = false
                            }
                        })
                    }
                }
            }
        }
    }
    
    // 流程：预言家验人
    func prophetCheck() {
        if manager.roleModel(index: viewModel.selectedIndex!)?.role == .Prophet {
            return
        }
        viewModel.showCheckedInfo { [weak self] in
            self?.startGame(completion: nil)
        }
    }
    
    // 流程：猎人看枪
    func hunterCanShootOrNot() {
        if manager.roleModel(index: viewModel.selectedIndex!)?.role == .Hunter {
            let canShoot = manager.ifHunterCanShoot(hunterIndex: viewModel.selectedIndex!)
            viewModel.showWhetherCanShoot(canShoot: canShoot) { [weak self] in
                self?.startGame(completion: nil)
            }
        }
    }
    
    // 流程：竞选警长
    func sergeantCampaign() {
        
        let cell = collection.cellForItem(at: viewModel.selectedIndex!) as! GameCardCell
        cell.addSergeantStatus()
        
        manager.becomeSergeant(index: viewModel.selectedIndex!)
        let speakText = viewModel.selectedNumber! + "号玩家当选警长"
        SpeakManager.speak(speakText) { [weak self] in
            self?.startGame(completion: nil)
        }
    }
    
    // 流程：宣布死亡信息
    func deadInfo() {
        if let oneDay = manager.oneDay {
            
            var deadNumArr: [String] = []
            if let deadOne = oneDay.killedOne {
                let cell = collection.cellForItem(at: deadOne) as! GameCardCell
                cell.addDeadStatus()
                deadNumArr.append(numberCard(index: deadOne)!)
            }
            if let poisonOne = oneDay.poisonOne {
                let cell = collection.cellForItem(at: poisonOne) as! GameCardCell
                cell.addDeadStatus()
                deadNumArr.append(numberCard(index: poisonOne)!)
            }
            
            manager.showDeadInfo(deadNumbers: deadNumArr, completion: { _ in 
                
            })
        }
    }
    
    // 流程：发言阶段
    func showTime() {
        
    }
    
    // 流程：公投阶段
    func voteTime() {
        
    }
}

// MARK: - GameCard
extension GameViewController {
    
    // 显示游戏卡片
    func showGameCard() {
        UIView.animate(withDuration: 0.2) {
            self.view.bringSubview(toFront: self.gameCard)
        }
    }
    
    // 隐藏游戏卡片
    func hideGameCard() {
        UIView.animate(withDuration: 0.2) { 
            self.view.sendSubview(toBack: self.gameCard)
        }
    }
}
