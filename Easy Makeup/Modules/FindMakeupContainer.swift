import Foundation

protocol FindMakeupContainerProtocol {
    var realmProvider: RealmProviderProtocol { get }
}

public final class FindMakeupContainer: FindMakeupContainerProtocol {
    var realmProvider: RealmProviderProtocol
    
    init(realmProvider: RealmProvider) {
        self.realmProvider = realmProvider
    }
}
