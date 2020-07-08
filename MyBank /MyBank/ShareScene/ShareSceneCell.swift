import UIKit

final class ShareSceneCell: UITableViewCell {

    @IBOutlet public weak var currencySymbol: UILabel!
    
    @IBOutlet public weak var currencyDescription: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
}
