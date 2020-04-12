import UIKit

class MakeupProductsViewController: UIViewController, Storyboarded {
    static var storyboardName = "FindMakeup"

    var coordinator: FindMakeupProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
