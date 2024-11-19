import UIKit
import SnapKit

class ThirdGame: UIViewController {
    
    var complexity = 0
    var graffitiOnReturnToMenu: (() -> Void)?
    let graffitiTargetScores = [5, 7, 10]
    
    private let graffitiScoreBackgroundImageView = createGraffitiImageView(named: "Score", contentMode: .scaleAspectFit)
    private let graffitiGlobalScoreLabel = createGraffitiLabel(fontName: "Questrian", fontSize: 22, textColor: .white)
    private let graffitiPauseButton = createGraffitiButton(withImageNamed: "Setting")
    private let graffitiBackgroundImageView = createGraffitiImageView(named: UserDefaults.standard.string(forKey: "graffitiSelectedImageName") ?? "BG", contentMode: .scaleAspectFill)
    
    private var graffitiGlobalScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "graffitiScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "graffitiScore")
            graffitiGlobalScoreLabel.text = "\(newValue)"
        }
    }
    
    private var graffitiButtons: [UIButton] = []
    private let graffitiImages = ["Graffiti1", "Graffiti2", "Graffiti5"]
    
    private var sequenceToFollow: [Int] = []
    private var currentStep = 0
    var graffitiScore = 0
    
    private let buttonStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graffitiGlobalScoreLabel.text = "\(graffitiGlobalScore)"
        configureGraffitiUI()
        configureGraffitiActions()
        startNewGame()
    }
    
    private func configureGraffitiUI() {
        view.addSubview(graffitiBackgroundImageView)
        graffitiBackgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
        
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(150)
        }
        
        for index in 0..<3 {
            let button = UIButton()
            button.tag = index
            button.setImage(UIImage(named: graffitiImages[index]), for: .normal)
            button.addTarget(self, action: #selector(graffitiButtonPressed(_:)), for: .touchUpInside)
            graffitiButtons.append(button)
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    private func configureGraffitiActions() {
        graffitiPauseButton.addTarget(self, action: #selector(graffitiHandleSettingButtonPress), for: .touchUpInside)
        addGraffitiSound(button: graffitiPauseButton)
    }
    
    @objc private func graffitiHandleSettingButtonPress() {
        let graffitiController = GraffitiControllAudioController()
        graffitiController.graffitiOnReturnToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.graffitiOnReturnToMenu?()
        }
        graffitiController.modalPresentationStyle = .overCurrentContext
        self.present(graffitiController, animated: false, completion: nil)
    }
    
    private func startNewGame() {
        sequenceToFollow = generateSequence(length: graffitiTargetScores[complexity])
        currentStep = 0
        showSequence()
    }
    
    private func generateSequence(length: Int) -> [Int] {
        return (0..<length).map { _ in Int.random(in: 0..<graffitiButtons.count) }
    }
    
    private func showSequence() {
        var delay = 0.5
        for index in sequenceToFollow {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.highlightButton(index: index)
            }
            delay += 0.8
        }
    }

    
    private func highlightButton(index: Int) {
        let button = graffitiButtons[index]
        shakeAnimation(for: button)
    }

    private func shakeAnimation(for button: UIButton) {
        bottleSound()
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.timingFunction = CAMediaTimingFunction(name: .linear)
        shake.values = [-12, 12, -10, 10, -8, 8, -5, 5, 0]
        shake.duration = 0.6
        button.layer.add(shake, forKey: "shake")
    }

    
    @objc private func graffitiButtonPressed(_ sender: UIButton) {
        let selectedButtonIndex = sender.tag
        shakeAnimation(for: sender)
        if selectedButtonIndex == sequenceToFollow[currentStep] {
            currentStep += 1
            graffitiScore += 2
            if currentStep == sequenceToFollow.count {
                graffitiEndGame(graffitiScore: graffitiScore, graffitiIsWin: true)
            }
        } else {
            graffitiEndGame(graffitiScore: graffitiScore, graffitiIsWin: false)
            shakeAnimation(for: sender)
        }
    }
    
    func graffitiRestartGame() {
        graffitiScore = 0
        startNewGame()
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
            self?.graffitiRestartGame()
        }
        graffitiController.modalPresentationStyle = .overCurrentContext
        self.present(graffitiController, animated: false, completion: nil)
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
