//
//  ActivityController .swift
//  TMDB App
//
//  Created by KIm on 06.05.2023.
//

import UIKit

fileprivate var activityView: UIView?

extension UIViewController{
    
    func showSpinner(){
        activityView = UIView(frame: self.view.bounds)
        activityView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let activityIndicator = UIActivityIndicatorView(style:.large)
        activityIndicator.center = activityView!.center
        activityIndicator.startAnimating()
        activityView?.addSubview(activityIndicator)
        self.view.addSubview(activityView!)     
    }
    
     func hideSpinner(){
         activityView?.removeFromSuperview()
         activityView = nil
    }
}


