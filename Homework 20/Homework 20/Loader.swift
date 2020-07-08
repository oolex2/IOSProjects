
import UIKit

class Loader: UIViewController {
    
    @IBOutlet private weak var progressTitle: UILabel!
    
    @IBOutlet private weak var progressButton: UIButton!
    
    @IBOutlet private weak var trashButton: UIBarButtonItem!
    
    private var startAngle: CGFloat = CGFloat(3 * Double.pi / 2)
    
    private var progress: Double = 20
    
    private var loaderPathWidth: CGFloat = 10
    
    private var loadingDuration: TimeInterval = 2
    
    private var progressCounter: Double = 0
    
    private var progressTimer: Timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundCircle()
        configureTitleFont()
        trashButton.tintColor = .gray

    }
    
    private func configureTitleFont() {
        
        progressTitle.font = UIFont.systemFont(ofSize: 35)
        let mixedFontTitle = NSMutableAttributedString.init(string: "0.0%")
        mixedFontTitle.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 65)], range: NSMakeRange(0, 3))
        progressTitle.attributedText = mixedFontTitle
        
    }

    private func backgroundCircle() {
        
        let circleShapelayer = CAShapeLayer()
        let circleRadius = CGFloat(view.bounds.width/3 - (loaderPathWidth/2))
        let circleCenter = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        circleShapelayer.path = circlePath.cgPath
        circleShapelayer.fillColor = UIColor.clear.cgColor
        circleShapelayer.strokeColor = UIColor.gray.cgColor
        circleShapelayer.lineWidth = loaderPathWidth
        view.layer.addSublayer(circleShapelayer)
        
    }

    private func progressCircle() {
        
        let progressShapeLayer: CAShapeLayer = CAShapeLayer()
        let circleRadius = CGFloat(view.bounds.width/3 - (loaderPathWidth/2))
        let circleCenter = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        let endAngle = CGFloat((-90.0 + 3.6 * progress).radian())
        let progressPath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle:  startAngle , endAngle: endAngle, clockwise: true)
        
        startAngle = endAngle
        progressShapeLayer.path = progressPath.cgPath
        progressShapeLayer.fillColor = UIColor.clear.cgColor
        progressShapeLayer.strokeColor = UIColor.blue.cgColor
        progressShapeLayer.lineWidth = loaderPathWidth
        
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.fromValue = 0
        circularProgressAnimation.duration = loadingDuration
        circularProgressAnimation.toValue = 1.0
        progressShapeLayer.add(circularProgressAnimation, forKey: nil)
        view.layer.addSublayer(progressShapeLayer)
        
        let titleAnimation = CABasicAnimation(keyPath: "transform.scale")
        titleAnimation.fromValue = 1
        titleAnimation.toValue = 1.2
        titleAnimation.duration = 0.2
        titleAnimation.autoreverses = true
        titleAnimation.repeatDuration = loadingDuration
        progressTitle.layer.add(titleAnimation, forKey: nil)
        
    }
    
    @IBAction func trashButtonTaped(_ sender: UIBarButtonItem) {
        
        startAngle = CGFloat(3 * Double.pi / 2)
        progressTimer = Timer()
        progressCounter = 0
        progress = 20
        configureTitleFont()
        progressButton.isHidden = false
        backgroundCircle()
        
    }
    
    @IBAction private func buttaped(_ sender: UIButton) {
        
        progressTimer = Timer.scheduledTimer(timeInterval: 0.05 , target: self, selector: #selector(updateProgressTitle), userInfo: nil, repeats: true)
            progressCircle()
        
    }
    
    @objc private func updateProgressTitle() {
        
        if progressCounter <= progress {
            
            if progressCounter >= 100 {
                
                progressTimer.invalidate()
                progressButton.isHidden = true
                
            }
            
        let titlePercentage = "\(progressCounter)%"
        progressTitle.font = UIFont.systemFont(ofSize: 35)
        let mixedFontTitle = NSMutableAttributedString.init(string: titlePercentage)
        mixedFontTitle.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 65)], range: NSMakeRange(0, titlePercentage.count - 1))
        progressTitle.attributedText = mixedFontTitle
        progressCounter = progressCounter + 0.5
        progressButton.isHidden = true
            
      } else {
            progress = progress + Double.random(in: 15...25)
            
            progressTimer.invalidate()
            progressButton.isHidden = false
        }
        
    }

}

extension Double {
    
    public func radian() -> Double {
         self * .pi / 180
    }
    
}
