//
//  ImageManager.swift
//  TMDB App
//
//  Created by Oleksandr Slabinskyi on 07.06.2023.
//

import Alamofire
import AlamofireImage
import UIKit

class ImageManager {
    
    private static var imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .fifo,
        maximumActiveDownloads: 4,
        imageCache: AutoPurgingImageCache()
    )
    
//    class func getImageForPosterName(_ posterName: String, completion: @escaping (UIImage?) -> Void) {
//
//        guard let url = URL(string: "https://www.themoviedb.org/t/p/original\(posterName)") else {
//            completion(nil)
//            return
//        }
//        let urlRequest = URLRequest(url: url)
//
//        imageDownloader.download(urlRequest, completion:  { response in
//
//            if case .success(let image) = response.result {
//                completion(image)
//                return
//            }
//            //Error
//            completion(nil)
//        })
//    }
    
    
        
        
    class func getImageForPosterName(_ posterName: String?, imageSize: String = "w342", completion: @escaping (UIImage?) -> Void) {
        guard let posterName = posterName else {
            completion(UIImage(named: "question_mark"))
            return
        }
        
        guard let url = URL(string: "https://www.themoviedb.org/t/p/\(imageSize)/\(posterName)") else {
            completion(nil)
            return
        }
        
        let urlRequest = URLRequest(url: url)

        imageDownloader.download(urlRequest) { response in
            if case .success(let image) = response.result {
                completion(image)
                return
            }
            // Error
            completion(nil)
        }
    }

    
    class func getImageForFavouritesName(_ posterName: String, completion: @escaping (UIImage?) -> Void) {

        guard let url = URL(string: "https://www.themoviedb.org/t/p/original/\(posterName)&width=300")
        else {
            completion(nil)
            return
        }
        let urlRequest = URLRequest(url: url)
        
        imageDownloader.download(urlRequest, completion: { response in
            
            if case .success(let image) =
                response.result {
                completion(image)
                return
            }
            completion(nil)
        })
        
        
        
        
        
        
    }
    
    
}
