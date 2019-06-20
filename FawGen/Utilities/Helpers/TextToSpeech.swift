//
//  TextToSpeech.swift
//  FawGen
//
//  Created by Erick Olibo on 19/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import AVFoundation

class TextToSpeech {
    
    // MARK: - Properties
    private let synth = AVSpeechSynthesizer()
    private var utterance = AVSpeechUtterance(string: String())
    public enum TTSAccent {
        case american, australian, british, irish
        
        var code: String {
            switch self {
            case .american:
                return "en-US"
            case .australian:
                return "en-AU"
            case .british:
                return "en-GB"
            case .irish:
                return "en-IE"
            }
        }
        
//        var description: String {
//            switch self {
//            case .american:
//                return "en-US"
//            case .australian:
//                return "en-AU"
//            case .british:
//                return "en-GB"
//            case .irish:
//                return "en-IE"
//            }
//        }
    }
    
    
    public func speakFakeWord(_ word: String, accent: TTSAccent ) {
        utterance = AVSpeechUtterance(string: word)
        utterance.rate = 0.5  // Natural voice speed and API default
        utterance.voice = AVSpeechSynthesisVoice(language: accent.code)
        synth.speak(utterance)
    }
    
}
