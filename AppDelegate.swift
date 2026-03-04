import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? // fallback window for iOS versions or SceneDelegate issues

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure audio session for background playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session: \(error)")
        }

        // Fallback: if SceneDelegate is not used or window not set, create a window and set root
        if #available(iOS 13.0, *) {
            // SceneDelegate normally handles the window for iOS 13+
            // But create a fallback window only if none is present later
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) == nil {
                    self.setupFallbackWindow()
                }
            }
        } else {
            // iOS 12 or earlier: set up window directly
            setupFallbackWindow()
        }

        return true
    }

    private func setupFallbackWindow() {
        let vc = ViewController()
        let nav = UINavigationController(rootViewController: vc)
        let win = UIWindow(frame: UIScreen.main.bounds)
        win.rootViewController = nav
        win.makeKeyAndVisible()
        self.window = win
        print("AppDelegate: fallback window set")
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
