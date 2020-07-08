import UIKit

final class Post: Codable {
    
    public var title: String?
    
    public var description: String?
    
    public var raiting: Int?
    
    public var imageUrl: String?
    
    public var urlToOpen: String?

}

final class Image {
    
    public var image : UIImage?
}
