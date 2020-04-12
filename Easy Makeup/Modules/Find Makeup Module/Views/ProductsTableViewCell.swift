import UIKit

class ProductsTableViewCell: UITableViewCell {
    
    static let identifier = "ProductsCell"
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDiscountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(withProduct product: Product) {
        let numberFormatter = NumberFormatter.commaSeparatedFormatter
        let formattedNumber = numberFormatter.string(from: NSNumber(value:product.price))
        productNameLabel.text = product.name
        productPriceLabel.text = "\(formattedNumber ?? "") \(CurrencyConstants.CurrencySymbol)"
        productDiscountLabel.text = "\(product.percentage)%"
    }
}
