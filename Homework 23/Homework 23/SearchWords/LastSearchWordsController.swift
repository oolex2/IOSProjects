import UIKit

final class LastSearchWordsController: UIViewController {
    
    @IBOutlet private weak var searchButton: UIBarButtonItem!
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var searchWords: [String] = ["TEST1", "TEST2", "TEST3"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureBackground()
        configureTableView()
    }

    private func configureTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
    }
    
    private func configureAppearance() {
        
        if searchWords.isEmpty {
            
            tableView.isHidden = true
            
        } else {
            
            tableView.isHidden = false
        }
        
        //APPENDING searchWords from DATABASE
    }
    
    private func configureBackground() {
        
        let backgroundImage = UIImageView(frame: CGRect(x: .zero, y: .zero, width: view.bounds.width - 20 , height: view.bounds.height - view.bounds.width / 2))
        backgroundImage.image = UIImage(named: "backgroundImage")
        backgroundImage.contentMode = .scaleAspectFit
        self.view.insertSubview(backgroundImage, at: .zero)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: backgroundImage, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: .zero).isActive = true
        NSLayoutConstraint(item: backgroundImage, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: .zero).isActive = true
        NSLayoutConstraint(item: backgroundImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: view.bounds.width - 40).isActive = true
    }
}

//MARK: TableViewDataSource
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

//MARK: TableViewDelegate
extension LastSearchWordsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        45
    }
}
