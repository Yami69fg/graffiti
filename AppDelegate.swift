import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var mainWindow: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.mainWindow = UIWindow(frame: UIScreen.main.bounds)
        self.mainWindow?.rootViewController = UINavigationController(rootViewController: GraffitiLoadingController())
        self.mainWindow?.makeKeyAndVisible()
        
        if UserDefaults.standard.object(forKey: "isSoundOn") == nil {
            UserDefaults.standard.set(true, forKey: "isSoundOn")
        }
        if UserDefaults.standard.object(forKey: "isVibrationOn") == nil {
            UserDefaults.standard.set(true, forKey: "isVibrationOn")
        }
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return .portrait
    }


}

