
import UIKit

final class CatsAnimation: UIViewController {
    
    @IBOutlet private weak var trashButton: UIBarButtonItem!
    
    private var catImages: [CGImage?] = []
    
    private var imagesSize : CGSize = .zero
    
    private var animationsDuration: Double = 2
    
    private var touchesCount: Int = 0
    
    private var oneCatScaled: Bool = false
    
    private var defaultLayerPosition: CGPoint = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCats()
        trashButton.tintColor = .gray
    }
    
    @IBAction func trashButtonTaped(_ sender: UIBarButtonItem) {
        view.layer.sublayers?.removeAll()
        touchesCount = 0
        oneCatScaled = false
    }
    
    private func configureCats() {
        
        catImages = [ UIImage(named: "cat1")?.cgImage, UIImage(named: "cat2")?.cgImage, UIImage(named: "cat3")?.cgImage, UIImage(named: "cat4")?.cgImage, UIImage(named: "cat5")?.cgImage]
        imagesSize = CGSize(width: 150, height: 150)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
      touchesCount += 1
        
        if let touch = touches.first {
            let location = touch.location(in: view)
            
            if touchesCount <= 5 {
                
                drawingCats(image: catImages[touchesCount - 1]!, touchLocation: location)
                
            } else {
                
                for catSublayer in view.layer.sublayers! {
                    
                    if let currentLayer = catSublayer.hitTest(location) {
                        
                        if currentLayer.frame.width == imagesSize.width && oneCatScaled == false {
                            
                            scale(layerToScale: currentLayer, layerLocation: location)
                            oneCatScaled = true
                            
                        } else if currentLayer.frame.width > imagesSize.width {
                            
                            unscale(layerToUnScale: currentLayer)
                            oneCatScaled = false
                        }
                    }
                }
            }
        }
    }
    
    private func drawingCats(image: CGImage, touchLocation: CGPoint) {
        
               let imageLayer = CALayer()
               imageLayer.frame = CGRect(x: touchLocation.x - (imagesSize.width / 2), y: touchLocation.y - (imagesSize.height / 2), width: imagesSize.width, height: imagesSize.height)
               imageLayer.contents = image
               imageLayer.cornerRadius = 8
               imageLayer.masksToBounds = true
               
               let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
               rotateAnimation.fromValue = 10
               rotateAnimation.toValue = 0
        
               let fadeAnimations = CABasicAnimation(keyPath: "opacity")
               fadeAnimations.fromValue = 0
               fadeAnimations.toValue = 1
               
               let animationGroup = CAAnimationGroup()
               animationGroup.animations = [
                   rotateAnimation,
                   fadeAnimations
               ]
               animationGroup.duration = animationsDuration
               imageLayer.add(animationGroup, forKey: nil)

               view.layer.addSublayer(imageLayer)
        
    }

    private func scale(layerToScale: CALayer, layerLocation: CGPoint) {
        
        layerToScale.removeFromSuperlayer()
        view.layer.insertSublayer(layerToScale, at: UInt32(view.layer.sublayers!.count))
        
        let newFrame = CGRect(x: view.bounds.minX, y: view.bounds.midY - imagesSize.height * 1.5 / 2, width: view.bounds.width, height: imagesSize.height * 1.5)
        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.fromValue = layerToScale.frame
        boundsAnimation.toValue = newFrame
        
        let newPosition = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        let frameAnimation = CABasicAnimation(keyPath: "position")
        frameAnimation.fromValue = layerToScale.position
        frameAnimation.toValue = newPosition
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [
            boundsAnimation,
            frameAnimation
        ]
        animationGroup.duration = animationsDuration
        
        defaultLayerPosition = layerToScale.position
        layerToScale.frame = newFrame
        layerToScale.add(animationGroup, forKey: nil)
        
    }
    
    private func unscale(layerToUnScale: CALayer) {
        
        layerToUnScale.removeFromSuperlayer()
        view.layer.insertSublayer(layerToUnScale, at: UInt32(view.layer.sublayers!.count))
        
        let newFrame = CGRect(x: defaultLayerPosition.x - imagesSize.width / 2, y: defaultLayerPosition.y - imagesSize.height / 2, width: imagesSize.width, height: imagesSize.height )
        
        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.fromValue = layerToUnScale.frame
        boundsAnimation.toValue = newFrame
        
        let frameAnimation = CABasicAnimation(keyPath: "position")
        frameAnimation.fromValue = layerToUnScale.position
        frameAnimation.toValue = defaultLayerPosition
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [
            boundsAnimation,
            frameAnimation
        ]
        animationGroup.duration = animationsDuration
        
        layerToUnScale.frame = newFrame
        layerToUnScale.add(animationGroup, forKey: nil)
        
    }
    
}
