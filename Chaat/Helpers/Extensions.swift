//
//  Extensions.swift
//  Chaat
//
//  Created by Admin on 2018/12/7.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit
import AVFoundation

let imageCache = NSCache<NSString,UIImage>()

extension UIImageView {
    func loadImageUsingCasheWithUrlString(urlString:String) {
        
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

extension AVAsset{
    var videoThumbnail:UIImage? {
        
        let assetImageGenerator = AVAssetImageGenerator(asset: self)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        var time = self.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbNail = UIImage.init(cgImage: imageRef)
            
            
            print("Video Thumbnail genertated successfuly")
            
            return thumbNail
            
        } catch let error{
            
            print("error getting thumbnail video", error)
            return nil
            
            
        }
        
    }
}

extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat)->UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
