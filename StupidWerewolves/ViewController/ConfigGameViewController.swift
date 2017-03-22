//
//  ConfigGameViewController.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/3/16.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit

/**
 *  游戏设置界面
 */
class ConfigGameViewController: UIViewController {

    var config: GameConfig!
    
    @IBOutlet var wolves: UILabel!
    @IBOutlet var humen: UILabel!
    @IBOutlet var gods: UILabel!
    @IBOutlet var numberInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        prepareViewConfig()
        refreshUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData() {
        config = GameConfig.init(type: GameType.Standard)
        // 默认人数: 9
        config.gamerNum = Default_Gamer_Num
    }
    
    func prepareViewConfig() {
        
        numberInput.text = String(Default_Gamer_Num)
        
        let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapGR)
    }
    
    func refreshUI() {
        DispatchQueue.main.async {
            self.wolves.text = String(self.config.wereWolvesNum)
            self.humen.text = String(self.config.villagersNum)
            self.gods.text = String(self.config.godsNum)
        }
    }
    
    func tapAction() {
        numberInput.resignFirstResponder()
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playGame() {
        
        let model = GameModel.init(config: config)
        let gameVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameVC") as! GameViewController
        gameVC.model = model
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
}

extension ConfigGameViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let totalNum = Int(textField.text!) {
            guard totalNum >= Min_Gamer_Num && totalNum <= Max_Gamer_Num else {
                return
            }
            config.gamerNum = totalNum
            refreshUI()
        }
    }
}
