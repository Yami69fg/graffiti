import UIKit

class SecondGame: UIViewController {
    
    let graffitiMainImageView = UIImageView()
    var graffitiElementCoordinates: [(CGRect, UIImage)] = []
    var graffitiTimer: Timer?
    var graffitiTimeLeft = 30
    var graffitiElementsToFindCount = 0
    var graffitiCurrentElementIndex = 0
    let graffitiTimerLabel = UILabel()
    let graffitiTargetImageView = UIImageView()
    var graffitiFoundElements: [Int] = []
    var complexity = 1
    var graffitiScore = 0
    var graffitiOnReturnToMenu: (() -> Void)?
    
    private let graffitiScoreBackgroundImageView = createGraffitiImageView(named: "Score", contentMode: .scaleAspectFit)
    private let graffitiGlobalScoreLabel = createGraffitiLabel(fontName: "Questrian", fontSize: 22, textColor: .white)
    private let graffitiPauseButton = createGraffitiButton(withImageNamed: "Setting")
    private var graffitiGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "graffitiScore") }
        set { UserDefaults.standard.set(newValue, forKey: "graffitiScore") }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graffitiScore = 0
        graffitiTimeLeft = 30 / complexity
        graffitiSetupGame()
        graffitiConfigureUI()
        graffitiConfigureActions()
    }
    
    func graffitiSetupGame() {
        view.subviews.forEach { $0.removeFromSuperview() }
        
        let graffitiBackgroundImageView = UIImageView(frame: view.bounds)
        graffitiBackgroundImageView.image = UIImage(named: UserDefaults.standard.string(forKey: "graffitiSelectedImageName") ?? "BG")
        graffitiBackgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(graffitiBackgroundImageView)
        view.sendSubviewToBack(graffitiBackgroundImageView)
        
        graffitiMainImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 0.9, height: view.bounds.width * 0.9)
        graffitiMainImageView.center = CGPoint(x: view.center.x, y: view.center.y + 50)
        graffitiMainImageView.image = UIImage(named: "ImageForSecondGame")
        view.addSubview(graffitiMainImageView)
        
        graffitiTimerLabel.frame = CGRect(x: 0, y: graffitiMainImageView.frame.minY - 60, width: view.bounds.width, height: 40)
        graffitiTimerLabel.textColor = .white
        graffitiTimerLabel.font = UIFont(name: "Questrian", size: 24)
        graffitiTimerLabel.textAlignment = .center
        view.addSubview(graffitiTimerLabel)
        
        let graffitiElements = [
            UIImage(named: "1")!,
            UIImage(named: "2")!,
            UIImage(named: "3")!,
            UIImage(named: "4")!,
            UIImage(named: "5")!
        ]
        
        graffitiElementCoordinates = [
            (CGRect(x: 60, y: 100, width: 20, height: 20), graffitiElements[2]),
            (CGRect(x: 140, y: 190, width: 20, height: 20), graffitiElements[0]),
            (CGRect(x: 220, y: 200, width: 20, height: 20), graffitiElements[1]),
            (CGRect(x: 110, y: 295, width: 20, height: 20), graffitiElements[4]),
            (CGRect(x: 150, y: 150, width: 20, height: 20), graffitiElements[3])
        ]
        
        let elementWidth = graffitiMainImageView.bounds.width * 0.1
        let elementHeight = graffitiMainImageView.bounds.height * 0.1
        let offsetX = (view.bounds.width - graffitiMainImageView.bounds.width) / 2
        let offsetY = (view.bounds.height - graffitiMainImageView.bounds.height) / 2
        
        for (frame, elementImage) in graffitiElementCoordinates {
            let button = UIButton()
            button.frame = CGRect(x: offsetX + frame.origin.x, y: offsetY + frame.origin.y, width: elementWidth, height: elementHeight)
            button.backgroundColor = .clear
            button.tag = graffitiElementCoordinates.firstIndex(where: { $0.1 == elementImage })!
            button.addTarget(self, action: #selector(graffitiItemTapped(_:)), for: .touchUpInside)
            addGraffitiSound(button: button)
            view.addSubview(button)
        }
        
        graffitiTargetImageView.frame = CGRect(x: 0, y: graffitiMainImageView.frame.maxY + 20, width: 60, height: 60)
        graffitiTargetImageView.center.x = view.center.x
        view.addSubview(graffitiTargetImageView)
        
        graffitiElementsToFindCount = complexity + 2
        graffitiFoundElements = []
        graffitiGlobalScoreLabel.text = "\(graffitiGlobalScore)"
        
        graffitiSelectRandomElement()
        graffitiStartTimer()
    }
    
    func graffitiSelectRandomElement() {
        let remainingElements = graffitiElementCoordinates.indices.filter { !graffitiFoundElements.contains($0) }
        
        if graffitiFoundElements.count >= graffitiElementsToFindCount || remainingElements.isEmpty {
            graffitiTimer?.invalidate()
            graffitiEndGame(graffitiScore: graffitiScore, graffitiIsWin: true)
            return
        }
        
        graffitiCurrentElementIndex = remainingElements.randomElement()!
        let targetElement = graffitiElementCoordinates[graffitiCurrentElementIndex].1
        graffitiTargetImageView.image = targetElement
    }
    
    @objc func graffitiItemTapped(_ sender: UIButton) {
        if sender.tag == graffitiCurrentElementIndex {
            
            graffitiFoundElements.append(graffitiCurrentElementIndex)
            graffitiScore += 5 * complexity
            graffitiGlobalScore += 5 * complexity
            graffitiGlobalScoreLabel.text = "\(graffitiGlobalScore)"
            graffitiSelectRandomElement()
        }
        
        if graffitiAreAllElementsFound() {
            graffitiTimer?.invalidate()
            graffitiEndGame(graffitiScore: graffitiScore, graffitiIsWin: true)
        }
    }
    
    func graffitiAreAllElementsFound() -> Bool {
        return graffitiFoundElements.count >= graffitiElementsToFindCount
    }
    
    func graffitiStartTimer() {
        graffitiTimer?.invalidate()
        graffitiTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(graffitiUpdateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func graffitiUpdateTimer() {
        graffitiTimeLeft -= 1
        graffitiTimerLabel.text = "\(graffitiTimeLeft)"
        if graffitiTimeLeft == 0 {
            graffitiTimer?.invalidate()
            graffitiEndGame(graffitiScore: graffitiScore, graffitiIsWin: false)
        }
    }
    
    @objc private func graffitiHandlePause() {
        graffitiPauseGame()
        let graffitiController = GraffitiControllAudioController()
        graffitiController.graffitiOnReturnToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.graffitiOnReturnToMenu?()
        }
        graffitiController.graffitiResume = { [weak self] in
            self?.graffitiResumeGame()
        }
        graffitiController.modalPresentationStyle = .overCurrentContext
        self.present(graffitiController, animated: false, completion: nil)
    }
    
    func graffitiPauseGame() {
        graffitiTimer?.invalidate()
    }
    
    func graffitiResumeGame() {
        graffitiStartTimer()
    }
    
    func graffitiRestartGame() {
        graffitiTimer?.invalidate()
        graffitiScore = 0
        graffitiElementsToFindCount = complexity + 2
        graffitiFoundElements = []
        graffitiTimeLeft = 30 / complexity
        graffitiSelectRandomElement()
        graffitiStartTimer()
    }
    
    func graffitiEndGame(graffitiScore: Int, graffitiIsWin: Bool) {
        graffitiPauseGame()
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
    
    private func graffitiConfigureUI() {
            view.addSubview(graffitiScoreBackgroundImageView)
        graffitiScoreBackgroundImageView.addSubview(graffitiGlobalScoreLabel)
        graffitiScoreBackgroundImageView.frame = CGRect(x: (view.bounds.width-150)/2, y: 50, width: 150, height: 55)
        graffitiGlobalScoreLabel.frame = graffitiScoreBackgroundImageView.bounds
            
            view.addSubview(graffitiPauseButton)
        graffitiPauseButton.frame = CGRect(x: view.bounds.width - 65, y: 50, width: 55, height: 55)
        }
        
    private func graffitiConfigureActions() {
        graffitiPauseButton.addTarget(self, action: #selector(graffitiHandlePause), for: .touchUpInside)
        addGraffitiSound(button: graffitiPauseButton)
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
