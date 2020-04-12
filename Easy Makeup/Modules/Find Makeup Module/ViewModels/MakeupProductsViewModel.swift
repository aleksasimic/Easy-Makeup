import RxSwift

typealias MakeupProductsViewModelBuilder = (_ loadTrigger: Observable<Void>) -> MakeupProductsViewModel

struct MakeupProductsViewModel {
    let products: Observable<[Product]>

    init(loadTrigger: Observable<Void>, realmProvider: RealmProviderProtocol) {
        
        products = loadTrigger
            .flatMapLatest {
                realmProvider.getDataFromRealm()
            }
    }
}
