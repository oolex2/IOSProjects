import UIKit

final class MainSceneCell: UITableViewCell {
    
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var upConatiner: UIView!
    @IBOutlet weak var downContainer: UIView!
    
    private enum Constants {
        
        static let cornerRadius: CGFloat = 4
        static let shadowRadius: CGFloat = 10
        static let shadowOpacity: Float = 0.5
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        configureButtonsAppearance()
        configureCellApearance()
    }
    
    private func configureButtonsAppearance() {
        
        let linkImage = UIImage(named: "link")?.withRenderingMode(.alwaysTemplate)
            linkButton.setBackgroundImage(linkImage, for: .normal)
            linkButton.tintColor = .darkSkyBlue
            linkButton.subviews.first?.contentMode = .scaleAspectFit
            
            let locationImage = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
            locationButton.setBackgroundImage(locationImage, for: .normal)
            locationButton.tintColor = .darkSkyBlue
            locationButton.subviews.first?.contentMode = .scaleAspectFit
            
            let phoneImage = UIImage(named: "phone")?.withRenderingMode(.alwaysTemplate)
            phoneButton.setBackgroundImage(phoneImage, for: .normal)
            phoneButton.tintColor = .darkSkyBlue
            phoneButton.subviews.first?.contentMode = .scaleAspectFit
            
            let menuImage = UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)
            menuButton.setBackgroundImage(menuImage, for: .normal)
            menuButton.tintColor = .darkSkyBlue
            menuButton.subviews.first?.contentMode = .scaleAspectFit
    }
    
    private func configureCellApearance() {
        
        containerView.layer.cornerRadius = Constants.cornerRadius
            containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = Constants.shadowOpacity
            containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = Constants.shadowRadius
        
        logoImageView.layer.cornerRadius = Constants.cornerRadius
        upConatiner.layer.cornerRadius = Constants.cornerRadius
            downContainer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 4)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
}

extension UIColor {
    
    class var darkSkyBlue: UIColor {
        
        UIColor(red: 74.0 / 255.0, green: 144.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
    }
}
