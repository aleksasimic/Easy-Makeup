import Foundation
import UIKit

class CiImageView: UIImageView {
    var ciImage: CIImage?
    
    var context: CIContext = {
        return CIContext(options: [.workingColorSpace: kCFNull!])
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func getAverageColor(x: CGFloat, y: CGFloat) -> UIColor {
        guard let ciImage = self.ciImage else { return UIColor.black }
        
        let newX = (image!.size.width * x) / frame.size.width
        let newY = (image!.size.height * y) / frame.size.height
        
        let extentVector = CIVector(x: newX - 15, y: ciImage.extent.height - (newY+30), z: 30, w: 30)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: ciImage, kCIInputExtentKey: extentVector]) else { return UIColor.black }
        guard let outputImage = filter.outputImage else { return UIColor.black }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}
