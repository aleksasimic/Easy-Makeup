import UIKit
extension UINavigationController {
    
    public func pushViewController(_ viewController: UIViewController, animated: Bool, delay: Double? = nil, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)
        
        if let interval = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                completion()
            }
            return
        }
        
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}
