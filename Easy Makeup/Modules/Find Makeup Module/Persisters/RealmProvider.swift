import Foundation
import RealmSwift
import RxSwift

protocol RealmProviderProtocol {
    func saveDataToRealm()
    func getDataFromRealm() -> Observable<[Product]>
}

final class RealmProvider: RealmProviderProtocol {
    func saveDataToRealm() {
        let realm = try! Realm()
        let products: Results<Product> = realm.objects(Product.self)
        if products.count == 0 {
            try! realm.write() {
                let newProducts = initializeProducts()
                for product in newProducts {
                    realm.add(product)
                }
            }
        }
    }
    
    func getDataFromRealm() -> Observable<[Product]> {
        var productList: [Product] = []
        let realm = try! Realm()
        let products: Results<Product> = realm.objects(Product.self)
        
        for item in products {
            productList.append(item)
        }
        
        return Observable.just(productList)
    }
    
    private func initializeProducts() -> [Product] {
        var productList: [Product]
        
        let product1 = Product()
        product1.name = "Product 1"
        product1.price = 35.50
        product1.percentage = 35
        product1.imageUrl = ""
        
        let product2 = Product()
        product2.name = "Product2"
        product2.price = 35.50
        product2.percentage = 25
        product2.imageUrl = ""
        
        let product3 = Product()
        product3.name = "Product 3"
        product3.price = 25
        product3.percentage = 40
        product3.imageUrl = ""
        
        productList = [product1, product2, product3]
        
        return productList
    }
}
