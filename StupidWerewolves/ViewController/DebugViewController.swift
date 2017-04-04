//
//  DebugViewController.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/4/1.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit

class DebugViewController: UIViewController {

    @IBOutlet var textInputTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(endEdit))
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapGR)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func endEdit() {
        self.view.endEditing(true)
    }
    
    @IBAction func speakWordOfTextInputTF() {
        
        if (textInputTF.text?.characters.count)! < 0 {
            SpeakManager.sharedManager.speak("请输入转语音的文字", completion: nil)
            return
        }
        SpeakManager.sharedManager.speak(textInputTF.text!) { [weak self] in
            print("讲完了：\(self?.textInputTF.text!)")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
