import UIKit
import WebKit
import JJFloatingActionButton

final class DetailScene: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var bankTitle: UILabel!
    
    @IBOutlet private weak var bankImage: UIImageView!
    
    @IBOutlet private weak var webView: WKWebView!
    
    @IBOutlet private weak var shareButton: UIBarButtonItem!
    
    public var data = MainData()
    
    private enum Constants {
        
        enum ViewPresentingBackground {
            
            static let white: CGFloat = 0.4
            static let alpa: CGFloat = 0.8
        }
        
        enum FloatingButton {
            
            static let size: Int = 32
            static let offesets: CGFloat = -16
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
        super.viewWillAppear(animated)
  
        configureTableView()
        configureApperance()
        configureWebView()
        configureNavigationBar()
        configureFloatingButton()
    }
    
    //MARK: - Private
    private func configureTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false
    }
    
    private func configureApperance() {
        
        bankTitle.text = data.title
        bankImage.image = data.image
    }
    
    private func configureWebView() {

        if let url = URL(string: "https://finance.ua/ua/org/-/ua/banks") {
            
            let request = URLRequest(url: url)
            webView.load(request)
            webView.contentMode = .center
        }
    }
    
    private func configureNavigationBar() {
        
        let backItem = UIBarButtonItem()
        backItem.tintColor = .white
        navigationItem.backBarButtonItem = backItem
        navigationItem.title = data.title
    }
    
    //MARK: - Actions
    @IBAction func shareButtonTaped(_ sender: Any) {
        
        if let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShareScene") as? ShareScene {

            presentedViewController.providesPresentationContextTransitionStyle = true
            presentedViewController.definesPresentationContext = true
            presentedViewController.data = data
            presentedViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            presentedViewController.view.backgroundColor = UIColor.init(white: Constants.ViewPresentingBackground.white, alpha: Constants.ViewPresentingBackground.alpa)
            self.present(presentedViewController, animated: false, completion: nil)
        }
    }

    //MARK: - Floating point
    private func configureFloatingButton() {
        
        let buttonSize = CGSize(width: Constants.FloatingButton.size, height: Constants.FloatingButton.size)
        
        let actionButton = JJFloatingActionButton()
        
        actionButton.buttonImage = UIImage(named:"floatingMenu")?.withRenderingMode(.alwaysTemplate)
        
        if let image = UIImage(named: "floatingClose")?.withRenderingMode(.alwaysTemplate) {
            
            actionButton.buttonAnimationConfiguration = .transition(toImage: image)
        } else {
            
            assertionFailure("incorrect image floatingClose")
        }
        actionButton.buttonImageColor = .white
        actionButton.buttonImageSize = buttonSize
        
        actionButton.configureDefaultItem { (item) in
            item.imageSize = buttonSize
            item.buttonImageColor = .lightGray
        }
        
        actionButton.addItem(title: "Дзвінок", image: UIImage(named: "phone")?.withRenderingMode(.alwaysTemplate)) { item in
          
            if let phoneNumber = self.data.phoneNumber {
                
                if let url = URL(string: "tel://\(phoneNumber)") {
                    
                    UIApplication.shared.open(url)
                }
            }
        }

        actionButton.addItem(title: "Карта", image: UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)) { item in
            
            self.performSegue(withIdentifier: "floatingLocationSegue", sender: item)
        }

        actionButton.addItem(title: "Сайт", image: UIImage(named: "link")?.withRenderingMode(.alwaysTemplate)) { item in

            if let stringUrl = self.data.link {

                if let url = URL(string: stringUrl) {
                    
                    UIApplication.shared.open(url)
                }
            }
        }

        view.addSubview(actionButton)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.FloatingButton.offesets).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.FloatingButton.offesets).isActive = true
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "floatingLocationSegue" {
            
            let destination = segue.destination as? Location
            
            if let adress = data.addres {
             
                 destination?.adress = adress
                destination?.navigationItem.title = data.title
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension DetailScene: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        data.currency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailSceneCell", for: indexPath)
        
        if let currentCell = cell as? DetailSceneCell {
            
            let currentCurrency = data.currency[indexPath.row]
            
            currentCell.currencySymbol.text = currentCurrency.symbol
            currentCell.currencyTitle.text = currentCurrency.title
            currentCell.currencyASK.text = currentCurrency.ask
            currentCell.currencyBin.text = currentCurrency.bid
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension DetailScene: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
