import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MakeupProductsViewController: UIViewController, Storyboarded {
    static var storyboardName = "FindMakeup"
    
    var coordinator: FindMakeupProtocol?
    var viewModelBuilder: MakeupProductsViewModelBuilder?
    var dataSource: MakeupProductsDatasource!
    
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
    }
    
    func setupViewModel() {
        if let viewModel = createViewModel() {
            bindViewModel(viewModel)
            dataSource = setupDataSource(withData: viewModel.products)
            bindActions(dataSource)
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
    
    func bindActions(_ dataSource: MakeupProductsDatasource) {
        bottomNavigationView.navigateBackStackView.rx.tapGesture().skip(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.goBack()
            })
            .disposed(by: bag)
        
        buyProductButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.showProductsWebsite(forSelectedProducts: dataSource.selectedProducts)
                self?.dataSource.emptySelected()
            })
            .disposed(by: bag)
        
        popupView.closeButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.popupView.isHidden = true
            })
            .disposed(by: bag)
    }
    
    func setupDataSource(withData data: Observable<[Product]>) -> MakeupProductsDatasource {
        return MakeupProductsDatasource(withTableView: productsTableView, products: data)
    }
}

private extension MakeupProductsViewController {
    func setupUI() {
        footerView.layer.addBorder(edge: .top, color: UIColor.themeGrayColor(), thickness: 0.5)
    }
}
