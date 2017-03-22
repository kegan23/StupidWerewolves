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
 *  游戏界面
 */
class GameViewController: UIViewController {

    var model: GameModel!
    
    @IBOutlet var gameTitle: UILabel!
    @IBOutlet var collection: UICollectionView!
    @IBOutlet var gameInfoTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.numConfig.gamerNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCardCell", for: indexPath) as! GameCardCell
        cell.cardLbl.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width:(self.view.bounds.width/cell_col) ,height:cell_height)
    }
    
    
//    - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
}
