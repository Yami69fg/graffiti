import UIKit
import SnapKit

class GraffitiMenuController: UIViewController {

    private let graffitiBackgroundImageView = GraffitiMenuController.graffitiCreateImageView(named:"BG", contentMode: .scaleAspectFill)
    private let graffitiMenuBallImageView = GraffitiMenuController.graffitiCreateImageView(named: "Graffiti1", contentMode: .scaleAspectFill)
    private let graffitiPlayButton = GraffitiMenuController.graffitiCreateButton(withImageNamed: "Start")
    private let graffitiStoreButton = GraffitiMenuController.graffitiCreateButton(withImageNamed: "Store")
    private let graffitiAchievementsButton = GraffitiMenuController.graffitiCreateButton(withImageNamed: "Achieve")
    
    private var graffitiGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "graffitiScore") }
        set { UserDefaults.standard.set(newValue, forKey: "graffitiScore") }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        graffitiConfigureUI()
        graffitiSetupActions()
        graffitiLoadSavedTimerState()
        graffitiStartTimer()
        graffitiConfigureTimerLabel()
    }
    



    private func graffitiConfigureUI() {
        view.addSubview(graffitiBackgroundImageView)
        graffitiBackgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(graffitiTimerButton)
        graffitiTimerButton.isEnabled = false
        graffitiTimerButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(75)
            make.centerX.equalToSuperview()
            make.width.equalTo(175)
            make.height.equalTo(50)
        }

        view.addSubview(graffitiMenuBallImageView)
        graffitiMenuBallImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(graffitiTimerButton.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }

        view.addSubview(graffitiPlayButton)
        graffitiPlayButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(graffitiMenuBallImageView.snp.bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }

        view.addSubview(graffitiAchievementsButton)
        graffitiAchievementsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(graffitiPlayButton.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }

        view.addSubview(graffitiStoreButton)
        graffitiStoreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(graffitiAchievementsButton.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
    }

    private func graffitiSetupActions() {
        graffitiPlayButton.addTarget(self, action: #selector(graffitiDidTapPlayButton), for: .touchUpInside)
        addGraffitiSound(button: graffitiPlayButton)
        graffitiStoreButton.addTarget(self, action: #selector(graffitiDidTapStoreButton), for: .touchUpInside)
        addGraffitiSound(button: graffitiStoreButton)
        graffitiAchievementsButton.addTarget(self, action: #selector(graffitiDidTapAchievementsButton), for: .touchUpInside)
        addGraffitiSound(button: graffitiAchievementsButton)
        graffitiTimerButton.addTarget(self, action: #selector(graffitiRewardButtonTapped), for: .touchUpInside)
        addGraffitiSound(button: graffitiTimerButton)
    }

    @objc private func graffitiDidTapPlayButton() {
        let graffitiAchieveVC = GraffitiGamesController()
        graffitiAchieveVC.modalTransitionStyle = .crossDissolve
        graffitiAchieveVC.modalPresentationStyle = .fullScreen
        present(graffitiAchieveVC, animated: true, completion: nil)
    }
    
    @objc private func graffitiDidTapStoreButton() {
        let graffitiAchieveVC = GraffitiStoreController()
        graffitiAchieveVC.modalTransitionStyle = .crossDissolve
        graffitiAchieveVC.modalPresentationStyle = .fullScreen
        present(graffitiAchieveVC, animated: true, completion: nil)
    }
    
    @objc private func graffitiDidTapAchievementsButton() {
        let graffitiAchieveVC = GraffitiAchieveController()
        graffitiAchieveVC.modalTransitionStyle = .crossDissolve
        graffitiAchieveVC.modalPresentationStyle = .fullScreen
        present(graffitiAchieveVC, animated: true, completion: nil)
    }
    
    private let graffitiTimerButton = GraffitiMenuController.graffitiCreateButton(withImageNamed: "Score")
    
    private let graffitiTimerLabel = UILabel()
    private let graffitiKey = "graffitiTimer"
    private let graffitiTimerDuration: TimeInterval = 3600
    private var graffitiTimer: Timer?
    private var graffitiRemainingTime: TimeInterval = 3600
    
    private func graffitiStartTimer() {
        graffitiTimer?.invalidate()
        graffitiTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(graffitiUpdateTimer), userInfo: nil, repeats: true)
    }

    @objc private func graffitiUpdateTimer() {
        if graffitiRemainingTime > 0 {
            graffitiRemainingTime -= 1
            graffitiTimerLabel.text = graffitiFormatTime(graffitiRemainingTime)
            graffitiSaveTimerState()
        } else {
            graffitiTimer?.invalidate()
            graffitiTimerLabel.text = "00:00:00"
            graffitiUnlockRewardButton()
        }
    }

    private func graffitiFormatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    private func graffitiUnlockRewardButton() {
        graffitiTimerButton.isEnabled = true
    }

    private func graffitiLoadSavedTimerState() {
        let timerStartTime = UserDefaults.standard.double(forKey: graffitiKey)
        if timerStartTime == 0 {
            graffitiRemainingTime = graffitiTimerDuration
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: graffitiKey)
        } else {
            let elapsedTime = Date().timeIntervalSince1970 - timerStartTime
            graffitiRemainingTime = max(0, graffitiTimerDuration - elapsedTime)
        }
        graffitiTimerLabel.text = graffitiFormatTime(graffitiRemainingTime)
    }

    private func graffitiSaveTimerState() {
        UserDefaults.standard.set(graffitiRemainingTime, forKey: "remainingTime")
    }

    @objc private func graffitiRewardButtonTapped() {
        graffitiRemainingTime = graffitiTimerDuration
        graffitiGlobalScore += 100
        graffitiTimerLabel.text = graffitiFormatTime(graffitiRemainingTime)
        graffitiTimerButton.isEnabled = false
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: graffitiKey)
        graffitiStartTimer()
    }

    private func graffitiConfigureTimerLabel() {
        graffitiTimerLabel.text = graffitiFormatTime(graffitiRemainingTime)
        graffitiTimerLabel.font = UIFont(name: "Questrian", size: 18)
        graffitiTimerLabel.textColor = .white
        graffitiTimerLabel.textAlignment = .center
        graffitiTimerButton.addSubview(graffitiTimerLabel)
        graffitiTimerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private static func graffitiCreateImageView(named imageName: String, contentMode: UIView.ContentMode) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = contentMode
        return imageView
    }

    private static func graffitiCreateButton(withImageNamed imageName: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        return button
    }
}

