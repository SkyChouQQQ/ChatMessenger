//
//  CommentInputTextView.swift
//  Intasgram
//
//  Created by Admin on 2019/2/2.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit

class CommentInputTextView:UITextView {
    fileprivate let placeholderLabel:UILabel = {
        let pl = UILabel()
        pl.text = "Enter Comment"
        pl.textColor = .lightGray
        return pl
    }()
    
    func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, topConstant: 8, bottom: bottomAnchor, bottonConstant: 0, left: leftAnchor, leftConstant: 8, right: rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanged), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc func handleTextChanged() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
