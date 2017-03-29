//
//  SpeakManager.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/3/22.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit
import AVFoundation

private let RATE: Float = 0.4

class SpeakManager: NSObject {
    
    class func speak(_ speakText: String, completion: (() -> Void)?) {
        
        let av = AVSpeechSynthesizer.init()
        //设置语言类别（不能识别，返回nil）
        let voiceType = getComfortableVoice()
        //需要转换的文本
        let utterance = AVSpeechUtterance.init(string: speakText)
        //设置语速快慢
        utterance.rate = RATE
        utterance.voice = voiceType;
        utterance.volume = 1
        //语音合成器会生成音频
        av.speak(utterance)
        
        let time: TimeInterval = TimeInterval(RATE * Float(speakText.characters.count))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            //code
            completion?()
        }
    }
    
    /*
     voice is Li-mu 男声
     voice is Yu-shu 女声
     */
    class func getComfortableVoice() -> AVSpeechSynthesisVoice? {
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            if voice.name == "Li-mu" {
                return voice
            }
        }
        return nil
    }
}
