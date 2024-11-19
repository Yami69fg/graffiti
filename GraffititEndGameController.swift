import UIKit
import SnapKit
import AVFAudio

class GraffititEndGameController: UIViewController {
    
    var graffitiPlayerAudio: AVAudioPlayer?
    
    private let graffitiBackgroundDetailsImageView = createGraffitiImage(named: "BG2")
    private let graffitiSettingsHeaderImageView = createGraffitiImageView(named: "Win", contentMode: .scaleAspectFit)
    
    private let graffitiScoreTitleLabel = createGraffitiLabel(text: "Score", fontName: "Questrian", fontSize: 30, textColor: .white)
    private let graffitiTotalScoreTitleLabel = createGraffitiLabel(text: "Total score", fontName: "Questrian", fontSize: 26, textColor: .white)
    
    var graffitiOnReturnToMenu: (() -> ())?
    var graffitiOnRestart: (() -> ())?
    
    var graffitiIsWin = false
    var graffitiScore = 0
    
    private let graffitiMainMenuButton = createGraffitiButton(withImageNamed: "Menu")
    private let graffitiRetryButton = createGraffitiButton(withImageNamed: "Restart")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endSound()
        configureGraffitiInterface()
        updateGraffitiContent()
    }
    
    private func configureGraffitiInterface() {
        setupGraffitiConstraints()
        setupGraffitiActions()
    }
    
    private func setupGraffitiConstraints() {
        view.addSubview(graffitiBackgroundDetailsImageView)
        graffitiBackgroundDetailsImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        view.addSubview(graffitiSettingsHeaderImageView)
        graffitiSettingsHeaderImageView.snp.makeConstraints { make in
            make.bottom.equalTo(graffitiBackgroundDetailsImageView.snp.top).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(250)
        }
        view.addSubview(graffitiScoreTitleLabel)
        graffitiScoreTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(graffitiBackgroundDetailsImageView.snp.left).offset(50)
            make.centerY.equalToSuperview().offset(-30)
        }
        view.addSubview(graffitiTotalScoreTitleLabel)
        graffitiTotalScoreTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(graffitiBackgroundDetailsImageView.snp.left).offset(30)
            make.centerY.equalToSuperview().offset(30)
        }
        view.addSubview(graffitiMainMenuButton)
        graffitiMainMenuButton.snp.makeConstraints { make in
            make.top.equalTo(graffitiBackgroundDetailsImageView.snp.bottom).offset(10)
            make.left.equalTo(graffitiBackgroundDetailsImageView.snp.left)
            make.width.equalTo(120)
            make.height.equalTo(60)
        }
        view.addSubview(graffitiRetryButton)
        graffitiRetryButton.snp.makeConstraints { make in
            make.top.equalTo(graffitiBackgroundDetailsImageView.snp.bottom).offset(10)
            make.right.equalTo(graffitiBackgroundDetailsImageView.snp.right)
            make.width.equalTo(120)
            make.height.equalTo(60)
        }
    }
    
    private func setupGraffitiActions() {
        graffitiMainMenuButton.addTarget(self, action: #selector(graffitiNavigateToMainMenu), for: .touchUpInside)
        addGraffitiSound(button: graffitiMainMenuButton)
        graffitiRetryButton.addTarget(self, action: #selector(graffitiRestartGameSession), for: .touchUpInside)
        addGraffitiSound(button: graffitiRetryButton)
    }
    
    private func updateGraffitiContent() {
        if graffitiIsWin {
            graffitiSettingsHeaderImageView.image = UIImage(named: "Win")
        } else {
            graffitiSettingsHeaderImageView.image = UIImage(named: "Lose")
        }
        
        graffitiScoreTitleLabel.text = "Score \(graffitiScore)"
        graffitiTotalScoreTitleLabel.text = "Total score \(UserDefaults.standard.integer(forKey: "graffitiScore"))"
    }
    
    @objc private func graffitiNavigateToMainMenu() {
        dismiss(animated: false)
        graffitiOnReturnToMenu?()
    }
    
    @objc private func graffitiRestartGameSession() {
        dismiss(animated: true)
        graffitiOnRestart?()
    }
    
    private static func createGraffitiImageView(named imageName: String, contentMode: UIView.ContentMode) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = contentMode
        return imageView
    }
    
    private static func createGraffitiLabel(text: String, fontName: String, fontSize: CGFloat, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: fontName, size: fontSize)
        label.textColor = textColor
        label.textAlignment = .center
        return label
    }
    
    private static func createGraffitiButton(withImageNamed imageName: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        return button
    }
    
    private static func createGraffitiImage(named imageName: String, contentMode: UIView.ContentMode = .scaleToFill) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = contentMode
        return imageView
    }
}
