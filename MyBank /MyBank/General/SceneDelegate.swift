import UIKit

@available(iOS 13.0, *)
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let show = UserDefaults.standard.bool(forKey: "TutorialShown")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let tutorialScene = storyboard.instantiateViewController(withIdentifier: "TutorialScene") as? TutorialScene
        let mainSceneNavigation = storyboard.instantiateViewController(withIdentifier: "MainSceneNavigation")
        
        
        if let window = self.window {
            
            if show {
                
                window.rootViewController = mainSceneNavigation
                
            } else {
                
                window.rootViewController = tutorialScene
                UserDefaults.standard.set(true, forKey: "TutorialShown")
            }
        }
    }
}
