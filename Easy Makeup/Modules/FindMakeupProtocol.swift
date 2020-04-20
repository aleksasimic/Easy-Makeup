import UIKit

protocol FindMakeupProtocol {
    func showImagePicker()
    func startProcessingImage(image: UIImage)
    func showProducts(forColor color: UIColor?)
    func goBack()
    func showProductsWebsite(forSelectedProducts products: [Product])
}
