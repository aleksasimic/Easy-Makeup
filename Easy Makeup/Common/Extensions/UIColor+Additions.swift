import Foundation
import UIKit

public extension UIColor {
    class func themeGrayColor() -> UIColor {
        return UIColor(red: 102.0/255, green: 102.0/255, blue: 102.0/255, alpha: 1.0)
    }
    
    class func themeGrayColorWithOpacity() -> UIColor {
        return UIColor(red: 102.0/255, green: 102.0/255, blue: 102.0/255, alpha: 0.8)
    }
    
    class func whiteColorWithOpacity() -> UIColor {
        return UIColor(red: 255.0/255, green: 255.0/255, blue: 255.0/255, alpha: 0.5)
    }
}
