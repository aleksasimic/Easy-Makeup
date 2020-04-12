import UIKit

class ProcessSelfieViewController: UIViewController, Storyboarded {
    static var storyboardName = "FindMakeup"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
}
