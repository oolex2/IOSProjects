import UIKit

final class PostCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postTitle: UILabel!
    
    @IBOutlet weak var postDescription: UILabel!
    
    @IBOutlet weak var postRaiting: UILabel!
    
    @IBOutlet weak var postIndex: UILabel!
    
    override func awakeFromNib() {

        super.awakeFromNib()
    }

    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        postTitle.text = nil
        postDescription.text = nil
        postRaiting.text = nil
        postIndex.text = nil
        postImageView.image = nil
    }
}
