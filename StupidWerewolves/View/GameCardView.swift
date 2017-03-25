//
//  GameCardView.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/3/23.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit

protocol GameCardDelegate {
    
    func hideGameCard()
//    func leftBtnClicked()
//    func rightBtnClicked()
}

/**
 *  游戏信息卡片类，用于显示游戏信息
 */
@IBDesignable class GameCardView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var detailLbl: UILabel!
    @IBOutlet var leftBtn: UIButton!
    @IBOutlet var rightBtn: UIButton!
    
    var LeftBtnClickedCallback:(() -> Void)?    // 左边按钮点击事件回调
    var RightBtnClickedCallBack:(() -> Void)?   // 右边按钮点击事件回调
    var HideGameCardHandler:(() -> Void)!     // 隐藏卡片的回调
    
    var canTapHidden: Bool!
    
    var delegate: GameCardDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromNib()
    }
    
    private func initViewFromNib(){
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "GameCardView", bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.contentView.frame = bounds
        self.addSubview(contentView)
        
        let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(hideCard))
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        self.contentView.addGestureRecognizer(tapGR)
    }
    
    // 隐藏卡片
    func hideCard(tapGr: UITapGestureRecognizer) {
        if canTapHidden! {
            HideGameCardHandler()
        }
    }
    
    // 点击左下按钮
    @IBAction func leftBtnClicked(sender: UIButton) {
        if LeftBtnClickedCallback != nil {
            LeftBtnClickedCallback!()
        }
    }
    
    // 点击右下按钮
    @IBAction func rightBtnClicked(sender: UIButton) {
        if RightBtnClickedCallBack != nil {
            RightBtnClickedCallBack!()
        }
    }
}

/**
 *  配置显示内容
 */
extension GameCardView {
    
    // 设置身份牌方法
    func configWithRole(model: RoleModel) {
        
        config(title: "您的身份是：", detail: model.role.rawValue, btnHidden: true, canTap: true)
    }
    
    // 设置杀人信息的方法
    func configKillingInfo(number: String, leftCompletion leftCallback: @escaping (() -> Void), rightCompletion rightCallback: @escaping (() -> Void)) {
        
        config(title: "狼人击杀的目标是：", detail: number + "号", btnHidden: false, canTap: false)
        
        showLeftBtn(withTitle: "确定")
        LeftBtnClickedCallback = leftCallback
        showRightBtn(withTitle: "换人")
        RightBtnClickedCallBack = rightCallback
    }
}

// 显示的通用方法
extension GameCardView {
    
    // 通用配置方法
    func config(title: String, detail: String, btnHidden: Bool, canTap: Bool) {
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.titleLbl.text = title
            weakSelf?.detailLbl.text = detail
            weakSelf?.canTapHidden = canTap
            
            if btnHidden {
                weakSelf?.leftBtn.isHidden = true
                weakSelf?.rightBtn.isHidden = true
            } else {
                weakSelf?.leftBtn.isHidden = false
                weakSelf?.rightBtn.isHidden = false
            }
        }
    }
    
    // 显示左边的按钮
    func showLeftBtn(withTitle title: String) {
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.leftBtn.setTitle(title, for: .normal)
        }
    }
    
    // 显示右边的按钮
    func showRightBtn(withTitle title: String) {
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.rightBtn.setTitle(title, for: .normal)
        }
    }
}
