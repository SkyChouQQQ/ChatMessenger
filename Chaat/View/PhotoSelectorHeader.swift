//
//  PhotoSelectorHeader.swift
//  Intasgram
//
//  Created by Admin on 2019/1/15.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit

class PhotoSelectorHeader: UICollectionViewCell {
    let photoImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .white
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
