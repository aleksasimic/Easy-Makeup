import UIKit
import RxSwift

final class FindMakeupCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    public init (navigationController: UINavigationController) {
        self.navigationController = navigationController 
    }
    
    func start() {
        let vc = HomeViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension FindMakeupCoordinator: FindMakeupProtocol {
    func startTakingSelfie() {
        let vc = MakeupProductsViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
