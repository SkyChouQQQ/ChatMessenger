//
//  UserProfilePhotoCell.swift
//  Intasgram
//
//  Created by Admin on 2019/1/16.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell{
    
    var post:Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else {return }
            self.photoImageView.loadImageUsingCasheWithUrlString(urlString: imageUrl)
        }
        
    }
    let photoImageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        
        photoImageView.anchor(top: topAnchor, topConstant: 0, bottom: bottomAnchor, bottonConstant: 0, left: leftAnchor, leftConstant: 0, right: rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
