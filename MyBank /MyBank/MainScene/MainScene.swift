import UIKit

final class MainScene: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var banerView: UIView!
    @IBOutlet private weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var searchButton: UIBarButtonItem!
    @IBOutlet private weak var tableViewTopToSafeArea: NSLayoutConstraint!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var dataToShow: [MainData] = []
    private var data: [MainData] = []
 
    private var network = Network()
    private var databaseData = FetchResults()
    private var animation = MainSceneAnimation()
    private let refreshControl = UIRefreshControl()
    
    private var internetConnected: Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        getDataFromDatabase()
        configureData()
        configureTableView()
        configureSearchBar()
        configureBanner()
        configureStyle()
    }
 
    //MARK: - Private
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        configureRefreshControll()
    }
    
    private func configureRefreshControll() {
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc private func refresh() {
        
        animation.hideBanner(view: self.view, hide: false, bannerHeight: self.bannerHeight, tableViewHeight: self.tableViewHeight)
        configureData()
        searchBar.isHidden = true
        searchButtonTapedOnce = true
    }
    
    private func configureSearchBar() {
        
        self.tableViewTopToSafeArea.constant = 0
        self.tableViewHeight.constant = self.tableViewHeight.constant + self.searchBar.frame.height
        
        searchBar.isHidden = true
        searchBar.showsCancelButton = true
        searchBar.delegate = self
    }
    
    private func configureStyle() {
        
        UIApplication.shared.windows.forEach { window in
            if #available(iOS 13.0, *) {
                
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    private func getDataFromDatabase() {
        
        databaseData.configureFethedResultController()
        self.dataToShow = databaseData.getFetchedData()
    }
    
    private func configureData() {
        
        network.fetchData(completionHandler: {
            (data, error, internetConnected) in

            self.configureImageData(data)
            
            if internetConnected == nil {
                
                self.internetConnected = false
                
            } else {
                
                self.internetConnected = true
                self.data = data
                self.dataToShow = data
            }
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                self.animation.hideBanner(view: self.view, hide: true, bannerHeight: self.bannerHeight, tableViewHeight: self.tableViewHeight)
                self.refreshControl.endRefreshing()
                
                if let errors = error {
                    
                    self.showErrors(errors)
                }
                
                if !self.internetConnected {
                    
                    self.showAlertWith(message: "No Internet connection")
                }
            }
        })
    }
    
    private func configureImageData(_ data: [MainData]) {
        
        if !data.isEmpty {
            
            for i in 0...data.count - 1 {
                
                self.network.downloadImage(from: self.generateIcon(data[i])) { (image, error) in
                    
                    data[i].image = image
                    
                    DispatchQueue.main.async {
                        
                        self.tableView.reloadData()
                        
                        if let errors = error {
                            self.showErrors(errors)
                        }
                    }
                }
            }
        }
    }
    
    private func showAlertWith( message: String) {
        
        let alert = UIAlertController(title: message , message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func generateIcon(_ data: MainData) -> String {
        
        let firstColor = UIColor.hexStringFromColor(color: UIColor.random())
        let secondColor = UIColor.hexStringFromColor(color: UIColor.random())
        var finalKeyText = ""
        if let text = data.title {

            if let key = text.components(separatedBy: " ").first {
                
                if let firstKey = key.first, let lastKey = key.last {
                    
                    finalKeyText = "\(firstKey)\(lastKey)"
                }

                if let encodedText = finalKeyText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed) {
                    
                    finalKeyText = encodedText
                }
            }
        }
        
        let finalUrl = "https://dummyimage.com/64x40/\(firstColor)/\(secondColor)&text=\(finalKeyText)"

        return finalUrl
    }
    
    private func configureBanner() {
        
        banerView.layer.cornerRadius = 4
    }
    
    private func showErrors(_ errors: Error) {
        
        let alert = UIAlertController(title: "Oops, something went wrong", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ignore", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Show info", style: .cancel, handler: { _ in
            
            let alert = UIAlertController(title: "Error!", message: "\(errors)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }))
        
        self.present(alert, animated: true)
    }
    
    //MARK: - Actions

    private var searchButtonTapedOnce = true
    @IBAction func searchButtonTaped(_ sender: UIBarButtonItem) {
        
        if searchButtonTapedOnce {
            
             self.searchBar.frame = CGRect(x: self.searchBar.frame.minX, y: self.searchBar.frame.minY - self.searchBar.frame.height, width: self.searchBar.frame.width, height: self.searchBar.frame.height)
        }
        
        searchButtonTapedOnce = false
        
        if tableViewTopToSafeArea.constant == 0 {
            
            animation.hideSearchBar(view: self.view, hide: false, searchBar: self.searchBar, tableViewTopToSafeArea: self.tableViewTopToSafeArea, tableViewHeight: self.tableViewHeight)
            
            tableView.refreshControl = nil
            
        } else {
            
           animation.hideSearchBar(view: self.view, hide: true, searchBar: self.searchBar, tableViewTopToSafeArea: self.tableViewTopToSafeArea, tableViewHeight: self.tableViewHeight)
            
            tableView.refreshControl = refreshControl
        }
    }
    
    //MARK: - Buttons actions
    
    @objc private func linkButtonTaped(sender: UIButton) {
        
        if let stringUrl = dataToShow[sender.tag].link {

            if let url = URL(string: stringUrl) {
                
                if UIApplication.shared.canOpenURL(url) {
                    
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    @objc private func phoneButtonTaped(sender: UIButton) {
        
        if let phoneNumber = dataToShow[sender.tag].phoneNumber {
            
            if let url = URL(string: "tel://\(phoneNumber)") {
                
                if UIApplication.shared.canOpenURL(url) {
                    
                    UIApplication.shared.open(url)
                }
            }
        }
    }

    private func configureNavigationBar() {
        
        let backItem = UIBarButtonItem()
        backItem.tintColor = .white
        navigationItem.backBarButtonItem = backItem
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        configureNavigationBar()
        
        if segue.identifier == "locationSegue",
            let destination = segue.destination as? Location {
            
            if let button:UIButton = sender as! UIButton? {

                destination.navigationItem.title = dataToShow[button.tag].title
               
                if let adress = dataToShow[button.tag].addres {
                    
                    destination.adress = adress
                }
            }
        }
        
        if segue.identifier == "CellSegue", let destination = segue.destination as? DetailScene, let index = tableView.indexPathForSelectedRow {
            
            destination.data = self.dataToShow[index.row]
        }
        
        if segue.identifier == "MenuButtonSegue", let destination = segue.destination as? DetailScene {
            
            if let sender = sender as? UIButton {
                
                destination.data = self.dataToShow[sender.tag]
            } else {
                
                assertionFailure("incorrect sender")
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension MainScene: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.dataToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainSceneCell", for: indexPath)
        
        
        if let currentCell = cell as? MainSceneCell {
            
            let currentBankIndex = indexPath.row
            currentCell.titleLabel.text = self.dataToShow[currentBankIndex].title
            currentCell.cityLabel.text = self.dataToShow[currentBankIndex].city
            currentCell.regionLabel.text = self.dataToShow[currentBankIndex].region
            currentCell.logoImageView.image = self.dataToShow[currentBankIndex].image
            
            if let phoneNumber = self.dataToShow[currentBankIndex].phoneNumber, let addres = self.dataToShow[currentBankIndex].addres {
                
                currentCell.phoneLabel.text = "Тел.: " + phoneNumber
                currentCell.adressLabel.text = "Адреса: " + addres
            }
            
            currentCell.linkButton.tag = indexPath.row
            currentCell.linkButton.addTarget(self, action: #selector(linkButtonTaped(sender:)), for: .touchUpInside)
            currentCell.locationButton.tag = indexPath.row
            currentCell.phoneButton.tag = indexPath.row
            currentCell.phoneButton.addTarget(self, action: #selector(phoneButtonTaped(sender:)), for: .touchUpInside)
            currentCell.menuButton.tag = indexPath.row

            
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MainScene: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        184
    }
}

//MARK: - UISearchBarDelegate
extension MainScene: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        animation.hideSearchBar(view: self.view, hide: true, searchBar: self.searchBar, tableViewTopToSafeArea: self.tableViewTopToSafeArea, tableViewHeight: self.tableViewHeight)
        searchBar.resignFirstResponder()
        searchBar.text = nil
        
        dataToShow = data
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchBar.text {

            let filteredData = data.filter({ $0.city?.range(of: searchText, options: .caseInsensitive) != nil || $0.title?.range(of: searchText, options: .caseInsensitive) != nil || $0.region?.components(separatedBy: " ").first?.range(of: searchText, options: .caseInsensitive) != nil})
            
            searchBar.resignFirstResponder()
            dataToShow = filteredData
            tableView.reloadData()
        }
    }
}

extension UIColor {
    
    static func hexStringFromColor(color: UIColor) -> String {
        
       let components = color.cgColor.components
       let r: CGFloat = components?[0] ?? 0.0
       let g: CGFloat = components?[1] ?? 0.0
       let b: CGFloat = components?[2] ?? 0.0

       let hexString = String.init(format: "%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))

       return hexString
    }
    
    static func random() -> UIColor {
        
        return UIColor(red:   CGFloat(Float.random(in: 0...1)),
                       green: CGFloat(Float.random(in: 0...1 )),
                       blue:  CGFloat(Float.random(in: 0...1 )),
                       alpha: 1.0)
    }
}
