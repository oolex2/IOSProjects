import UIKit

final class MainSceneAnimation {
    
    private enum Constants {
        
        static let hideSearchBarAnimationDuration: Double = 0.5
        static let hideBannerAnimationDuration: Double = 1
        static let tableViewHeight: CGFloat = 40
    }
    
    public func hideBanner( view: UIView, hide: Bool, bannerHeight: NSLayoutConstraint, tableViewHeight: NSLayoutConstraint) {
        
        if hide {
            
            UIView.animate(withDuration: Constants.hideBannerAnimationDuration) {
                
                bannerHeight.constant = 0
                tableViewHeight.constant = tableViewHeight.constant + Constants.tableViewHeight
                view.layoutIfNeeded()
            }
        } else {
            
            UIView.animate(withDuration: Constants.hideBannerAnimationDuration) {
                
                tableViewHeight.constant = tableViewHeight.constant - Constants.tableViewHeight
                bannerHeight.constant = Constants.tableViewHeight
                view.layoutIfNeeded()
            }
        }
    }
    
    public func hideSearchBar(view: UIView, hide: Bool, searchBar: UISearchBar, tableViewTopToSafeArea: NSLayoutConstraint, tableViewHeight: NSLayoutConstraint) {
        
        if hide {
            
            UIView.animate(withDuration: Constants.hideSearchBarAnimationDuration) {
               
                searchBar.isHidden = false
                tableViewTopToSafeArea.constant = 0
                tableViewHeight.constant = tableViewHeight.constant + searchBar.frame.height
                
                view.layoutIfNeeded()
                
                searchBar.frame = CGRect(x: searchBar.frame.minX, y: searchBar.frame.minY - searchBar.frame.height, width: searchBar.frame.width, height: searchBar.frame.height)
            }
            
        } else {
            
            UIView.animate(withDuration: Constants.hideSearchBarAnimationDuration) {
                
                searchBar.isHidden = false
                tableViewTopToSafeArea.constant = searchBar.frame.height
                tableViewHeight.constant = tableViewHeight.constant - searchBar.frame.height
                
                view.layoutIfNeeded()
                
                searchBar.frame = CGRect(x: searchBar.frame.minX, y: searchBar.frame.minY , width: searchBar.frame.width, height: searchBar.frame.height)
            }
        }
    }
}
