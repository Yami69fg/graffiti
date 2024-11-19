import UIKit
import SnapKit

class GraffitiAchieveController: UIViewController {
    
    private let graffitiImageNames = ["FirstAchieve", "ThirdAchieve", "SecondAchieve"]
    private var graffitiCurrentImageIndex = 0

    private let graffitiBackdropImageView = GraffitiAchieveController.createGraffitiImageView(named: "BG", contentMode: .scaleAspectFill)
    
    private let graffitiCenterImageView = UIImageView()
    
    private let graffitiLeftButton = GraffitiAchieveController.createGraffitiButton(withImageNamed: "ToBack")
    private let graffitiRightButton = GraffitiAchieveController.createGraffitiButton(withImageNamed: "ToNext")
    
    private let graffitiCloseButton = GraffitiAchieveController.createGraffitiButton(withImageNamed: "Close")
    
    private var graffitiGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "graffitiScore") }
        set { UserDefaults.standard.set(newValue, forKey: "graffitiScore") }
    }
    
    private let graffitiCheckButton = UIButton()
    
    private let graffitiScoreBackgroundImageView = GraffitiAchieveController.createGraffitiButton(withImageNamed: "Score")
    
    private let graffitiScoreLabel = GraffitiAchieveController.createGraffitiScoreLabel(fontName: "Questrian", fontSize: 20, textColor: .white)

    override func viewDidLoad() {
        super.viewDidLoad()
        graffitiScoreLabel.text = "\(graffitiGlobalScore)"
        configureGraffitiUI()
        updateGraffitiCenterImage()
        setupGraffitiActions()
        updateGraffitiAchievementStatus()
    }

    private func configureGraffitiUI() {
        view.addSubview(graffitiBackdropImageView)
        graffitiBackdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(graffitiCenterImageView)
        graffitiCenterImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(graffitiCenterImageView.snp.width)
        }
        
        view.addSubview(graffitiScoreBackgroundImageView)
        graffitiScoreBackgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }

        graffitiScoreBackgroundImageView.addSubview(graffitiScoreLabel)
        graffitiScoreLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(graffitiCloseButton)
        graffitiCloseButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(10)
            make.width.height.equalTo(50)
        }
        
        view.addSubview(graffitiLeftButton)
        graffitiLeftButton.snp.makeConstraints { make in
            make.centerY.equalTo(graffitiCenterImageView)
            make.right.equalTo(graffitiCenterImageView.snp.left).offset(-20)
            make.width.height.equalTo(55)
        }
        
        view.addSubview(graffitiRightButton)
        graffitiRightButton.snp.makeConstraints { make in
            make.centerY.equalTo(graffitiCenterImageView)
            make.left.equalTo(graffitiCenterImageView.snp.right).offset(20)
            make.width.height.equalTo(55)
        }

        view.addSubview(graffitiCheckButton)
        graffitiCheckButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(graffitiCenterImageView.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        graffitiCheckButton.setImage(UIImage(named: "Check"), for: .normal)
        graffitiCheckButton.imageView?.contentMode = .scaleAspectFit
    }
    
    private func updateGraffitiCenterImage() {
        graffitiCenterImageView.image = UIImage(named: graffitiImageNames[graffitiCurrentImageIndex])
        updateGraffitiAchievementStatus()
    }
    
    private func updateGraffitiAchievementStatus() {
        let isConditionMet = checkGraffitiConditionForCurrentImage()
        
        if isConditionMet {
            graffitiCenterImageView.alpha = 1.0
        } else {
            graffitiCenterImageView.alpha = 0.5
        }
    }
    
    private func setupGraffitiActions() {
        graffitiLeftButton.addTarget(self, action: #selector(graffitiLeftButtonTapped), for: .touchUpInside)
        addGraffitiSound(button: graffitiLeftButton)
        graffitiRightButton.addTarget(self, action: #selector(graffitiRightButtonTapped), for: .touchUpInside)
        addGraffitiSound(button: graffitiRightButton)
        graffitiCloseButton.addTarget(self, action: #selector(graffitiCloseButtonTapped), for: .touchUpInside)
        addGraffitiSound(button: graffitiCloseButton)
        graffitiCheckButton.addTarget(self, action: #selector(graffitiCheckButtonTapped), for: .touchUpInside)
        addGraffitiSound(button: graffitiCheckButton)
    }
    
    @objc private func graffitiLeftButtonTapped() {
        if graffitiCurrentImageIndex > 0 {
            graffitiCurrentImageIndex -= 1
            updateGraffitiCenterImage()
        }
    }
    
    @objc private func graffitiRightButtonTapped() {
        if graffitiCurrentImageIndex < graffitiImageNames.count - 1 {
            graffitiCurrentImageIndex += 1
            updateGraffitiCenterImage()
        }
    }
    
    @objc private func graffitiCloseButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func graffitiCheckButtonTapped() {
        let message = graffitiAchievementMessageForCurrentImage()
        let alertController = UIAlertController(title: "Graffiti Achievement Status", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func checkGraffitiConditionForCurrentImage() -> Bool {
        switch graffitiCurrentImageIndex {
        case 0:
            return true
        case 1:
            return graffitiGlobalScore >= 500
        case 2:
            return graffitiGlobalScore >= 2000
        default:
            return false
        }
    }

    private func graffitiAchievementMessageForCurrentImage() -> String {
        switch graffitiCurrentImageIndex {
        case 0:
            return "Achievement completed! You first opening the app!"
        case 1:
            return graffitiGlobalScore >= 500 ? "Achievement completed! 500 points collected!" : "Achievement not completed. Collect 500 points!"
        case 2:
            return graffitiGlobalScore >= 2000 ? "Achievement completed! 2000 points collected!" : "Achievement not completed. Collect 2000 points!"
        default:
            return ""
        }
    }

    private static func createGraffitiScoreLabel(fontName: String, fontSize: CGFloat, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: fontName, size: fontSize)
        label.textColor = textColor
        label.textAlignment = .center
        return label
    }

    private static func createGraffitiImageView(named imageName: String, contentMode: UIView.ContentMode) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = contentMode
        return imageView
    }
    
    private static func createGraffitiButton(withImageNamed imageName: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        return button
    }
}
