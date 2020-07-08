import UIKit

final class ShareScene: UIViewController {
    
    @IBOutlet public weak var tableView: UITableView!
    
    @IBOutlet public weak var bankTitle: UILabel!
    
    @IBOutlet public weak var bankRegion: UILabel!
    
    @IBOutlet public weak var bankCity: UILabel!
    
    @IBOutlet public weak var shareButton: UIButton!
    
    @IBOutlet private weak var containerView: UIView!
    
    public var data = MainData()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureData()
        configureTableView()
        configureAppearance()
    }
    
    //MARK: - Private
    
    private func configureTableView() {
        
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
    }
    
    private func configureData() {
        
        bankTitle.text = data.title
        bankRegion.text = data.region
        bankCity.text = data.city
    }
    
    private func configureAppearance() {
        
        containerView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 8)
        shareButton.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
    }
    
    private func navigateToMainScreen() {
        
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            
            dismiss(animated: false, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            
            owningNavigationController.popViewController(animated: false)
        }
        
        dismiss(animated: false, completion: nil)
    }
    
    //MARK: - Actions
    @IBAction func shareButtonTaped(_ sender: Any) {
        
        let bounds = containerView.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.containerView.drawHierarchy(in: bounds, afterScreenUpdates: false)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            
            return assertionFailure("incorrect image")
        }
        UIGraphicsEndImageContext()
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

//MARK: - TableViewDataSource

extension ShareScene: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        data.currency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareSceneCell", for: indexPath)
        
        if let currentCell = cell as? ShareSceneCell {
            
            let currentCurrency = data.currency[indexPath.row]
            
            currentCell.currencySymbol.text = currentCurrency.symbol
            currentCell.currencySymbol.sizeToFit()
            
            if let ask = currentCurrency.ask, let bid = currentCurrency.bid {
                
            currentCell.currencyDescription.text = ask + "/" + bid
            currentCell.currencyDescription.sizeToFit()
            }
        }
        
        return cell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let touchLocation =  touch.location(in: self.view)
            
            if (containerView.layer.hitTest(touchLocation) == nil)  {
                
                navigateToMainScreen()
            }
        }
    }
}

extension UIView {
    
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
    
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
