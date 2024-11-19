import UIKit
import SnapKit

class GraffitiControllAudioController: UIViewController {
    
    private let graffitiControlPanelBackgroundDetails = createGraffitiImage(named: "BG2")
    private let graffitiControlPanelSettingsHeaderLabel = createGraffitiImage(named: "Settings")
    
    private let graffitiSoundTitleLabel = createGraffitiLabel(text: "Sound", fontName: "Questrian", fontSize: 32, textColor: .white)
    private let graffitiVibrationTitleLabel = createGraffitiLabel(text: "Vibration", fontName: "Questrian", fontSize: 32, textColor: .white)
    
    var graffitiOnReturnToMenu: (() -> ())?
    var graffitiResume: (() -> ())?
    
    private let graffitiSoundToggleSwitchButton = createGraffitiButton()
    private let graffitiVibrationToggleSwitchButton = createGraffitiButton()
    
    private let graffitiMainMenuButton = createGraffitiButton(withImageNamed: "Menu")
    private let graffitiReturnToGameplayButton = createGraffitiButton(withImageNamed: "Back")

    override func viewDidLoad() {
        super.viewDidLoad()
        graffitiSetupInterfaceLayout()
        graffitiSetupDefaultSettings()
        graffitiLoadToggleButtonStates()
    }

    private func graffitiSetupInterfaceLayout() {
        graffitiSetupSubviewsAndConstraints()
        graffitiConfigureButtonActions()
    }

    private func graffitiSetupSubviewsAndConstraints() {
        
        view.addSubview(graffitiControlPanelBackgroundDetails)
        graffitiControlPanelBackgroundDetails.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
        view.addSubview(graffitiControlPanelSettingsHeaderLabel)
        graffitiControlPanelSettingsHeaderLabel.snp.makeConstraints {
            $0.bottom.equalTo(graffitiControlPanelBackgroundDetails.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(100)
        }
        view.addSubview(graffitiSoundTitleLabel)
        graffitiSoundTitleLabel.snp.makeConstraints {
            $0.left.equalTo(graffitiControlPanelBackgroundDetails.snp.left).offset(20)
            $0.centerY.equalToSuperview().offset(-30)
        }
        view.addSubview(graffitiSoundToggleSwitchButton)
        graffitiSoundToggleSwitchButton.snp.makeConstraints {
            $0.left.equalTo(graffitiSoundTitleLabel.snp.right).offset(20)
            $0.centerY.equalToSuperview().offset(-30)
            $0.width.equalTo(60)
            $0.height.equalTo(35)
        }
        view.addSubview(graffitiVibrationTitleLabel)
        graffitiVibrationTitleLabel.snp.makeConstraints {
            $0.left.equalTo(graffitiControlPanelBackgroundDetails.snp.left).offset(30)
            $0.centerY.equalToSuperview().offset(30)
        }
        view.addSubview(graffitiVibrationToggleSwitchButton)
        graffitiVibrationToggleSwitchButton.snp.makeConstraints {
            $0.left.equalTo(graffitiVibrationTitleLabel.snp.right).offset(20)
            $0.centerY.equalToSuperview().offset(30)
            $0.width.equalTo(60)
            $0.height.equalTo(35)
        }
        view.addSubview(graffitiMainMenuButton)
        graffitiMainMenuButton.snp.makeConstraints {
            $0.top.equalTo(graffitiControlPanelBackgroundDetails.snp.bottom)
            $0.leading.equalToSuperview().offset(50)
            $0.width.equalTo(120)
            $0.height.equalTo(60)
        }
        view.addSubview(graffitiReturnToGameplayButton)
        graffitiReturnToGameplayButton.snp.makeConstraints {
            $0.top.equalTo(graffitiControlPanelBackgroundDetails.snp.bottom)
            $0.trailing.equalToSuperview().offset(-50)
            $0.width.equalTo(120)
            $0.height.equalTo(60)
        }
    }

    private func graffitiSetupDefaultSettings() {
        if UserDefaults.standard.object(forKey: "isSoundOn") == nil {
            UserDefaults.standard.set(true, forKey: "isSoundOn")
        }
        if UserDefaults.standard.object(forKey: "isVibrationOn") == nil {
            UserDefaults.standard.set(true, forKey: "isVibrationOn")
        }
    }

    private func graffitiLoadToggleButtonStates() {
        let isAudioEnabled = UserDefaults.standard.bool(forKey: "isSoundOn")
        let isVibrationEnabled = UserDefaults.standard.bool(forKey: "isVibrationOn")
        
        graffitiSoundToggleSwitchButton.setImage(UIImage(named: isAudioEnabled ? "On" : "Off"), for: .normal)
        graffitiVibrationToggleSwitchButton.setImage(UIImage(named: isVibrationEnabled ? "On" : "Off"), for: .normal)
    }

    private func graffitiConfigureButtonActions() {
        graffitiMainMenuButton.addTarget(self, action: #selector(graffitiMainMenuTapped), for: .touchUpInside)
        addGraffitiSound(button: graffitiMainMenuButton)
        graffitiReturnToGameplayButton.addTarget(self, action: #selector(graffitiReturnToGameplayTapped), for: .touchUpInside)
        addGraffitiSound(button: graffitiReturnToGameplayButton)
        graffitiSoundToggleSwitchButton.addTarget(self, action: #selector(graffitiToggleSound), for: .touchUpInside)
        addGraffitiSound(button: graffitiSoundToggleSwitchButton)
        graffitiVibrationToggleSwitchButton.addTarget(self, action: #selector(graffitiToggleVibration), for: .touchUpInside)
        addGraffitiSound(button: graffitiVibrationToggleSwitchButton)
    }

    @objc private func graffitiMainMenuTapped() {
        dismiss(animated: false)
        graffitiOnReturnToMenu?()
    }
    
    @objc private func graffitiReturnToGameplayTapped() {
        graffitiResume?()
        dismiss(animated: true)
    }
    
    @objc private func graffitiToggleSound() {
        let isSoundActive = graffitiSoundToggleSwitchButton.currentImage == UIImage(named: "On")
        let newSoundState = !isSoundActive
        graffitiSoundToggleSwitchButton.setImage(UIImage(named: newSoundState ? "On" : "Off"), for: .normal)
        UserDefaults.standard.set(newSoundState, forKey: "isSoundOn")
    }
    
    @objc private func graffitiToggleVibration() {
        let isVibrationActive = graffitiVibrationToggleSwitchButton.currentImage == UIImage(named: "On")
        let newVibrationState = !isVibrationActive
        graffitiVibrationToggleSwitchButton.setImage(UIImage(named: newVibrationState ? "On" : "Off"), for: .normal)
        UserDefaults.standard.set(newVibrationState, forKey: "isVibrationOn")
    }

    private static func createGraffitiImageView(named imageName: String, contentMode: UIView.ContentMode) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = contentMode
        return imageView
    }
    
    private static func createGraffitiButton(withImageNamed imageName: String? = nil) -> UIButton {
        let button = UIButton()
        if let imageName = imageName {
            button.setImage(UIImage(named: imageName), for: .normal)
        }
        return button
    }
    
    private static func createGraffitiLabel(text: String, fontName: String, fontSize: CGFloat, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: fontName, size: fontSize)
        label.textColor = textColor
        label.textAlignment = .center
        return label
    }
    
    private static func createGraffitiImage(named imageName: String, contentMode: UIView.ContentMode = .scaleToFill) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = contentMode
        return imageView
    }

}

