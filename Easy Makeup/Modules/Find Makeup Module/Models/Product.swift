import Foundation
import RealmSwift

class Product: Object {
    @objc dynamic var name  = ""
    @objc dynamic var price = 0.0
    @objc dynamic var percentage = 0
    @objc dynamic var imageUrl = ""
}
