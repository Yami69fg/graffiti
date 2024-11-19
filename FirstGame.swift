import UIKit
import SpriteKit
import GameplayKit
import AVFAudio
import SnapKit

class FirstGame: UIViewController {
    
    weak var graffitiScene: GameScene?

    var complexity = 0
    var graffitiOnReturnToMenu: (() -> Void)?
    
    private let graffitiScoreBackgroundImageView = createGraffitiImageView(named: "Score", contentMode: .scaleAspectFit)
    private let graffitiGlobalScoreLabel = createGraffitiLabel(fontName: "Questrian", fontSize: 22, textColor: .white)
    private let graffitiPauseButton = createGraffitiButton(withImageNamed: "Setting")
    
    let graffitiTargetScores = [30, 20, 10]
    
    private var graffitiGlobalScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "graffitiScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "graffitiScore")
            graffitiGlobalScoreLabel.text = "\(newValue)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graffitiGlobalScoreLabel.text = "\(graffitiGlobalScore)"
        setupGraffitiScene()
        configureGraffitiUI()
        configureGraffitiActions()
    }
    
    private func setupGraffitiScene() {
        self.view = SKView(frame: view.frame)
        
        if let skView = self.view as? SKView {
            let graffitiBallScene = GameScene(size: skView.bounds.size)
            self.graffitiScene = graffitiBallScene
            graffitiBallScene.graffitiGameController = self
            graffitiBallScene.totalGraffitiMovesLeft = graffitiTargetScores[complexity]
            graffitiBallScene.scaleMode = .aspectFill
            skView.presentScene(graffitiBallScene)
        }
    }
    
    private func configureGraffitiUI() {
        
        view.addSubview(graffitiScoreBackgroundImageView)
        graffitiScoreBackgroundImageView.addSubview(graffitiGlobalScoreLabel)
        graffitiScoreBackgroundImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.size.equalTo(CGSize(width: 150, height: 55))
        }
        
        graffitiGlobalScoreLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        
        view.addSubview(graffitiPauseButton)
        graffitiPauseButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.right.equalToSuperview().inset(10)
            make.width.height.equalTo(55)
        }
    }
    
    private func configureGraffitiActions() {
        graffitiPauseButton.addTarget(self, action: #selector(graffitiHandleSettingButtonPress), for: .touchUpInside)
        addGraffitiSound(button: graffitiPauseButton)
    }
    
    @objc private func graffitiHandleSettingButtonPress() {
        graffitiScene?.pauseGraffitiGame()
        let graffitiController = GraffitiControllAudioController()
        graffitiController.graffitiOnReturnToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.graffitiOnReturnToMenu?()
        }
        graffitiController.graffitiResume = { [weak self] in
            self?.graffitiScene?.resumeGraffitiGame()
        }
        graffitiController.modalPresentationStyle = .overCurrentContext
        self.present(graffitiController, animated: false, completion: nil)
    }
    
    func graffitiEndGame(graffitiScore: Int, graffitiIsWin: Bool) {
        let graffitiController = GraffititEndGameController()
        graffitiController.graffitiIsWin = graffitiIsWin
        graffitiController.graffitiScore = graffitiScore
        graffitiController.graffitiOnReturnToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.graffitiOnReturnToMenu?()
        }
        graffitiController.graffitiOnRestart = { [weak self] in
            self?.graffitiScene?.restartGraffitiGame()
        }
        graffitiController.modalPresentationStyle = .overCurrentContext
        self.present(graffitiController, animated: false, completion: nil)
    }
    
    func graffitiUpdateScore() {
        graffitiGlobalScore += 1 + complexity
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
        return button
    }
    
    private static func createGraffitiLabel(fontName: String, fontSize: CGFloat, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: fontName, size: fontSize)
        label.textColor = textColor
        label.textAlignment = .center
        return label
    }
}
