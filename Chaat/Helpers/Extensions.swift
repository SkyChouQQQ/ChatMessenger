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
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    static func ChaatBlue()->UIColor {
        return UIColor.rgb(r: 60, g: 81, b: 108)
    }
    
}



extension UIView {
    func anchor(top:NSLayoutYAxisAnchor?,topConstant:CGFloat,bottom:NSLayoutYAxisAnchor?,bottonConstant:CGFloat,left:NSLayoutXAxisAnchor?,leftConstant:CGFloat,right:NSLayoutXAxisAnchor?,rightConstant:CGFloat,widthConstant:CGFloat,heightConstant:CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: bottonConstant).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: rightConstant).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
        }
        
        if widthConstant != 0 {
            widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        }
        if heightConstant != 0 {
            heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        }
    }
    
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
}

extension UILabel {
    func popupWithAnimation() {
        self.layer.transform = CATransform3DMakeScale(0, 0, 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }, completion: { (conpleted) in
            
            UIView.animate(withDuration: 0.5, delay: 0.7, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.layer.transform = CATransform3DMakeScale(0.1,0.1,0.1)
                self.alpha = 0
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        })
    }
    
}

extension UINavigationController {
    var rootViewController : UIViewController? {
        return viewControllers.first
    }
}

