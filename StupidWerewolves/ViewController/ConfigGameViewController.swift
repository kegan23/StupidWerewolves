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
    
    @IBOutlet var numberLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        refreshUI()
                
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData() {
        config = GameConfig.init(type: GameType.Standard, totalNum: Default_Gamer_Num)
    }
    
    func refreshUI() {
        DispatchQueue.main.async {
            self.numberLbl.text = String(self.config.gamerNum) + "人"
            self.wolves.text = String(self.config.wereWolvesNum) + "人"
            self.humen.text = String(self.config.villagersNum) + "人"
            self.gods.text = String(self.config.godsNum) + "人"
        }
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playGame() {
        
        let model = GameModel.init(config: config)
        let gameVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        gameVC.initManager(withGameModel: model)
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @IBAction func numberChanged(_ sender: UISlider) {
        
        config.set(totalNum: Int(sender.value))
        
        refreshUI()
    }
    
}
