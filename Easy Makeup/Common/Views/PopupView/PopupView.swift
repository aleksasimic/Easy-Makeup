import UIKit

class PopupView: UIView {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        view = loadFromNib()
        view.frame = bounds
        view.layer.addBorder(edge: .top, color: UIColor.gray, thickness: 0.5)
        addSubview(view)
    }
    
    private func loadFromNib() -> UIView {
        return UINib(nibName: "PopupView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    private func setupLabels(forStep step: CurrentStep) {
        switch step {
        case .pickColor:
            descriptionLabel.text = String.ColorPickerPopupText
        case .chooseProducts:
            descriptionLabel.text = String.ColorPickerPopupText
        default:
            break
        }
    }
}

private extension String {
    static let ColorPickerPopupText = "Tap on your face where you like your skin tone most"
    static let ChooseProductsPopupText = "Use this product to achieve your wanted skin"
}
