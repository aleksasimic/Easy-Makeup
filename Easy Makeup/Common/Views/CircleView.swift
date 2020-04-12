import Foundation
import UIKit

@IBDesignable class CircleView: UIView {
    
    @IBInspectable var circleColor: UIColor = UIColor.white {
        didSet {
            self.backgroundColor = circleColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = bounds.size.width/2
    }
}
