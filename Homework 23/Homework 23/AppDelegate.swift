import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
      CoreDataContainer.saveContext()
    }
}
