import UIKit
import Firebase
//import DevReelsKit
//import DevReelsUI

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
        
        print("제발좀 열려주세요 앱님아")

        return true
    }

    
    
}
