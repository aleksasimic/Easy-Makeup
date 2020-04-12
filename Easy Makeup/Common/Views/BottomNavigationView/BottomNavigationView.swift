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
    
    func shouldHideNextButton(hidden: Bool) {
        navigateNextStackView.isHidden = hidden
    }
    
    func setupLabels() {
        backLabel.text = String.Back
        nextLabel.text = String.Next
    }
}

private extension String {
    static let Back = "Back"
    static let Next = "Next step"
}
