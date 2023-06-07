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
    
    class func getImageForPosterName(_ posterName: String, completion: @escaping (UIImage?) -> Void) {
        
        guard let url = URL(string: "https://www.themoviedb.org/t/p/original\(posterName)") else {
            completion(nil)
            return
        }
        let urlRequest = URLRequest(url: url)

        imageDownloader.download(urlRequest, completion:  { response in

            if case .success(let image) = response.result {
                completion(image)
                return
            }
            //Error
            completion(nil)
        })
    }    
}
