import UIKit
import Firebase
//import DevReelsKit
//import DevReelsUI
import FirebaseStorage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        DIContainer.shared.inject()
        FirebaseApp.configure()
        //        DevReelsKit.hello()
        //        DevReelsUI.hello()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return true
    }
}
