import UIKit

final class Network {
    
    private enum JsonKeys {
        
        static let items = "items"
        static let name = "name"
        static let description = "description"
        static let stargazers_count = "stargazers_count"
        static let owner = "owner"
        static let html_url = "html_url"
        
        enum Owner {
            
            static let avatar_url = "avatar_url"
        }
    }
    
    public func fetchPosts( searchWord: String, tableView : UITableView, postsDataInput: [Post], completionHandler: @escaping (_ result: [Post]) -> ()) {
        
        var postResults: [Post] = []
        
        if let url = URL(string: "https://api.github.com/search/repositories?q=\(searchWord)") {
            let urlRequest = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: urlRequest) {
                
                (data,response,error) in
                
                if error != nil {
                    
                  print(error!)
                    
                }
                
                guard let jsonData = data else { return }
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String : AnyObject]
                    
                    if let postsFromJson = json[JsonKeys.items] as? [[String : AnyObject]] {
                        
                        for postFromJson in postsFromJson {
                            
                            if let name = postFromJson[JsonKeys.name] as? String,
                                let description = postFromJson[JsonKeys.description] as? String,
                                let raiting = postFromJson[JsonKeys.stargazers_count] as? Int,
                                let urlImage = postFromJson[JsonKeys.owner]![JsonKeys.Owner.avatar_url] as? String,
                                let urlPost = postFromJson[JsonKeys.html_url] as? String {
                                
                                postResults.append(Post(title: name, description: description, raiting: raiting, imageUrl: urlImage, urlToOpen: urlPost, image: UIImage()))
                            }
                        }
                        completionHandler(postResults)
                        
                        for i in 0...postResults.count - 1 {
                            self.downloadImage(from: postResults[i].imageUrl) {
                                
                                (image) in
                                
                                postResults[i].image = image
                                
                                DispatchQueue.main.async {
                                    
                                    tableView.reloadData()
                                }
                            }
                        }
                    }
                }
                    
                catch {
                    
                    print(error)
                }
            }
            
            task.resume()
            
        } else {
            
            assertionFailure("Incorrect link")
        }
    }
    
    public func downloadImage(from url: String, completitionHandler: @escaping (_ result: UIImage) -> ()) {
        
        if let urlToDownload = URL(string: url) {
            
            let urlRequest = URLRequest(url: urlToDownload)
            
            let task = URLSession.shared.dataTask(with: urlRequest) {
                
                (data,response,error) in
                
                if error != nil {
                    
                    print(error!)
                }
                
                if data != nil {
                    
                    if let image = UIImage(data: data!) {
                        
                        completitionHandler(image)
                        
                    } else {
                        
                        assertionFailure("Image doesn't exist")
                    }
                    
                } else {
                    
                    if let image = UIImage(named: "incorrectImage") {
                        
                        completitionHandler(image)
                    }
                }
            }
            task.resume()
            
        } else {
            
            assertionFailure("Incorrect URL")
        }
    }
    
}
