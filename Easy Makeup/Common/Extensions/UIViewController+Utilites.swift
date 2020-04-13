import Foundation
import UIKit

extension UIViewController {
    func setBackgroundImage(image: UIImage) {
        let backgroundImageView = UIImageView(frame: self.view.frame)
        backgroundImageView.image = image
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImageView, at: 0)
    }
}
