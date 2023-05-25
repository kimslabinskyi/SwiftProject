//
//  ViewController.swift
//  TMDB App
//
//  Created by KIm on 27.04.2023.
//

import UIKit

import UIKit
import WebKit


class WKWebViewController: UIViewController {
    
    let link = "https://dddddddddddddd"
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSpinner()
        
        if NetworkManager.shared.isRestartNeeded {
            //We don't have stored token and/or session
            getValidRequestToken()
        } else {
            //We have valid stored token and session
            continueToAccountInfo {
                //Failed - restart routine
                self.getValidRequestToken()
            }
        }
    }
    
    func getValidRequestToken() {
        hideSpinner()
        self.webView.navigationDelegate = self
        
        NetworkManager.shared.getRequestToken { success in
            guard success else {
                //Hide loadings!
                fatalError()
            }
            self.validateRequestToken()
        }
    }
    
    func continueToAccountInfo (_ failCallback: @escaping () -> () ) {
        
        NetworkManager.shared.getAccountInfo { success in
            if success {
                self.presentMainTabBar()
            } else {
                failCallback()
            }
        }
    }
    
    //MARK: Validate request Token
    func validateRequestToken() {
        guard let request = NetworkManager.shared.validateURLRequestWithRedirectLink(link) else {
            fatalError()
        }
        webView.load(request)
    }
    
    func presentMainTabBar(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(loginNavController)
    }
    
}
extension WKWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("Request:", navigationAction.request)
        decisionHandler(.allow)
        
        //MARK: Present Main TabBar
        
        if navigationAction.request.url?.absoluteString.contains("\(link)/?request_token") ?? false && navigationAction.request.url?.absoluteString.contains("approved=true") ?? false {
            NetworkManager.shared.getSessionID { success in
                guard success else {
                    fatalError()
                }
                self.continueToAccountInfo {
                    fatalError()
                }
            }
        }
    }
}

