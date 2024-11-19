import UIKit
import SnapKit

class GraffitiInfoController: UIViewController {
    
    private let graffitiBackdropImageView = createGraffitiImageView(named: "BG", contentMode: .scaleAspectFill)
    private let graffitiCloseButton = createGraffitiButton(withImageNamed: "Close")
    private let graffitiDopImageView = createGraffitiImageViewTwo(named: "BG2")
    private let graffitiInstructionImageView = createGraffitiImageView(named: "Info", contentMode: .scaleAspectFit)
    
    private let graffitiInstructionLabel = createGraffitiLabel(fontName: "Questrian", fontSize: 30, textColor: .white)
    
    var graffitiGame = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGraffitiInterface()
        setupGraffitiInstructionText()
    }
    
    private func configureGraffitiInterface() {
        view.addSubview(graffitiBackdropImageView)
        graffitiBackdropImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(graffitiDopImageView)
        graffitiDopImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(graffitiDopImageView.snp.width).multipliedBy(1.3)
        }
        
        graffitiCloseButton.addTarget(self, action: #selector(graffitiCloseTapped), for: .touchUpInside)
        addGraffitiSound(button: graffitiCloseButton)
        view.addSubview(graffitiCloseButton)
        graffitiCloseButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalToSuperview().inset(10)
            $0.size.equalTo(45)
        }
        
        graffitiDopImageView.addSubview(graffitiInstructionLabel)
        graffitiInstructionLabel.numberOfLines = 0
        graffitiInstructionLabel.textAlignment = .center
        graffitiInstructionLabel.adjustsFontSizeToFitWidth = true
        graffitiInstructionLabel.minimumScaleFactor = 0.49
        graffitiInstructionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.77)
            $0.height.equalTo(graffitiDopImageView.snp.width).multipliedBy(1.2)
        }
        
        view.addSubview(graffitiInstructionImageView)
        graffitiInstructionImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(graffitiDopImageView.snp.top)
            $0.width.equalTo(300)
            $0.height.equalTo(100)
        }
    }
    
    private func setupGraffitiInstructionText() {
        switch graffitiGame {
        case 0:
            graffitiInstructionLabel.text = "You need to stack bottles in a row to earn points. Depending on the difficulty level, your points will be increased, but the number of steps will be reduced."
        case 1:
            graffitiInstructionLabel.text = "You are given an item that you need to find in the picture, and depending on the difficulty, different items will appear. You will earn more points for more difficult items."
        default:
            graffitiInstructionLabel.text = "Three spray bottles shake in a random order, and you need to remember the order and reproduce it. Depending on the difficulty, the points will increase, and the length of the shaking sequence will also increase."
        }
    }
    
    @objc private func graffitiCloseTapped() {
        dismiss(animated: true, completion: nil)
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
    
    private static func createGraffitiImageViewTwo(named imageName: String, contentMode: UIView.ContentMode = .scaleToFill) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = contentMode
        return imageView
    }

}

