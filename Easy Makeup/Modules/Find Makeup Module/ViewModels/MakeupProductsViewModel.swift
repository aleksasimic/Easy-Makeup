import RxSwift

typealias MakeupProductsViewModelBuilder = (_ loadTrigger: Observable<Void>) -> MakeupProductsViewModel

struct MakeupProductsViewModel {
    let products: Observable<[Product]>
    let currentStep: Observable<CurrentStep>

    init(loadTrigger: Observable<Void>, currentStep: Observable<CurrentStep>,  realmProvider: RealmProviderProtocol) {
        
        products = loadTrigger
            .flatMapLatest {
                realmProvider.getDataFromRealm()
            }
        
        self.currentStep = currentStep
    }
}
