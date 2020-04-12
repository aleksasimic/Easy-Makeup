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
        guard let currentVc = navigationController.topViewController else { return }
        
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.sourceType = .camera
        } else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = currentVc as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.modalPresentationStyle = .overFullScreen
        
        currentVc.present(imagePicker, animated: true, completion: nil)
    }
    
    func showProducts() {
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
