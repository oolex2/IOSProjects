import UIKit

final class TutorialScene: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBOutlet private weak var pageControl: UIPageControl!
    
    @IBOutlet private weak var coinsImageView: UIImageView!
    
    @IBOutlet private weak var startButton: UIButton!
    
    private var images: [UIImage] = []
    
    private var mainLabelData: [String] = []
    
    private var aditionalLabelData: [String] = []
    
    private var defaultCoinHeight: CGFloat = 0
    
    private enum Constants {
        
        static let coinsOpacity: CGFloat = 0.3
        static let startButtonRadius: CGFloat = 30
        static let tutorialSceneIdentifier = "TutorialCell"
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureCollectionView()
        configureAppearance()
        configureData()
    }
    
    override func viewDidLayoutSubviews() {
        
        coinsImageView.frame = CGRect(x: coinsImageView.frame.minX, y: defaultCoinHeight, width: coinsImageView.frame.width, height: coinsImageView.frame.height)
        
    }
    
    //MARK: - Private
    
    private func configureData() {
        
        mainLabelData = ["Заощаджуйте кошти", "Заробляйте", "Аналізуйте"]
        aditionalLabelData = ["Переглядайте інформацію щодо банківських курсів та вибирайте оптимальний варіант", "Отримайте вигідний відсоток з вигідним вкладом", "Повна інформація про грошові курси та банки"]
    }
    
    private func configureStyle() {
        
        UIApplication.shared.windows.forEach { window in
            
            if #available(iOS 13.0, *) {
                
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    private func configureAppearance() {
        
        coinsImageView.image = coinsImageView.image?.alpha(Constants.coinsOpacity)
        
        defaultCoinHeight = view.bounds.height - coinsImageView.frame.height / (view.bounds.width / view.bounds.height * 5 - 0.5)
        
        startButton.layer.cornerRadius = Constants.startButtonRadius
        
        configureStyle()
    }
    
    private func configureCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        configureLayout()
    }
    
    private func configureLayout() {
        
        let layout: UICollectionViewFlowLayout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
    }
    
}

//MARK: - UICollectionViewDeleagte
extension TutorialScene: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.tutorialSceneIdentifier, for: indexPath) as! TutorialCell
        
        cell.tutorialImageView.image = UIImage(named: "image\(indexPath.row)")
        cell.tutorialMainLabel.text = mainLabelData[indexPath.row]
        cell.tutorialAditionalLabel.text = aditionalLabelData[indexPath.row]
        cell.tutorialAditionalLabel.sizeToFit()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width , height: collectionView.bounds.height)
       }
       
       func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
           let scrollPos = scrollView.contentOffset.x / scrollView.frame.size.width
 
        coinsImageView.frame = CGRect(x: coinsImageView.frame.minX, y: defaultCoinHeight - coinsImageView.frame.height * scrollPos / 7, width: coinsImageView.frame.width, height: coinsImageView.frame.height)
           pageControl.currentPage = Int(round(scrollPos))
       }
}

//MARK: - UIImage extension
extension UIImage {

    func alpha(_ value:CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
