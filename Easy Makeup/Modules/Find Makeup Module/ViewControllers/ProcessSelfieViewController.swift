import UIKit
import RxSwift

class ProcessSelfieViewController: UIViewController, Storyboarded {
    static var storyboardName = "FindMakeup"
    
    var coordinator: FindMakeupProtocol?
    var viewModelBuilder: ProcessSelfieViewModelBuilder?
    
    private let bag = DisposeBag()
    
    @IBOutlet weak var stepIndicatorView: StepIndicatorView!
    @IBOutlet weak var popupView: PopupView!
    @IBOutlet weak var colorPickerStackView: UIStackView!
    @IBOutlet weak var colorPickerAdjustView: ColorBrightnessAdjustView!
    @IBOutlet weak var bottomNavigationView: BottomNavigationView!
    @IBOutlet weak var currentImageView: CiImageView!
    
    
    lazy var circledView: CircleView = {
        let circledView = CircleView(frame: CGRect(x: view.center.x-15, y: view.center.y+30, width: 30, height: 30))
        circledView.backgroundColor = UIColor.clear
        circledView.borderWidth = 2
        circledView.borderColor = UIColor.white
        return circledView
    }()
    
    var currentStep: CurrentStep?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension ProcessSelfieViewController {
    func setup() {
        if let viewModel = createViewModel() {
            bindViewModel(viewModel)
            bindActions(viewModel)
        }
    }
    
    func createViewModel() -> ProcessSelfieViewModel? {
        return viewModelBuilder?(bottomNavigationView.navigateNextStackView.rx.tapGesture().skip(1).map {_ in },
                                 bottomNavigationView.navigateBackStackView.rx.tapGesture().skip(1).map {_ in })
    }
    
    func bindViewModel(_ viewModel: ProcessSelfieViewModel) {
        viewModel.step
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.setupCurrentStep($0)
                self?.setupViewsForStep(step: $0)
            })
            .disposed(by: bag)
        
        viewModel.image
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.setupViewsForImage(image: $0)
            })
            .disposed(by: bag)
        
    }
    
    func bindActions(_ viewModel: ProcessSelfieViewModel) {
        bottomNavigationView.navigateBackStackView.rx.tapGesture().skip(1)
            .withLatestFrom(viewModel.step)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.backActionForStep(step: $0)
            })
            .disposed(by: bag)
        
        bottomNavigationView.navigateNextStackView.rx.tapGesture().skip(1)
            .withLatestFrom(viewModel.step)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [weak self] in
                self?.nextActionForStep(step: $0)
            })
            .disposed(by: bag)
        
        popupView.closeButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.popupView.isHidden = true
            })
            .disposed(by: bag)
        
        Observable.combineLatest(currentImageView.rx.anyGesture(.tap(), .pan()).skip(2), viewModel.step)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] gesture, step in
                if step != .takeSelfie {
                    let view = gesture.view
                    let location = gesture.location(in: view)
                    self?.updateViewsForLocation(location: location)
                }
            })
            .disposed(by: bag)
    }
}

extension ProcessSelfieViewController {
    func updateViewsForLocation(location: CGPoint) {
        circledView.frame.origin.x = location.x - 15
        circledView.frame.origin.y = location.y + 30
        let color = currentImageView.getAverageColor(x: location.x, y: location.y)
        colorPickerAdjustView.choosenColorCircleView.backgroundColor = color
    }
    
    func setupViewsForStep(step: CurrentStep) {
        stepIndicatorView.setupViews(forStep: step)
        bottomNavigationView.setupViewForCurrentStep(step: step)
        popupView.setupViews(forStep: step)
        colorPickerStackView.isHidden = step != .pickColor
        setupCircledPickerView(step: step)
    }
    
    
    func setupCircledPickerView(step: CurrentStep) {
        if step == .pickColor {
            view.addSubview(circledView)
            circledView.frame.origin.x = view.center.x - 15
            circledView.frame.origin.y = view.center.y + 30
        } else if step == .takeSelfie {
            if let circledView = self.view.subviews[self.view.subviews.count-1] as? CircleView {
                circledView.removeFromSuperview()
            }
        }
    }
    
    func backActionForStep(step: CurrentStep) {
        if step == .takeSelfie {
            coordinator?.showImagePicker()
        }
    }
    
    func nextActionForStep(step: CurrentStep) {
        if self.currentStep == .chooseProducts {
            coordinator?.showProducts(forColor: colorPickerAdjustView.choosenColorCircleView.backgroundColor)
        }
    }
    
    func setupViewsForImage(image: UIImage) {
        currentImageView.image = image
        currentImageView.ciImage = CIImage(image: image)
        colorPickerAdjustView.choosenColorCircleView.backgroundColor = UIColor.clear
    }
}

extension ProcessSelfieViewController {
    func setupCurrentStep(_ step: CurrentStep) {
        if (currentStep == .pickColor || currentStep == .chooseProducts) && step == .pickColor {
            currentStep = .chooseProducts
        } else {
            currentStep = step
        }
    }
}

extension ProcessSelfieViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        setupViewsForImage(image: image)
    }
}

