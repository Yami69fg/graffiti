import UIKit
import SpriteKit
import AVFoundation

class GraffitiSound {
    
    static let shared = GraffitiSound()
    private var audio: AVAudioPlayer?

    private init() {}
    
    func playSoundPress() {
        let isSound = UserDefaults.standard.bool(forKey: "isSoundOn")
        if isSound {
            guard let sound = Bundle.main.url(forResource: "Button", withExtension: "mp3") else { return }
            audio = try? AVAudioPlayer(contentsOf: sound)
            audio?.play()
        }
        
        let isVibration = UserDefaults.standard.bool(forKey: "isVibrationOn")
        if isVibration {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.impactOccurred()
        }
    }
    
    func playEndSound() {
        let isSound = UserDefaults.standard.bool(forKey: "isSoundOn")
        if isSound {
            guard let sound = Bundle.main.url(forResource: "End", withExtension: "mp3") else { return }
            audio = try? AVAudioPlayer(contentsOf: sound)
            audio?.play()
        }
    }
    
    func playBottleSound() {
        let isSound = UserDefaults.standard.bool(forKey: "isSoundOn")
        if isSound {
            guard let sound = Bundle.main.url(forResource: "Bottle", withExtension: "mp3") else { return }
            audio = try? AVAudioPlayer(contentsOf: sound)
            audio?.play()
        }
    }
}



extension UIViewController {
    
    func addGraffitiSound(button: UIButton) {
        button.addTarget(self, action: #selector(handleButtonTouchDown(sender:)), for: .touchDown)
    }
    
    func endSound() {
        GraffitiSound.shared.playEndSound()
    }
    
    func bottleSound() {
        GraffitiSound.shared.playBottleSound()
    }
    
    @objc private func handleButtonTouchDown(sender: UIButton) {
        GraffitiSound.shared.playSoundPress()
    }
}

extension SKScene {

    func bottleSound() {
        GraffitiSound.shared.playBottleSound()
    }

}
