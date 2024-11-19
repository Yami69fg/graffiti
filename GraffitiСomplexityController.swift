import UIKit
import SnapKit

class GraffitiСomplexityController: UIViewController {

    private let graffitiBackgroundImageView = GraffitiСomplexityController.createGraffitiImageView(named:"BG", contentMode: .scaleAspectFill)
    private let graffitiPlayButton = GraffitiСomplexityController.createGraffitiButton(withImageNamed: "Hard")
    private let graffitiStoreButton = GraffitiСomplexityController.createGraffitiButton(withImageNamed: "Easy")
    private let graffitiAchievementsButton = GraffitiСomplexityController.createGraffitiButton(withImageNamed: "Medium")
    private let graffitiCloseButton = GraffitiСomplexityController.createGraffitiButton(withImageNamed: "Close")
    private let graffitiInfoButton = GraffitiСomplexityController.createGraffitiButton(withImageNamed: "InfoButton")
    private let graffitiScoreBackgroundImageView = GraffitiСomplexityController.createGraffitiButton(withImageNamed: "Score")
    
    private let graffitiScoreLabel = GraffitiСomplexityController.createGraffitiScoreLabel(fontName: "Questrian", fontSize: 20, textColor: .white)
    
    private var graffitiGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "graffitiScore") }
        set { UserDefaults.standard.set(newValue, forKey: "graffitiScore") }
    }
    
    var graffitiGame = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        graffitiScoreLabel.text = "\(graffitiGlobalScore)"
        graffitiConfigureUI()
        graffitiSetupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        graffitiScoreLabel.text = "\(graffitiGlobalScore)"
    }

    private func graffitiConfigureUI() {
        view.addSubview(graffitiBackgroundImageView)
        graffitiBackgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(graffitiAchievementsButton)
        graffitiAchievementsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(60)
        }

        view.addSubview(graffitiPlayButton)
        graffitiPlayButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(graffitiAchievementsButton.snp.bottom).offset(50)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }

        view.addSubview(graffitiStoreButton)
        graffitiStoreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(graffitiAchievementsButton.snp.top).offset(-50)
            make.width.equalTo(200)
            make.height.equalTo(60)
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
        view.addSubview(graffitiInfoButton)
        graffitiInfoButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.right.equalToSuperview().inset(10)
            make.width.height.equalTo(50)
        }
    }

    private func graffitiSetupActions() {
        graffitiPlayButton.addTarget(self, action: #selector(graffitiDidTapPlayButton), for: .touchUpInside)
        addGraffitiSound(button: graffitiPlayButton)
        graffitiStoreButton.addTarget(self, action: #selector(graffitiDidTapStoreButton), for: .touchUpInside)
        addGraffitiSound(button: graffitiStoreButton)
        graffitiAchievementsButton.addTarget(self, action: #selector(graffitiDidTapAchievementsButton), for: .touchUpInside)
        addGraffitiSound(button: graffitiAchievementsButton)
        graffitiCloseButton.addTarget(self, action: #selector(graffitiCloseButtonTapped), for: .touchUpInside)
        addGraffitiSound(button: graffitiCloseButton)
        graffitiInfoButton.addTarget(self, action: #selector(graffitiInfoButtonTapped), for: .touchUpInside)
        addGraffitiSound(button: graffitiInfoButton)
    }
    
    @objc private func graffitiDidTapStoreButton() {
        if graffitiGame == 0 {
            let graffitiAchieveVC = FirstGame()
            graffitiAchieveVC.complexity = 0
            graffitiAchieveVC.modalTransitionStyle = .crossDissolve
            graffitiAchieveVC.modalPresentationStyle = .fullScreen
            present(graffitiAchieveVC, animated: true, completion: nil)
        } else if graffitiGame == 1 {
            let graffitiAchieveVC = SecondGame()
            graffitiAchieveVC.complexity = 1
            graffitiAchieveVC.modalTransitionStyle = .crossDissolve
            graffitiAchieveVC.modalPresentationStyle = .fullScreen
            present(graffitiAchieveVC, animated: true, completion: nil)
        } else if graffitiGame == 2 {
            let graffitiAchieveVC = ThirdGame()
            graffitiAchieveVC.complexity = 0
            graffitiAchieveVC.modalTransitionStyle = .crossDissolve
            graffitiAchieveVC.modalPresentationStyle = .fullScreen
            present(graffitiAchieveVC, animated: true, completion: nil)
        }
    }
    
    @objc private func graffitiDidTapAchievementsButton() {
        if graffitiGame == 0 {
            let graffitiAchieveVC = FirstGame()
            graffitiAchieveVC.complexity = 1
            graffitiAchieveVC.modalTransitionStyle = .crossDissolve
            graffitiAchieveVC.modalPresentationStyle = .fullScreen
            present(graffitiAchieveVC, animated: true, completion: nil)
        } else if graffitiGame == 1 {
            let graffitiAchieveVC = SecondGame()
            graffitiAchieveVC.complexity = 2
            graffitiAchieveVC.modalTransitionStyle = .crossDissolve
            graffitiAchieveVC.modalPresentationStyle = .fullScreen
            present(graffitiAchieveVC, animated: true, completion: nil)
        } else if graffitiGame == 2 {
            let graffitiAchieveVC = ThirdGame()
            graffitiAchieveVC.complexity = 1
            graffitiAchieveVC.modalTransitionStyle = .crossDissolve
            graffitiAchieveVC.modalPresentationStyle = .fullScreen
            present(graffitiAchieveVC, animated: true, completion: nil)
        }
    }
    
    @objc private func graffitiDidTapPlayButton() {
        if graffitiGame == 0 {
            let graffitiAchieveVC = FirstGame()
            graffitiAchieveVC.complexity = 2
            graffitiAchieveVC.modalTransitionStyle = .crossDissolve
            graffitiAchieveVC.modalPresentationStyle = .fullScreen
            present(graffitiAchieveVC, animated: true, completion: nil)
        } else if graffitiGame == 1 {
            let graffitiAchieveVC = SecondGame()
            graffitiAchieveVC.complexity = 3
            graffitiAchieveVC.modalTransitionStyle = .crossDissolve
            graffitiAchieveVC.modalPresentationStyle = .fullScreen
            present(graffitiAchieveVC, animated: true, completion: nil)
        } else if graffitiGame == 2 {
            let graffitiAchieveVC = ThirdGame()
            graffitiAchieveVC.complexity = 2
            graffitiAchieveVC.modalTransitionStyle = .crossDissolve
            graffitiAchieveVC.modalPresentationStyle = .fullScreen
            present(graffitiAchieveVC, animated: true, completion: nil)
        }
    }
    
    @objc private func graffitiCloseButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func graffitiInfoButtonTapped() {
        let graffitiAchieveVC = GraffitiInfoController()
        graffitiAchieveVC.graffitiGame = graffitiGame
        graffitiAchieveVC.modalTransitionStyle = .crossDissolve
        graffitiAchieveVC.modalPresentationStyle = .fullScreen
        present(graffitiAchieveVC, animated: true, completion: nil)
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


