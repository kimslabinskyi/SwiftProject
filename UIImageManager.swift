import UIKit

extension UIImageView {
    private static var associatedLoadingKey: UInt8 = 0
    
    var isLoading: Bool {
        get {
            return objc_getAssociatedObject(self, &UIImageView.associatedLoadingKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.associatedLoadingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if newValue {
                showLoadingIndicator()
            } else {
                hideLoadingIndicator()
            }
        }
    }
    
    private var loadingIndicator: UIActivityIndicatorView? {
        return subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView
    }
    
    private func showLoadingIndicator() {
        if loadingIndicator == nil {
            let indicator = UIActivityIndicatorView(style: .gray)
            indicator.hidesWhenStopped = true
            indicator.translatesAutoresizingMaskIntoConstraints = false
            addSubview(indicator)
            
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        
        loadingIndicator?.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        loadingIndicator?.stopAnimating()
    }
}
