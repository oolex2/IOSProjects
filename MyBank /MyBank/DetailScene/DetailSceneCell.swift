import UIKit

final class DetailSceneCell: UITableViewCell {

    @IBOutlet public weak var currencySymbol: UILabel!
    
    @IBOutlet public weak var currencyTitle: UILabel!
    
    @IBOutlet public weak var currencyASK: UILabel!
    @IBOutlet public weak var currencyASKImage: UIImageView!
    
    @IBOutlet public weak var currencyBin: UILabel!
    @IBOutlet public weak var currencyBinImage: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        configureImageAppearance()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    private func configureImageAppearance() {
        
        let askImage = UIImage(named: "arrowUp")?.withRenderingMode(.alwaysTemplate)
        
        currencyASKImage.image = askImage?.withRenderingMode(.alwaysTemplate)
        currencyASKImage.tintColor = .frogGreen
        currencyASKImage.contentMode = .scaleAspectFit
        
        currencyBinImage.transform = CGAffineTransform(rotationAngle: .pi)
        currencyBinImage.image = askImage?.withRenderingMode(.alwaysTemplate)
        currencyBinImage.tintColor = .pinkishRed
        currencyBinImage.contentMode = .scaleAspectFit
    }
}

extension UIColor {
    
    class var frogGreen: UIColor {
        
        UIColor(red: 67.0 / 255.0, green: 191.0 / 255.0, blue: 16.0 / 255.0, alpha: 1.0)
    }
    
    class var pinkishRed: UIColor {
        
        UIColor(red: 244.0 / 255.0, green: 20.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0)
    }
}
