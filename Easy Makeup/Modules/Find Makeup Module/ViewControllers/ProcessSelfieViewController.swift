import UIKit
import RxSwift

class ProcessSelfieViewController: UIViewController, Storyboarded {
    static var storyboardName = "FindMakeup"
    
    var coordinator: FindMakeupProtocol?
    var viewModelBuilder: ProcessSelfieViewModelBuilder?
    
    private let bag = DisposeBag()
    
    @IBOutlet weak var stepIndicatorView: StepIndicatorView!
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
        }
    }
    
    func createViewModel() -> ProcessSelfieViewModel? {
        return viewModelBuilder?()
    }
    
    func bindViewModel(_ viewModel: ProcessSelfieViewModel) {
        viewModel.step
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.stepIndicatorView.setupViews(forStep: $0)
                self?.bottomNavigationView.setupViewForCurrentStep(step: $0)
            })
            .disposed(by: bag)
        
        viewModel.currentImage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.currentImageView.image = $0
            })
            .disposed(by: bag)
    }
}
