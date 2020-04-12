import UIKit
import RxSwift
import SafariServices

final class FindMakeupCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var container: FindMakeupContainer
    
    public init (navigationController: UINavigationController, container: FindMakeupContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let vc = HomeViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension FindMakeupCoordinator: FindMakeupProtocol {
    func startTakingSelfie() {
        //NOTE: This will be changed later on, it is here now because I am developing the part that shows products to user first
        let vc = MakeupProductsViewController.instantiate()
        vc.coordinator = self
        vc.viewModelBuilder = { loadTrigger in
            MakeupProductsViewModel(loadTrigger: loadTrigger,
                                    currentStep: Observable.just(CurrentStep.chooseProducts),
                                    realmProvider: self.container.realmProvider)
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showProductsWebsite() {
        guard let url = URL(string: Constants.ProductsLink) else { return }
        
        let svc = SFSafariViewController(url: url)
        navigationController.present(svc, animated: true, completion: nil)
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}

private struct Constants {
    static let ProductsLink = "https://www.google.com"
}
