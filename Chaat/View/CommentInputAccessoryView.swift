//
//  CommentInputAccessoryView.swift
//  Intasgram
//
//  Created by Admin on 2019/2/2.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSubmitComment(of comment:String)
}

class CommentInputAccessoryView:UIView {
    var delegate:CommentInputAccessoryViewDelegate?
    
    fileprivate let sendCommentButton:UIButton = {
        let sb = UIButton(type: .system)
        sb.setTitle("Send", for: .normal)
        sb.setTitleColor(.black, for: .normal)
        sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sb.addTarget(self, action: #selector(handleSendComment), for: .touchUpInside)
        return sb
    }()
    
    fileprivate let commentInputTextView:CommentInputTextView = {
        let tv = CommentInputTextView()
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
    }()
    
    @objc func handleSendComment() {
        guard let commentText = commentInputTextView.text else {return }
        delegate?.didSubmitComment(of: commentText)
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        addSubview(commentInputTextView)
        addSubview(sendCommentButton)
        
        if #available(iOS 11.0, *) {
            commentInputTextView.anchor(top: topAnchor, topConstant: 0, bottom: safeAreaLayoutGuide.bottomAnchor, bottonConstant: 0, left: leftAnchor, leftConstant: 12, right: sendCommentButton.leftAnchor, rightConstant: -8, widthConstant: 0, heightConstant: 0)
        } else {
            // Fallback on earlier versions
        }
        
        sendCommentButton.anchor(top: topAnchor, topConstant: 0, bottom: commentInputTextView.bottomAnchor, bottonConstant: 0, left: nil, leftConstant: 0, right: rightAnchor, rightConstant: -12, widthConstant: 50, heightConstant: 0)
        
        setupSeparatorLineView()
    }
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    fileprivate func setupSeparatorLineView() {
        let inputContainerSeparatorLine:UIView = {
            let iv = UIView()
            iv.backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230)
            return iv
        }()
        addSubview(inputContainerSeparatorLine)
        
        inputContainerSeparatorLine.anchor(top: nil, topConstant: 0, bottom: topAnchor, bottonConstant: 0, left: leftAnchor, leftConstant: 0, right: rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
    }
    
    func clearCommentTextField() {
        commentInputTextView.text = nil
        commentInputTextView.showPlaceholderLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
