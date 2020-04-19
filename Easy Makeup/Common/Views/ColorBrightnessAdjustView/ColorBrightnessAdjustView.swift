import UIKit
import RxSwift

class ColorBrightnessAdjustView: UIView {
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var choosenColorCircleView: CircleView!
    @IBOutlet weak var adjustBrightnessView: UIView!
    @IBOutlet weak var adjustBrightnessIndicatorView: UIView!
    @IBOutlet weak var substractButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var adjustBrightnessIndicatorViewWidth: NSLayoutConstraint!
    
    fileprivate let bag = DisposeBag()
    
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
        self.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.clear
        addSubview(view)
        bindActions()
    }
    
    private func loadFromNib() -> UIView {
        return UINib(nibName: "ColorBrightnessAdjustView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    private func bindActions() {
        addButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.setupBrightnessIncrease()
            })
            .disposed(by: bag)
        
        substractButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.setupBrightnessDecrease()
            })
            .disposed(by: bag)
    }
    
    private func setupBrightnessIncrease() {
        let step = adjustBrightnessView.frame.width * 0.01
        let brightnessViewFrameWidth = adjustBrightnessView.frame.width
        
        if adjustBrightnessIndicatorViewWidth.constant + step >= brightnessViewFrameWidth {
            adjustBrightnessIndicatorViewWidth.constant = brightnessViewFrameWidth
        } else {
            adjustBrightnessIndicatorViewWidth.constant += step
            choosenColorCircleView.backgroundColor = choosenColorCircleView.backgroundColor?.makeLighter()
        }
    }
    
    private func setupBrightnessDecrease() {
        let step = adjustBrightnessView.frame.width * 0.01
        if adjustBrightnessIndicatorViewWidth.constant - step <= 0 {
            adjustBrightnessIndicatorViewWidth.constant = 0
        } else {
            adjustBrightnessIndicatorViewWidth.constant -= step
            choosenColorCircleView.backgroundColor = choosenColorCircleView.backgroundColor?.makeDarker()
        }
    }
}
