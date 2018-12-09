//
//  ChatMessageCell.swift
//  Chaat
//
//  Created by Admin on 2018/12/9.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    var chatBubbleViewWidthAnchor:NSLayoutConstraint?
    
    let messageTextView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = .white
        return tv
    }()
    
    let chatBubbleView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        addSubview(chatBubbleView)
        addSubview(messageTextView)
        
        chatBubbleView.rightAnchor.constraint(equalTo: self.rightAnchor,constant:-8).isActive = true
        chatBubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        chatBubbleViewWidthAnchor = chatBubbleView.widthAnchor.constraint(equalToConstant: 200)
        chatBubbleViewWidthAnchor?.isActive = true
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
