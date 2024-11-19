import UIKit
import SnapKit

class GraffitiGamesController: UIViewController {
    
    private let graffitiImageNames = ["FirstGame", "SecondGame", "ThirdGame"]
    private var graffitiCurrentImageIndex = 0

    private let graffitiBackdropImageView = GraffitiGamesController.createGraffitiImageView(named: "BG", contentMode: .scaleAspectFill)
    
    private let graffitiCenterImageView = UIImageView()
    
    private let graffitiLeftButton = GraffitiGamesController.createGraffitiButton(withImageNamed: "ToBack")
    private let graffitiRightButton = GraffitiGamesController.createGraffitiButton(withImageNamed: "ToNext")
    
    private let graffitiCloseButton = GraffitiGamesController.createGraffitiButton(withImageNamed: "Close")
    
    private var graffitiGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "graffitiScore") }
        set { UserDefaults.standard.set(newValue, forKey: "graffitiScore") }
    }
    
    private let graffitiCheckButton = UIButton()
    
    private let graffitiScoreBackgroundImageView = GraffitiGamesController.createGraffitiButton(withImageNamed: "Score")
    
    private let graffitiScoreLabel = GraffitiGamesController.createGraffitiScoreLabel(fontName: "Questrian", fontSize: 20, textColor: .white)

    override func viewDidLoad() {
        super.viewDidLoad()
        graffitiScoreLabel.text = "\(graffitiGlobalScore)"
        configureGraffitiUI()
        updateGraffitiCenterImage()
        setupGraffitiActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        graffitiScoreLabel.text = "\(graffitiGlobalScore)"
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
        graffitiCheckButton.setImage(UIImage(named: "Start"), for: .normal)
        graffitiCheckButton.imageView?.contentMode = .scaleAspectFit
    }
    
    private func updateGraffitiCenterImage() {
        graffitiCenterImageView.image = UIImage(named: graffitiImageNames[graffitiCurrentImageIndex])
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
        let graffitiAchieveVC = GraffitiСomplexityController()
        graffitiAchieveVC.graffitiGame = graffitiCurrentImageIndex
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
