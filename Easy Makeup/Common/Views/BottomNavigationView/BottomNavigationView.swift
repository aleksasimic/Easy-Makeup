import UIKit

class BottomNavigationView: UIView {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var navigateBackStackView: UIStackView!
    @IBOutlet weak var navigateNextStackView: UIStackView!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    
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
        addSubview(view)
        setupLabels()
    }
    
    private func loadFromNib() -> UIView {
        return UINib(nibName: "BottomNavigationView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func setupViewForCurrentStep(step: CurrentStep) {
        switch step {
        case .takeSelfie:
            setupTakeSelfieStep()
        case .pickColor:
            setupPickColorStep()
        case .chooseProducts:
            setupChooseProductsStep()
        default:
            break
        }
    }
    
    private func setupTakeSelfieStep() {
        backLabel.text = String.TryAgain
        self.backgroundColor = UIColor.themeGrayColorWithOpacity()
    }
    
    private func setupPickColorStep() {
        backLabel.text = String.Back
        self.backgroundColor = UIColor.themeGrayColorWithOpacity()
    }
    
    private func setupChooseProductsStep() {
        backLabel.text = String.Back
        navigateNextStackView.isHidden = true
        self.backgroundColor = UIColor.themeGrayColor()
    }
    
    func setupLabels() {
        nextLabel.text = String.Next
    }
}

private extension String {
    static let Back     = "BACK"
    static let Next     = "NEXT STEP"
    static let TryAgain = "TRY AGAIN"
}
