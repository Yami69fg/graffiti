import UIKit
import SnapKit

class GraffitiLoadingController: UIViewController {
    
    private let graffitiBackgroundImageView = createImageView(named: "BG")
    private let graffitiBouncingImageView = createImageView(named: "Graffiti1")
    private let graffitiLoadingImageView = createImageView(named: "Loading")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graffitiConfigureUI()
        graffitiStartShakeAnimation()
        graffitiStartLoadingTextBlinkAnimation()
        graffitiScheduleTransitionToMainMenu()
    }

    private func graffitiConfigureUI() {
        graffitiSetupUIElements()
    }

    private func graffitiSetupUIElements() {
        view.addSubview(graffitiBackgroundImageView)
        graffitiBackgroundImageView.snp.makeConstraints { graffitiMake in
            graffitiMake.edges.equalToSuperview()
        }
        
        view.addSubview(graffitiBouncingImageView)
        graffitiBouncingImageView.snp.makeConstraints { graffitiMake in
            graffitiMake.centerX.equalToSuperview()
            graffitiMake.centerY.equalToSuperview()
            graffitiMake.width.equalTo(250)
            graffitiMake.height.equalTo(300)
        }
        
        view.addSubview(graffitiLoadingImageView)
        graffitiLoadingImageView.snp.makeConstraints { graffitiMake in
            graffitiMake.centerX.equalToSuperview()
            graffitiMake.top.equalTo(graffitiBouncingImageView.snp.bottom).offset(20)
            graffitiMake.width.equalTo(250)
            graffitiMake.height.equalTo(75)
        }
    }

    private func graffitiStartShakeAnimation() {
        let graffitiShakeAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        graffitiShakeAnimation.duration = 0.2
        graffitiShakeAnimation.repeatCount = .infinity
        graffitiShakeAnimation.autoreverses = true
        graffitiShakeAnimation.fromValue = -10
        graffitiShakeAnimation.toValue = 10
        graffitiShakeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        graffitiBouncingImageView.layer.add(graffitiShakeAnimation, forKey: "graffitiShake")
    }

    private func graffitiStartLoadingTextBlinkAnimation() {
        UIView.animate(withDuration: 0.8, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            self.graffitiLoadingImageView.alpha = 0.0
        }, completion: { _ in
            self.graffitiLoadingImageView.alpha = 1.0
        })
    }

    private func graffitiScheduleTransitionToMainMenu() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.graffitiTransitionToMainMenu()
        }
    }

    private func graffitiTransitionToMainMenu() {
        let graffitiIsLaunched = UserDefaults.standard.bool(forKey: "isFirst")
        if !graffitiIsLaunched {
            UserDefaults.standard.set(true, forKey: "isFirst")
            UserDefaults.standard.synchronize()
            let graffitiMainMenuVC = GraffitiGiftController()
            graffitiMainMenuVC.modalTransitionStyle = .crossDissolve
            graffitiMainMenuVC.modalPresentationStyle = .fullScreen
            self.present(graffitiMainMenuVC, animated: false, completion: nil)
        } else {
            let graffitiMainMenuVC = GraffitiMenuController()
            graffitiMainMenuVC.modalTransitionStyle = .crossDissolve
            graffitiMainMenuVC.modalPresentationStyle = .fullScreen
            self.present(graffitiMainMenuVC, animated: false, completion: nil)
        }
    }

    private static func createImageView(named graffitiImageName: String) -> UIImageView {
        let graffitiImageView = UIImageView()
        graffitiImageView.image = UIImage(named: graffitiImageName)
        return graffitiImageView
    }
}
