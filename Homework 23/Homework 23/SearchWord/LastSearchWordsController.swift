import UIKit

final class LastSearchWordsController: UIViewController {
    
    @IBOutlet private weak var searchButton: UIBarButtonItem!
    
    @IBOutlet private weak var trashButton: UIBarButtonItem!
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var recentSearches: UILabel!
    
    private let fetchedResultsObject = FetchResults()
    
    private let networkObject = Network()
    
    private var searchWords: [String] = []
    
    private var postsData: [Post] = []
    
    private var postsImages: [Image] = []
    
    private enum Constants {
        
        static let cellHeight: CGFloat = 45
        static let backgroundImageOffsets: CGFloat = 40
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureBackground()
        configureTableView()
        let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        
        print(path[0])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        configureLastSearchWord()
    }
    
    private func configureLastSearchWord() {
    
        fetchedResultsObject.configureFethedResultController()
        fetchedResultsObject.configureFetchedQueryController()
        searchWords = fetchedResultsObject.getSearchWords()
        tableView.reloadData()
        
        if searchWords.isEmpty {
            
            recentSearches.isHidden = true
            trashButton.tintColor = .black
            trashButton.isEnabled = false
            
        } else {

            recentSearches.isHidden = false
            trashButton.tintColor = .white
            trashButton.isEnabled = true
        }
    }

    private func configureTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false
        tableView.separatorColor = .clear
    }
    
    
    private func configureBackground() {
        
        let backgroundImage = UIImageView(frame: CGRect(x: .zero, y: .zero, width: .zero, height: 0))
        backgroundImage.image = UIImage(named: "backgroundImage")
        backgroundImage.contentMode = .scaleAspectFit
        self.view.insertSubview(backgroundImage, at: .zero)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: backgroundImage, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: .zero).isActive = true
        NSLayoutConstraint(item: backgroundImage, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: .zero).isActive = true
        NSLayoutConstraint(item: backgroundImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: view.bounds.width - Constants.backgroundImageOffsets).isActive = true
    }
    
    @IBAction func trashButtonTaped(_ sender: Any) {
        
        let currentPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        let path = currentPath[0] + "/Application Support/Database.sqlite"
        
        do {
            
            let fileManager = FileManager()
            try fileManager.removeItem(atPath: path)
            
        } catch {
            
            print(error)
        }
       
        recentSearches.isHidden = true
        trashButton.tintColor = .black
        trashButton.isEnabled = false
        searchWords = []
        tableView.reloadData()
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowPostsSegue",
            let destination = segue.destination as? SearchPostController,
            let index = tableView.indexPathForSelectedRow?.row  {
            
            destination.hideTableView = false
        
            destination.postsData = fetchedResultsObject.getFetchedData(searchWords[index])
            
            destination.searchBarText = searchWords[index]
            
            if !destination.postsData.isEmpty {
                
                for _ in 0...destination.postsData.count - 1 {
                    
                    self.postsImages.append(Image())
                }
            }
            
            destination.postsImages = self.postsImages

            if !destination.postsData.isEmpty {
                
                for i in 0...destination.postsData.count - 1 {
                    
                    if let imageUrl = destination.postsData[i].imageUrl {
                        
                        networkObject.downloadImage(from: imageUrl) {
                            
                            (image) in
                            
                            self.postsImages[i].image = image
                            
                            DispatchQueue.main.async {
                                
                                destination.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - TableViewDataSource
extension LastSearchWordsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        searchWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LastSearchCell", for: indexPath)
        
        if let currentCell = cell as? LastSearchCell {
            
            currentCell.searchWord.text = searchWords[indexPath.row]
        }
        
        return cell
        
    }
}

//MARK: - TableViewDelegate
extension LastSearchWordsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        Constants.cellHeight
    }
}
