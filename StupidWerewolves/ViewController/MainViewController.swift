//
//  MainViewController.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/2/26.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit

let isPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
let isPhone = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone

class MainViewController: UIViewController {

    @IBOutlet var debugView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(enterDebugVc))
        tapGR.numberOfTapsRequired = 4
        tapGR.numberOfTouchesRequired = 1
        self.debugView.addGestureRecognizer(tapGR)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func enterDebugVc() {
        let debugVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DebugViewController") as! DebugViewController
        self.navigationController?.pushViewController(debugVC, animated: true)
    }
}

