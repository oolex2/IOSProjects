import UIKit

final class Network {
    
    private let database = Database()
    
    private var postsImages: [Image] = []
    
    //MARK: - JSON Keys
    
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
    
    //MARK: - Fetch posts
    
    public func fetchPosts( searchWord: String, tableView : UITableView, postsDataInput: [Post], completionHandler: @escaping (_ posts: [Post], _ images: [Image]) -> ()) {
        
        var postResults: [Post] = []
        
        if let url = URL(string: "https://api.github.com/search/repositories?q=\(searchWord)") {
            let urlRequest = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: urlRequest) {
                
                (data,response,error) in
                
                if let errors = error {
                    
                    print(errors)
                    
                    DispatchQueue.main.async {
                        
                        self.showErrors(errors)
                    }
                }
                
                guard let jsonData = data else { return }
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String : AnyObject]
                    
                    if let postsFromJson = json[JsonKeys.items] as? [[String : AnyObject]] {
                        
                        var saveToDatabase = true
                        
                        if self.database.fetchObjectWithPredefinedPredicate(searchWord) {
                            
                            saveToDatabase = false
                        }
                        
                        for postFromJson in postsFromJson {
                            
                            let post = Post()
                            
                            if let name = postFromJson[JsonKeys.name] as? String,
                                let description = postFromJson[JsonKeys.description] as? String,
                                let raiting = postFromJson[JsonKeys.stargazers_count] as? Int,
                                let urlImage = postFromJson[JsonKeys.owner]![JsonKeys.Owner.avatar_url] as? String,
                                let urlPost = postFromJson[JsonKeys.html_url] as? String {
                                
                                post.title = name
                                post.description = description
                                post.raiting = raiting
                                post.imageUrl = urlImage
                                post.urlToOpen = urlPost
                                postResults.append(post)
                                
                                if saveToDatabase {
                                    
                                    self.database.writeToDatabase(postTitle: name, postDescription: description, postRaiting: Int(raiting),postImageUrl: urlImage, postUrl: urlPost, searchWord: searchWord)
                                }
                            }
                        }
                        
                        self.database.save()
                        
                        if !postResults.isEmpty {
                            
                            for _ in 0...postResults.count - 1 {
                                
                                self.postsImages.append(Image())
                            }
                        }
                        
                        completionHandler(postResults, self.postsImages)
                        
                        if !postResults.isEmpty {
                            
                            for i in 0...postResults.count - 1 {
                                
                                if let imageUrl = postResults[i].imageUrl {
                                    
                                    self.downloadImage(from: imageUrl) {
                                        
                                        (image) in
                                        
                                        self.postsImages[i].image = image
                                        
                                        DispatchQueue.main.async {
                                            
                                            tableView.reloadData()
                                        }
                                    }
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
    
    //MARK: - Download image
    
    private let allowedDiskSize = 100 * 1024 * 1024
    
    private lazy var cache: URLCache = {
        return URLCache(memoryCapacity: 0, diskCapacity: allowedDiskSize, diskPath: "mainCache")
    }()
    
    private func createAndRetrieveURLSession() -> URLSession {
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfiguration.urlCache = cache
        
        return URLSession(configuration: sessionConfiguration)
    }
    
    typealias downloadCompletionHandler = (_ result: UIImage) -> ()
    
    public func downloadImage(from url: String, completitionHandler: @escaping downloadCompletionHandler) {
        
        if let urlToDownload = URL(string: url) {
            
            let urlRequest = URLRequest(url: urlToDownload)
            
            if let cachedData = self.cache.cachedResponse(for: urlRequest) {
                
                completitionHandler(UIImage(data: cachedData.data)!)
                
            } else {
                
                let task = createAndRetrieveURLSession().dataTask(with: urlRequest) {
                    
                    (data,response,error) in
                    
                    if let errors = error {
                        
                        print(errors)
                        
                        DispatchQueue.main.async {
                            
                            self.showErrors(errors)
                        }
                    }
                    
                    if let data = data {
                        
                        if let image = UIImage(data: data) {
                            
                            guard let response = response else { return }
                            
                            let cachedData = CachedURLResponse(response: response, data: data)
                            
                            self.cache.storeCachedResponse(cachedData, for: urlRequest)
                            
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
            }
        } else {
            
            assertionFailure("Incorrect URL")
        }
        
    }
    
    //MARK: - Show errors
    
    private func rootViewController() -> UIViewController {
        
        var result = UIViewController()
        
        if let window = UIApplication.shared.windows.first {
            
            if let viewController = window.rootViewController {
                
                result = viewController
            }
        }
        
        return result
    }
    
    private func showErrors(_ errors: Error) {
        
        let alert = UIAlertController(title: "Oops, something went wrong", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ignore", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Show info", style: .cancel, handler: { _ in
            
            let alert = UIAlertController(title: "Error!", message: "\(errors)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.rootViewController().present(alert, animated: true)
        }))
        
        rootViewController().present(alert, animated: true)
    }
}
