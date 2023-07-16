//
//  imageLoader.swift
//  TMDB App
//
//  Created by KIm on 08.07.2023.
//

import UIKit
import Alamofire

extension UIImage{
    
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
