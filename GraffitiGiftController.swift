import UIKit
import SnapKit

class GraffitiGiftController: UIViewController {

    private let graffitiBackdropImageView = GraffitiGiftController.graffitiCreateImageView(named: "BG", contentMode: .scaleAspectFill)
    
    private let graffitiGreetingImageView = GraffitiGiftController.graffitiCreateImageView(named: "Welcome", contentMode: .scaleAspectFit)
    
    private let graffitiBonusButton = GraffitiGiftController.graffitiCreateButton(withImageNamed: "Graffiti1")
    
    private var graffitiGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "graffitiScore") }
        set { UserDefaults.standard.set(newValue, forKey: "graffitiScore") }
    }
    
    private var graffitiTapCount = 0
    private let graffitiMaxTaps = 20
    private let graffitiBonusPoints = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graffitiApplyConstraints()
        graffitiSetupActions()
    }
    
    private func graffitiApplyConstraints() {
        view.addSubview(graffitiBackdropImageView)
        graffitiBackdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(graffitiGreetingImageView)
        graffitiGreetingImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(100)
            make.width.equalTo(300)
            make.height.equalTo(100)
        }
        view.addSubview(graffitiBonusButton)
        graffitiBonusButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(275)
        }
    }
    
    private func graffitiSetupActions() {
        graffitiBonusButton.addTarget(self, action: #selector(graffitiBonusButtonTapped), for: .touchUpInside)
        addGraffitiSound(button: graffitiBonusButton)
    }
    
    @objc private func graffitiBonusButtonTapped() {
        graffitiTapCount += 1
        graffitiAnimateShake()
        
        if graffitiTapCount == graffitiMaxTaps {
            graffitiGlobalScore += graffitiBonusPoints
            graffitiShowGiftAlert()
        }
    }
    
    private func graffitiAnimateShake() {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.1
        shakeAnimation.repeatCount = 3
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: graffitiBonusButton.center.x - 5, y: graffitiBonusButton.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: graffitiBonusButton.center.x + 5, y: graffitiBonusButton.center.y))
        graffitiBonusButton.layer.add(shakeAnimation, forKey: "shake")
    }
    
    private func graffitiShowGiftAlert() {
        let alert = UIAlertController(
            title: "Welcome!",
            message: "You have received \(graffitiBonusPoints) graffiti points!",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.graffitinavigateToMenu()
        })
        
        present(alert, animated: true)
    }
    
    private func graffitinavigateToMenu() {
        let menuController = GraffitiMenuController()
        menuController.modalPresentationStyle = .fullScreen
        present(menuController, animated: true)
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
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        return button
    }
}
