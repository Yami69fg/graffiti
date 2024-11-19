import UIKit
import SnapKit

class GraffitiStoreController: UIViewController {
    
    private let graffitiPreviewImageNames = ["BG33", "BG44", "BG55"]
    private let graffitiBackgroundImageNames = ["BG3", "BG4", "BG5"]
    
    private var graffitiCurrentImageIndex = 0

    private var graffitiSelectedImageName: String {
        get {
            return UserDefaults.standard.string(forKey: "graffitiSelectedImageName") ?? "BG"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "graffitiSelectedImageName")
        }
    }

    private let graffitiBackdropImageView = GraffitiStoreController.createGraffitiImageView(named: "BG", contentMode: .scaleAspectFill)
    
    private let graffitiCenterImageView = UIImageView()
    
    private let graffitiLeftButton = GraffitiStoreController.createGraffitiButton(withImageNamed: "ToBack")
    private let graffitiRightButton = GraffitiStoreController.createGraffitiButton(withImageNamed: "ToNext")
    
    private let graffitiCloseButton = GraffitiStoreController.createGraffitiButton(withImageNamed: "Close")
    
    private var graffitiGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "graffitiScore") }
        set { UserDefaults.standard.set(newValue, forKey: "graffitiScore") }
    }
    
    private let graffitiBuyButton = UIButton()
    
    private let graffitiScoreBackgroundImageView = GraffitiStoreController.createGraffitiButton(withImageNamed: "Score")
    
    private let graffitiScoreLabel = GraffitiStoreController.createGraffitiScoreLabel(fontName: "Questrian", fontSize: 20, textColor: .white)

    override func viewDidLoad() {
        super.viewDidLoad()
        graffitiScoreLabel.text = "\(graffitiGlobalScore)"
        graffitiConfigureUI()
        graffitiUpdateCenterImage()
        graffitiSetupActions()
    }

    private func graffitiConfigureUI() {
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

        view.addSubview(graffitiBuyButton)
        graffitiBuyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(graffitiCenterImageView.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        graffitiBuyButton.setImage(UIImage(named: "Select"), for: .normal)
        graffitiBuyButton.imageView?.contentMode = .scaleAspectFit
    }
    
    private func graffitiUpdateCenterImage() {
        graffitiCenterImageView.image = UIImage(named: graffitiPreviewImageNames[graffitiCurrentImageIndex])?.withRenderingMode(.alwaysOriginal)
    }

    private func graffitiSetupActions() {
        graffitiLeftButton.addTarget(self, action: #selector(graffitiLeftButtonTapped), for: .touchUpInside)
        addGraffitiSound(button: graffitiLeftButton)
        graffitiRightButton.addTarget(self, action: #selector(graffitiRightButtonTapped), for: .touchUpInside)
        addGraffitiSound(button: graffitiRightButton)
        graffitiCloseButton.addTarget(self, action: #selector(graffitiCloseButtonTapped), for: .touchUpInside)
        addGraffitiSound(button: graffitiCloseButton)
        graffitiBuyButton.addTarget(self, action: #selector(graffitiBuyButtonTapped), for: .touchUpInside)
        addGraffitiSound(button: graffitiBuyButton)
    }
    
    @objc private func graffitiLeftButtonTapped() {
        if graffitiCurrentImageIndex > 0 {
            graffitiCurrentImageIndex -= 1
            graffitiUpdateCenterImage()
        }
    }
    
    @objc private func graffitiRightButtonTapped() {
        if graffitiCurrentImageIndex < graffitiPreviewImageNames.count - 1 {
            graffitiCurrentImageIndex += 1
            graffitiUpdateCenterImage()
        }
    }
    
    @objc private func graffitiCloseButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func graffitiBuyButtonTapped() {
        let graffitiCost = graffitiGetCostForCurrentImage()
        let graffitiPurchasedImageName = graffitiBackgroundImageNames[graffitiCurrentImageIndex]
        print(UserDefaults.standard.bool(forKey: "\(graffitiPurchasedImageName)p"))
        if UserDefaults.standard.bool(forKey: "\(graffitiPurchasedImageName)p") {
            graffitiSetSelectedBackgroundImage(graffitiPurchasedImageName)
            graffitiShowAlert(message: "This image is already purchased and set as the background!")
            return
        }
        
        if graffitiGlobalScore < graffitiCost {
            let graffitiMissingPoints = graffitiCost - graffitiGlobalScore
            graffitiShowAlert(message: "You need \(graffitiMissingPoints) more points to buy this image.")
            return
        }
        
        let graffitiMessage = "Do you want to buy this image for \(graffitiCost) points?"
        let graffitiAlertController = UIAlertController(title: "Confirm Purchase", message: graffitiMessage, preferredStyle: .alert)
        
        graffitiAlertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.graffitiGlobalScore -= graffitiCost
            UserDefaults.standard.set(true, forKey: "\(graffitiPurchasedImageName)p")
            self.graffitiSetSelectedBackgroundImage(graffitiPurchasedImageName)
            self.graffitiShowAlert(message: "Image purchased and set as the background!")
        }))
        
        graffitiAlertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(graffitiAlertController, animated: true, completion: nil)
    }


    private func graffitiSetSelectedBackgroundImage(_ purchasedImageName: String) {
        graffitiSelectedImageName = purchasedImageName
        graffitiScoreLabel.text = "\(graffitiGlobalScore)"
    }

    private func graffitiGetCostForCurrentImage() -> Int {
        switch graffitiCurrentImageIndex {
        case 0: return 5
        case 1: return 10
        case 2: return 20
        default: return 0
        }
    }

    private func graffitiShowAlert(message: String) {
        let graffitiAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        graffitiAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(graffitiAlert, animated: true)
    }
    
    private static func createGraffitiScoreLabel(fontName: String, fontSize: CGFloat, textColor: UIColor) -> UILabel {
        let graffitiLabel = UILabel()
        graffitiLabel.font = UIFont(name: fontName, size: fontSize)
        graffitiLabel.textColor = textColor
        graffitiLabel.textAlignment = .center
        return graffitiLabel
    }

    private static func createGraffitiImageView(named imageName: String, contentMode: UIView.ContentMode) -> UIImageView {
        let graffitiImageView = UIImageView()
        graffitiImageView.image = UIImage(named: imageName)
        graffitiImageView.contentMode = contentMode
        return graffitiImageView
    }
    
    private static func createGraffitiButton(withImageNamed imageName: String) -> UIButton {
        let graffitiButton = UIButton()
        graffitiButton.setImage(UIImage(named: imageName), for: .normal)
        graffitiButton.contentMode = .scaleAspectFit
        graffitiButton.layer.cornerRadius = 14
        graffitiButton.clipsToBounds = true
        return graffitiButton
    }
}
