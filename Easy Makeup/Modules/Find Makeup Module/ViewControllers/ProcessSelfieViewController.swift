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
    @IBOutlet weak var bottomNavigationView: BottomNavigationView!
    @IBOutlet weak var currentImageView: UIImageView!
    
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
                self?.setupViewsForStep(step: $0)
            })
            .disposed(by: bag)
        
        viewModel.image
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.currentImageView.image = $0
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
        
        popupView.closeButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.popupView.isHidden = true
            })
            .disposed(by: bag)
    }
}

extension ProcessSelfieViewController {
    func setupViewsForStep(step: CurrentStep) {
        stepIndicatorView.setupViews(forStep: step)
        bottomNavigationView.setupViewForCurrentStep(step: step)
        popupView.setupViews(forStep: step)
        colorPickerStackView.isHidden = step != .pickColor
    }
    
    func backActionForStep(step: CurrentStep) {
        if step == .takeSelfie {
            coordinator?.showImagePicker()
        }
    }
}

extension ProcessSelfieViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        currentImageView.image = image
    }
}
