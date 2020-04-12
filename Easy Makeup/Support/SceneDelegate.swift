import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: FindMakeupCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let applicationWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
        applicationWindow.windowScene = windowScene
        
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        
        let realmProvider = RealmProvider()
        realmProvider.saveDataToRealm()
        let container = FindMakeupContainer(realmProvider: realmProvider)
        coordinator = FindMakeupCoordinator(navigationController: navigationController, container: container)
        coordinator?.start()
        
        applicationWindow.rootViewController = navigationController
        applicationWindow.makeKeyAndVisible()
        
        window = applicationWindow
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    
}

