//
//  InitialViewController.swift
//  TMDB App
//
//  Created by Kim on 28.05.2024.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func createRequestToken(completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/authentication/token/new?api_key=YOUR_API_KEY")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let requestToken = json["request_token"] as? String {
                    completion(requestToken)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
        
        task.resume()
    }

    
    
    func validateToken(requestToken: String, username: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=YOUR_API_KEY")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body: [String: Any] = [
            "username": username,
            "password": password,
            "request_token": requestToken
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let success = json["success"] as? Bool {
                    completion(success)
                } else {
                    completion(false)
                }
            } catch {
                completion(false)
            }
        }
        
        task.resume()
    }

    
    func createSession(requestToken: String, completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/authentication/session/new?api_key=YOUR_API_KEY")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body: [String: Any] = [
            "request_token": requestToken
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let sessionId = json["session_id"] as? String {
                    completion(sessionId)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
        
        task.resume()
    }

    
    @IBOutlet weak var usernameTextField: UITextField!
       @IBOutlet weak var passwordTextField: UITextField!
       
       @IBAction func loginButtonTapped(_ sender: UIButton) {
           guard let username = usernameTextField.text, !username.isEmpty,
                 let password = passwordTextField.text, !password.isEmpty else {
               print("Username and Password cannot be empty")
               return
           }
           
           createRequestToken { requestToken in
               guard let requestToken = requestToken else {
                   print("Failed to create request token")
                   return
               }
               
               self.validateToken(requestToken: requestToken, username: username, password: password) { success in
                   guard success else {
                       print("Failed to validate token")
                       return
                   }
                   
                   self.createSession(requestToken: requestToken) { sessionId in
                       guard let sessionId = sessionId else {
                           print("Failed to create session")
                           return
                       }
                       
                       print("Session created successfully with ID: \(sessionId)")
                   }
               }
           }
       }
   

 
}
