import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController, Storyboarded {
    static var storyboardName = "FindMakeup"
    
    var coordinator: FindMakeupProtocol?
    
    private let bag = DisposeBag()
    
    @IBOutlet weak var applicationNameLabel: UILabel!
    @IBOutlet weak var takeSelfieButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension HomeViewController {
    func setup() {
        bindActions()
        setupUI()
    }
    
    func bindActions() {
        takeSelfieButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.startTakingSelfie()
            })
            .disposed(by: bag)
    }
}

private extension HomeViewController {
    func setupUI() {
        applicationNameLabel.text = String.ApplicationName
        takeSelfieButton.setTitle(String.TakeSelfie, for: .normal)
    }
}

private extension String {
    static let ApplicationName = "Easy Makeup"
    static let TakeSelfie      = "Take a selfie"
}