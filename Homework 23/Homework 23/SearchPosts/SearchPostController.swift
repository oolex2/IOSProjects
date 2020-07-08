import UIKit
import SafariServices
import Network

final class SearchPostController: UIViewController {

    @IBOutlet public weak var tableView: UITableView!
    
    private let network = Network()
    
    public var postsData: [Post] = []
    
    public var postsImages: [Image] = []
    
    private var internetConnected: Bool = true
    
    public var hideTableView = true
    
    public var searchBarText: String = ""
    
    lazy public var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: .zero, y: .zero, width: view.bounds.width, height: Constants.searchBarHeight))
    
    private enum Constants {
        
        static let searchBarHeight: CGFloat = 20
        
        static let cellHeight: CGFloat = 100
        
        static let backgroundImageOffsets: CGFloat = 40
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        checkConnection()
        configureSearchBar()
        configureTableView()
    }
    
    //MARK: Private
    private func checkConnection() {
        
        let queue = DispatchQueue(label: "Monitor")
        let monitor = NWPathMonitor()
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            
            if path.status == .satisfied {
                
                self.internetConnected = true
                
            } else {
        
                self.internetConnected = false
                
            }
        }
    }

    private func configureTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = hideTableView
        
        configureBackground()
    }
    
    private func configureBackground() {
        
        let backgroundImage = UIImageView(frame: CGRect(x: .zero, y: .zero, width: view.bounds.width - Constants.backgroundImageOffsets / 2 , height: view.bounds.height - view.bounds.width / 2))
        backgroundImage.image = UIImage(named: "backgroundImage")
        backgroundImage.contentMode = .scaleAspectFit
        self.view.insertSubview(backgroundImage, at: .zero)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: backgroundImage, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: .zero).isActive = true
        NSLayoutConstraint(item: backgroundImage, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: .zero).isActive = true
        NSLayoutConstraint(item: backgroundImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: view.bounds.width - Constants.backgroundImageOffsets).isActive = true
        
    }
    
    private func configureSearchBar() {
        
        let saerchBarPresenting = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = saerchBarPresenting
        searchBar.tintColor = .white
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.text = searchBarText
    }
    
    private func showWebsite(url: String) {
        
        guard let urlToOpen = URL(string: url) else {
            
            return assertionFailure("URL doesn't exist")
        }
        let webVC = SFSafariViewController(url: urlToOpen)
        present(webVC, animated: true, completion: nil)
    }

    private func showAlertWith( message: String) {
        
        let alert = UIAlertController(title: message , message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
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
}

//MARK: TabelViewDataSource
extension SearchPostController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        postsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        
        if let currentCell = cell as? SearchPostCell {
            
            self.postsData = self.postsData.sorted(by: { $0.raiting! > $1.raiting! })
            
            let currentPost = postsData[indexPath.row]
            
            currentCell.postTitle.text = currentPost.title
            currentCell.postDescription.text = currentPost.description
            currentCell.postRaiting.text = String(currentPost.raiting!) + " ★"
            currentCell.postIndex.text = String(indexPath.row) + " ☛"
            if !postsImages.isEmpty {
            currentCell.postImageView.image = postsImages[indexPath.row].image
            }
        }
        
        return cell
    }
    
}

//MARK: TableViewDelegate
extension SearchPostController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let urlToOpen = postsData[indexPath.row].urlToOpen {
            
        showWebsite(url: urlToOpen)
        tableView.deselectRow(at: indexPath, animated: true)
            
        } else {
            
            assertionFailure("Nothing to open (incorrect post URL)")
        }
    }
}

//MARK: SearchBarDelegate
extension SearchPostController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        searchBar.text = nil
        tableView.isHidden = true
        navigateToMainScreen()
}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        tableView.isHidden = false
        tableView.setContentOffset(.zero, animated: true)
        
        if var text = searchBar.text {
            
            if text.contains(" ") {
                
                showAlertWith(message: "You have to put only one word to search bar!")
                searchBar.text = ""
 
                    text = ""
            }
            
            if internetConnected {
                
                network.fetchPosts(searchWord: text, tableView: tableView, postsDataInput: self.postsData) { (postsData, postsImages) in
                    
                    self.postsData = postsData
                    self.postsImages = postsImages
                }
                    
            } else {
                
                showAlertWith(message: "No internet connection! Can't make a search")
            }
        }
        searchBar.resignFirstResponder()
    }
}
