//
//  SerchViewController.swift
//  TMDB App
//
//  Created by Kim on 27.04.2023.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    var dataSourceFoundMovies: [FoundMovie] = []
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        textField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? FoundMoviesCollectionViewController {
            destinationVC.listOfMovies = dataSourceFoundMovies
        }
    }
    
    func useSegue(){
        performSegue(withIdentifier: "foundMovies", sender: self)
    }
    
}


extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if let text = textField.text {
            NetworkManager.shared.searchMovies(query: text) {
                
                [weak self] foundMoviesResponse in
                guard let self = self else { return }
                
                if let movies = foundMoviesResponse {
                    self.dataSourceFoundMovies = movies.results
                    print("Response: \(String(describing: foundMoviesResponse))")
                    self.useSegue()
                } else {
                    print("Failed to search movies")
                }
            }
            
            print("Text = \(text)")
            
            
            
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
