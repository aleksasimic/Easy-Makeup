import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MakeupProductsViewController: UIViewController, Storyboarded {
    static var storyboardName = "FindMakeup"
    
    var coordinator: FindMakeupProtocol?
    var viewModelBuilder: MakeupProductsViewModelBuilder?
    
    private let bag = DisposeBag()
    
    @IBOutlet weak var stepIndicatorView: StepIndicatorView!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var buyProductButton: UIButton!
    @IBOutlet weak var popupView: PopupView!
    @IBOutlet weak var bottomNavigationView: BottomNavigationView!
    @IBOutlet weak var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension MakeupProductsViewController {
    func setup() {
        setupUI()
        setupViewModel()
        bindActions()
    }
    
    func setupViewModel() {
        if let viewModel = createViewModel() {
            bindViewModel(viewModel)
            setupDataSource(withData: viewModel.products)
        }
    }
    
    func createViewModel() -> MakeupProductsViewModel? {
        return viewModelBuilder?(loadTrigger)
    }
    
    func bindViewModel(_ viewModel: MakeupProductsViewModel) {
        viewModel.currentStep
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.stepIndicatorView.setupViews(forStep: $0)
                self?.bottomNavigationView.setupViewForCurrentStep(step: $0)
            })
            .disposed(by: bag)
    }
    
    func bindActions() {
        bottomNavigationView.navigateBackStackView.rx.tapGesture().skip(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.goBack()
            })
            .disposed(by: bag)
        
        buyProductButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.showProductsWebsite()
            })
            .disposed(by: bag)
        
        popupView.closeButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.popupView.isHidden = true
            })
            .disposed(by: bag)
    }
    
    func setupDataSource(withData data: Observable<[Product]>) {
        _ = MakeupProductsDatasource(withTableView: productsTableView, products: data)
    }
}

private extension MakeupProductsViewController {
    func setupUI() {
        footerView.layer.addBorder(edge: .top, color: UIColor.themeGrayColor(), thickness: 0.5)
    }
}
