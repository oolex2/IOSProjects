
import UIKit

final class ComboBox: UIViewController {

    @IBOutlet private weak var showButton: UIButton!
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var selectedQuestion: UILabel!
    
    private var showButtonTapedCount: Int = 0
    
    private var questions: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        configureQuestions()
        tableViewHeightConstraint .constant = 0
    }
    
    private func configureQuestions() {
        questions = ["question 1", "question 2", "question 3", "question 4"]
    }
    
    @IBAction func showButtonTaped(_ sender: Any) {
        
        showButtonTapedCount += 1
        
        if showButtonTapedCount % 2 == 0 {
            
            animateButton(.pi * 2)
            hideTableView(true)
            
        } else {
            
            animateButton(.pi)
            hideTableView(false)
            
        }
        
    }
    
    private func animateButton(_ angle: CGFloat) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.showButton.transform = CGAffineTransform(rotationAngle: angle)
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideTableView(_ hide: Bool) {
        
        if hide {
            
            UIView.animate(withDuration: 1) {
                self.tableViewHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            
        } else {
            
            UIView.animate(withDuration: 1) {
                self.tableViewHeightConstraint.constant = 180
                self.view.layoutIfNeeded()
            }
            
        }
    }
}

extension ComboBox: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComboBoxCell", for: indexPath)
        
        if let mainCell = cell as? ComboBoxCell {
            
            mainCell.questionTitle.text = questions[indexPath.row]
            
        } else {
            
            assertionFailure("Cell doesn't exist!")
            
        }
        
        return cell
        
    }
    
}

extension ComboBox: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hideTableView(true)
        animateButton(.pi * 2)
        selectedQuestion.text = questions[indexPath.row]
    }
}
