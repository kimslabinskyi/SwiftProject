//
//  RateViewController.swift
//  TMDB App
//
//  Created by KIm on 12.10.2023.
//
import Alamofire
import UIKit

protocol DetailMovieProtocol {
    var title: String { get }
    var posterURL: String { get }
}

class RateViewController: UIViewController {

    @IBOutlet weak var blurredImageView: UIImageView!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    
    @IBOutlet weak var AverageRatingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ICON = \(String(describing: receivedPosterURL))")
        print("receivedMovieID = \(String(describing: receivedMovieID))")
        print("receivedVoteAverage = \(String(describing: receivedVoteAverage))")
        print("receivedLabel = \(receivedLabel)")
        
        
        blurredImageView.alpha = 0
        

        

        if let url = receivedPosterURL {
            loadImageUsingAlamofire(from: url) { image in
                if let originalImage = image {
                    let targetSize = CGSize(width: 200, height: 300)
                    let blurRadius: CGFloat = 30

                    let resizedAndBlurredImage = self.resizeImageWithDelay(originalImage, targetSize: targetSize, delayInSeconds: blurRadius)

                    // Начнем анимацию
                    UIView.animate(withDuration: 2.0, animations: {
                        self.blurredImageView.image = resizedAndBlurredImage
                        self.blurredImageView.alpha = 1
                    })

                } else {
                    self.blurredImageView.image = UIImage(named: "AppIcon")
                    self.blurredImageView.alpha = 1
                }
            }
        } else {
            self.blurredImageView.image = UIImage(named: "AppIcon")
            self.blurredImageView.alpha = 1
        }

        AverageRatingLabel.text = receivedVoteAverage
        mainLabel.text = String((receivedLabel ?? "this movie") + "?")
        
    }
    
    @IBAction func rate1(_ sender: Any) {
        NetworkManager.shared.rateMovie(movieID: receivedMovieID ?? 0, ratingValue: 1.0, sessionID: "9779e7f6bfbab5dde0757cff983e7e2bf1dae04f"){ success in


            if success {
                    print("The rating has been successfully established!")
                } else {
                    print("An error occurred while setting the rating.")
                }

        }
        navigationController?.popViewController(animated: true)
        print("Rating: 1")
    }
    
    @IBAction func rate2(_ sender: Any) {
        NetworkManager.shared.rateMovie(movieID: receivedMovieID ?? 0, ratingValue: 2.0, sessionID: "9779e7f6bfbab5dde0757cff983e7e2bf1dae04f"){ success in


            if success {
                    print("The rating has been successfully established!")
                } else {
                    print("An error occurred while setting the rating.")
                }

        }
        navigationController?.popViewController(animated: true)
        print("Rating: 2")
    }
    
    @IBAction func rate3(_ sender: Any) {
        NetworkManager.shared.rateMovie(movieID: receivedMovieID ?? 0, ratingValue: 3.0, sessionID: "9779e7f6bfbab5dde0757cff983e7e2bf1dae04f"){ success in


            if success {
                    print("The rating has been successfully established!")
                } else {
                    print("An error occurred while setting the rating.")
                }

        }
        navigationController?.popViewController(animated: true)
        print("Rating: 3")
    }
    @IBAction func rate4(_ sender: Any) {
        NetworkManager.shared.rateMovie(movieID: receivedMovieID ?? 0, ratingValue: 4.0, sessionID: "9779e7f6bfbab5dde0757cff983e7e2bf1dae04f"){ success in


            if success {
                    print("The rating has been successfully established!")
                } else {
                    print("An error occurred while setting the rating.")
                }

        }
        navigationController?.popViewController(animated: true)
        print("Rating: 4")
    }
    @IBAction func rate5(_ sender: Any) {
        NetworkManager.shared.rateMovie(movieID: receivedMovieID ?? 0, ratingValue: 5.0, sessionID: "9779e7f6bfbab5dde0757cff983e7e2bf1dae04f"){ success in


            if success {
                    print("The rating has been successfully established!")
                } else {
                    print("An error occurred while setting the rating.")
                }

        }
        navigationController?.popViewController(animated: true)
        print("Rating: 5")
    }
    @IBAction func rate6(_ sender: Any) {
        NetworkManager.shared.rateMovie(movieID: receivedMovieID ?? 0, ratingValue: 6.0, sessionID: "9779e7f6bfbab5dde0757cff983e7e2bf1dae04f"){ success in


            if success {
                    print("The rating has been successfully established!")
                } else {
                    print("An error occurred while setting the rating.")
                }

        }
        navigationController?.popViewController(animated: true)
        print("Rating: 6")
    }
    @IBAction func rate7(_ sender: Any) {
        NetworkManager.shared.rateMovie(movieID: receivedMovieID ?? 0, ratingValue: 7.0, sessionID: "9779e7f6bfbab5dde0757cff983e7e2bf1dae04f"){ success in


            if success {
                    print("The rating has been successfully established!")
                } else {
                    print("An error occurred while setting the rating.")
                }

        }
        navigationController?.popViewController(animated: true)
        print("Rating: 7")
    }
    @IBAction func rate8(_ sender: Any) {
        NetworkManager.shared.rateMovie(movieID: receivedMovieID ?? 0, ratingValue: 8.0, sessionID: "9779e7f6bfbab5dde0757cff983e7e2bf1dae04f"){ success in


            if success {
                    print("The rating has been successfully established!")
                } else {
                    print("An error occurred while setting the rating.")
                }

        }
        navigationController?.popViewController(animated: true)
        print("Rating: 8")
    }
    @IBAction func rate9(_ sender: Any) {
        NetworkManager.shared.rateMovie(movieID: receivedMovieID ?? 0, ratingValue: 9.0, sessionID: "9779e7f6bfbab5dde0757cff983e7e2bf1dae04f"){ success in


            if success {
                    print("The rating has been successfully established!")
                } else {
                    print("An error occurred while setting the rating.")
                }
        }
        navigationController?.popViewController(animated: true)
        print("Rating: 9")

    }
    @IBAction func rate10(_ sender: Any) {
        
                NetworkManager.shared.rateMovie(movieID: receivedMovieID ?? 0, ratingValue: 10.0, sessionID: "9779e7f6bfbab5dde0757cff983e7e2bf1dae04f"){ success in
        
        
                    if success {
                            print("The rating has been successfully established!")
                        } else {
                            print("An error occurred while setting the rating.")
                        }
        
                }
        navigationController?.popViewController(animated: true)
        print("Rating: 10")
        
    }
    
   
    @IBAction func backButton(_ sender: Any) {
        if let navigationController = navigationController{
            navigationController.popViewController(animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = false
    }


    
    func resizeImageWithDelay(_ image: UIImage, targetSize: CGSize, delayInSeconds: TimeInterval) -> UIImage {
        // Step 1: Reduce image size
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        // Step 2: Add a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            // Here you can perform the action after delay if necessary
        }
        
        return resizedImage
    }


    
    var receivedPosterURL: URL?
    var receivedMovieID: Int?
    var receivedVoteAverage: String?
    var receivedLabel: String?
    
    func loadImageUsingAlamofire(from url: URL, completion: @escaping (UIImage?) -> Void) {
        AF.request(url).responseData { response in
            if let data = response.data {
                let image = UIImage(data: data)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    


}
