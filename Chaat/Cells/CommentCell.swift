//
//  CommentsCell.swift
//  Intasgram
//
//  Created by Admin on 2019/1/30.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit

class CommentCell:UICollectionViewCell {
    
    var comment:Comment? {
        didSet {
            guard let comment = comment else {return }
            guard let imageUrlFromPostUser = comment.user.profileImageUrl else {return }
            let commentAttributedText = NSMutableAttributedString(string: comment.user.name ?? "", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
            commentAttributedText.append(NSAttributedString(string: "  "+comment.text, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
            self.textView.attributedText = commentAttributedText
            self.profileImageView.loadImageUsingCasheWithUrlString(urlString: imageUrlFromPostUser)
        }
    }
    
    let textView:UITextView = {
        let tl = UITextView()
        tl.font = UIFont.boldSystemFont(ofSize: 14)
        tl.isScrollEnabled = false
        return tl
    }()
    
    let profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(textView)
        addSubview(profileImageView)
        textView.anchor(top: topAnchor, topConstant: 4, bottom: bottomAnchor, bottonConstant: -4, left: profileImageView.rightAnchor, leftConstant: 4, right: rightAnchor, rightConstant: -4, widthConstant: 0, heightConstant: 0)
        profileImageView.anchor(top: topAnchor, topConstant: 8, bottom: nil, bottonConstant: 0, left: leftAnchor, leftConstant: 8, right: nil, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        profileImageView.layer.cornerRadius = 40/2
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
