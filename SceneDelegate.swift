import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        // Debug: force root view controller to assist UI visibility checks
        let vc = ViewController(nibName: nil, bundle: nil)
        vc.view.backgroundColor = .systemRed // debug visual confirmation
        let nav = UINavigationController(rootViewController: vc)
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
        print("SceneDelegate: window and rootViewController set")
    }
}
