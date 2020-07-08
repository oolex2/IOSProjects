import UIKit

final class TutorialCell: UICollectionViewCell {

    @IBOutlet public weak var tutorialImageView: UIImageView!
    
    @IBOutlet public weak var tutorialMainLabel: UILabel!
    
    @IBOutlet public weak var tutorialAditionalLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
        tutorialImageView.image = nil
        tutorialMainLabel.text = nil
        tutorialAditionalLabel.text = nil
    }
}

