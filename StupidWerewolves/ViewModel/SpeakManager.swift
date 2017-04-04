//
//  SpeakManager.swift
//  StupidWerewolves
//
//  Created by liuxin on 2017/3/22.
//  Copyright © 2017年 刘鑫. All rights reserved.
//

import UIKit
import AVFoundation

private let RATE: Float = 0.5

class SpeakManager: NSObject {
    
    static var sharedManager = SpeakManager()
    fileprivate var speaker: AVSpeechSynthesizer = AVSpeechSynthesizer.init()
    private override init() {
        super.init()
        
        speaker.delegate = self
    }
    
    /* 缓存部分 */
    fileprivate var voiceCaches: [String] = []
    fileprivate var blockDict: Dictionary < String, (() -> Void)?> = [:]
    
    
    func speak(_ speakText: String, completion: (() -> Void)?) {
        
        if completion != nil {
            blockDict[speakText] = completion
        }
        
        if speaker.isSpeaking {
            //如果正在讲话，则缓存下来，等讲完了之后接着讲
            voiceCaches.append(speakText)
        } else {
            //设置语言类别（不能识别，返回nil）
            let voiceType = getComfortableVoice()
            //需要转换的文本
            let utterance = AVSpeechUtterance.init(string: speakText)
            //设置语速快慢
            utterance.rate = RATE
            utterance.voice = voiceType;
            utterance.volume = 1
            //语音合成器会生成音频
            speaker.speak(utterance)
            
            print("spaek: \(speakText)")
        }
    }
    
    fileprivate func cacheSpeak(_ speakText: String) {
        //设置语言类别（不能识别，返回nil）
        let voiceType = getComfortableVoice()
        //需要转换的文本
        let utterance = AVSpeechUtterance.init(string: speakText)
        //设置语速快慢
        utterance.rate = RATE
        utterance.voice = voiceType;
        utterance.volume = 1
        //语音合成器会生成音频
        speaker.speak(utterance)
        
        print("spaek: \(speakText)")
    }
    
    /*
     voice is Li-mu 男声
     voice is Yu-shu 女声
     */
    func getComfortableVoice() -> AVSpeechSynthesisVoice? {
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            if voice.name == "Yu-shu" {
                return voice
            }
        }
        return nil
    }
}

extension SpeakManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        if let callback = blockDict[utterance.speechString] {
            callback?()
        }
        
        if let voiceCache = voiceCaches.first {
            voiceCaches.removeFirst()
            cacheSpeak(voiceCache)
        }
    }
}
