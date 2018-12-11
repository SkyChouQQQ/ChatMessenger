//
//  ChatMessageCell.swift
//  Chaat
//
//  Created by Admin on 2018/12/9.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit

protocol ChatMessageCellDelegate {
    func handleImageViewZooming(tapGesture:UITapGestureRecognizer)
}


class ChatMessageCell: UICollectionViewCell {
    
    var delegate:ChatMessageCellDelegate?
    
    var chatBubbleViewWidthAnchor:NSLayoutConstraint?
    var chatBubbleRightAnchor:NSLayoutConstraint?
    var chatBubbleLeftAnchor:NSLayoutConstraint?
    
    static let chatBubbleBlue = UIColor(r: 0, g: 137, b: 249)
    
    let messageTextView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = .white
        tv.isEditable = false
        return tv
    }()
    
    let chatBubbleView:UIView = {
        let view = UIView()
        view.backgroundColor = chatBubbleBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    lazy var messageImageView:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewZoomingTap(tapGestureRecognizer:))))
        return iv
    }()
    
    @objc func handleImageViewZoomingTap(tapGestureRecognizer:UITapGestureRecognizer) {
        print(123)
        delegate?.handleImageViewZooming(tapGesture: tapGestureRecognizer)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        addSubview(profileImageView)
        addSubview(chatBubbleView)
        addSubview(messageTextView)
        chatBubbleView.addSubview(messageImageView)
        
        messageImageView.rightAnchor.constraint(equalTo: chatBubbleView.rightAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: chatBubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: chatBubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: chatBubbleView.heightAnchor).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant:8).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        chatBubbleRightAnchor = chatBubbleView.rightAnchor.constraint(equalTo: self.rightAnchor,constant:-8)
        chatBubbleViewWidthAnchor = chatBubbleView.widthAnchor.constraint(equalToConstant: 200)
        chatBubbleLeftAnchor = chatBubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        chatBubbleRightAnchor?.isActive = true
        chatBubbleViewWidthAnchor?.isActive = true
        chatBubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        chatBubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        messageTextView.leftAnchor.constraint(equalTo: chatBubbleView.leftAnchor,constant:8).isActive = true
        messageTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: chatBubbleView.rightAnchor).isActive = true
        messageTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
