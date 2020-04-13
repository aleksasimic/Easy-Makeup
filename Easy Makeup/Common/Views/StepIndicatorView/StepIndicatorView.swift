import UIKit

class StepIndicatorView: UIView {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var takeSelfieStepLabel: UILabel!
    @IBOutlet weak var pickColorStepLabel: UILabel!
    @IBOutlet weak var chooseProductStepLabel: UILabel!
    
    @IBOutlet weak var stepOneCircleView: CircleView!
    @IBOutlet weak var stepTwoCircleView: CircleView!
    @IBOutlet weak var stepThreeCircleView: CircleView!
    
    @IBOutlet weak var firstToSecondLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondToThirdLineHeightConstraint: NSLayoutConstraint!
    
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
        setupViews(forStep: .chooseProducts)
    }
    
    private func loadFromNib() -> UIView {
        return UINib(nibName: "StepIndicatorView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func setupLabels() {
        takeSelfieStepLabel.text = String.Step
        pickColorStepLabel.text = String.Step
        chooseProductStepLabel.text = String.Step
    }
    
    func setupViews(forStep step: CurrentStep) {
        switch step {
        case .notStarted:
            setupNotStarted()
        case .takeSelfie:
            setupTakeSelfieStep()
        case .pickColor:
            setupPickColorStep()
        case .chooseProducts:
            setupChooseProductsStep()
        }
    }

    private func setupNotStarted() {
        stepOneCircleView.circleColor = UIColor.clear
        stepTwoCircleView.circleColor = UIColor.clear
        stepThreeCircleView.circleColor = UIColor.clear
        firstToSecondLineHeightConstraint.constant = 1.0
        secondToThirdLineHeightConstraint.constant = 1.0
        self.view.backgroundColor = UIColor.themeGrayColor()
    }

    private func setupTakeSelfieStep() {
        stepOneCircleView.circleColor = UIColor.white
        stepTwoCircleView.circleColor = UIColor.clear
        stepThreeCircleView.circleColor = UIColor.clear
        firstToSecondLineHeightConstraint.constant = 1.0
        secondToThirdLineHeightConstraint.constant = 1.0
        self.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.themeGrayColorWithOpacity()
    }

    private func setupPickColorStep() {
        stepOneCircleView.circleColor = UIColor.white
        stepTwoCircleView.circleColor = UIColor.white
        stepThreeCircleView.circleColor = UIColor.clear
        firstToSecondLineHeightConstraint.constant = 2.0
        secondToThirdLineHeightConstraint.constant = 1.0
        self.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.themeGrayColorWithOpacity()
    }

    private func setupChooseProductsStep() {
        stepOneCircleView.circleColor = UIColor.white
        stepTwoCircleView.circleColor = UIColor.white
        stepThreeCircleView.circleColor = UIColor.white
        firstToSecondLineHeightConstraint.constant = 2.0
        secondToThirdLineHeightConstraint.constant = 2.0
        self.view.backgroundColor = UIColor.themeGrayColor()
    }
}

private extension String {
    static let Step = "Step"
}
