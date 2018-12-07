//
//  Extensions.swift
//  Chaat
//
//  Created by Admin on 2018/12/7.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString,UIImage>()

extension UIImageView {
    func laodImageUsingCasheWithUrlString(urlString:String) {
        
        self.image = nil
        
        guard let url = URL(string: urlString) else {return }
        let imageCacheKey = NSString(string: urlString)
        
        //check cache for image first
        if let cacheImage = imageCache.object(forKey: imageCacheKey) {
            self.image = cacheImage
            return
        }

        //otherwise fure iff a new download
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            
            if error != nil {
                print("download profile image fails with error ", error as Any)
                return
            }
            guard let data = data else {return}
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data) {
                    imageCache.setObject(downloadedImage, forKey: imageCacheKey)
                 self.image = downloadedImage
                }
            }
        }.resume()
    }
}
