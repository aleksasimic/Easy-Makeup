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
    func showImagePicker() {
        guard let vc = navigationController.topViewController else { return }
        presentImagePicker(inViewController: vc)
    }
    
    func startProcessingImage(image: UIImage) {
        let vc = ProcessSelfieViewController.instantiate()
        vc.coordinator = self
        vc.viewModelBuilder = { goToNextStepTrigger, goToPreviousStepTrigger in
            ProcessSelfieViewModel(goToNextStepTrigger: goToNextStepTrigger, goToPreviousStepTrigger: goToPreviousStepTrigger, step: Observable.just(CurrentStep.takeSelfie), image: Observable.just(image))
        }
        
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showProducts(forColor color: UIColor?) {
        //The color will be probably used to fetch appropriate products for user
        
        let vc = MakeupProductsViewController.instantiate()
        vc.coordinator = self
        vc.viewModelBuilder = { loadTrigger in
            MakeupProductsViewModel(loadTrigger: loadTrigger,
                                    currentStep: Observable.just(CurrentStep.chooseProducts),
                                    realmProvider: self.container.realmProvider)
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showProductsWebsite(forSelectedProducts products: [Product]) {
        //The products will probably be used to show appropriate website or page on website for selected products
        
        guard let url = URL(string: Constants.ProductsLink) else { return }
        
        let svc = SFSafariViewController(url: url)
        navigationController.present(svc, animated: true, completion: nil)
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
    
    func presentImagePicker(inViewController vc: UIViewController) {
        container.imagePicker.delegate = vc as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        vc.present(container.imagePicker, animated: true, completion: nil)
    }
}

private struct Constants {
    static let ProductsLink = "https://www.google.com"
}
