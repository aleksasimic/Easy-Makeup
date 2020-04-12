import UIKit
import RxSwift
import RxCocoa

class MakeupProductsViewController: UIViewController, Storyboarded {
    static var storyboardName = "FindMakeup"

    var coordinator: FindMakeupProtocol?
    var viewModelBuilder: MakeupProductsViewModelBuilder?
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension MakeupProductsViewController {
    func setup() {
        if let viewModel = createViewModel() {
            bindViewModel(viewModel)
        }
    }
    
    func createViewModel() -> MakeupProductsViewModel? {
        return viewModelBuilder?(loadTrigger)
    }
    
    func bindViewModel(_ viewModel: MakeupProductsViewModel) {
        viewModel.products
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: bag)
    }
}
