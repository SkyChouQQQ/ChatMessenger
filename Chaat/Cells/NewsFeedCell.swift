//
//  NewsFeedCell.swift
//  Intasgram
//
//  Created by Admin on 2019/1/16.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit

protocol NewsFeedCellDelegate {
    func didTapComment(post:Post)
    func didTapLike(for cell:NewsFeedCell)
}

class NewsFeedCell:UICollectionViewCell {
    
    var delegate:NewsFeedCellDelegate?
    var post:Post? {
        didSet {
            guard let post = post else {return }
            guard let imageUrlOfPostFromUser = post.user.profileImageUrl else {return }
            photoImageView.loadImageUsingCasheWithUrlString(urlString: post.imageUrl)
            usernameLabel.text = post.user.name
            userProfileImageView.loadImageUsingCasheWithUrlString(urlString: imageUrlOfPostFromUser)
            let likeImageName = post.isLike == true ? "like_selected" : "like_unselected"
            self.likeButton.setImage(UIImage(named: likeImageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
            setupAttributedCaptionText()
        }
    }
    
    fileprivate func setupAttributedCaptionText() {
        guard let post = self.post else {return }
        let attributedString = NSMutableAttributedString(string: post.user.name ?? "", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)])
        attributedString.append(NSAttributedString(string: post.caption, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
        attributedString.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 3)]))
        let timeAgoDisplaytext = post.creationDate.timeAgoDisplay()
        attributedString.append(NSAttributedString(string: timeAgoDisplaytext, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        captionLabel.attributedText = attributedString
    }
    
    
    let userProfileImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 40/2
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel:UILabel = {
        let ul = UILabel()
        ul.font = UIFont.boldSystemFont(ofSize: 14)
        ul.text = "userName"
        return ul
    }()
    
    let photoImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let optionButton:UIButton = {
        let ob = UIButton(type: .system)
        ob.setTitle("•••", for: .normal)
        ob.setTitleColor(.black, for: .normal)
        return ob
    }()
    
    lazy var likeButton:UIButton = {
        let bu = UIButton(type: .system)
        bu.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bu.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return bu
    }()
    
    @objc func handleLikeTapped() {
        delegate?.didTapLike(for: self)
    }
    
    lazy var commentButton:UIButton = {
        let bu = UIButton(type: .system)
        bu.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bu.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return bu
    }()
    
    @objc func handleComment() {
        guard let post = self.post else {return }
        delegate?.didTapComment(post:post)
    }
    
    let sendButton:UIButton = {
        let bu = UIButton(type: .system)
        bu.setImage(UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return bu
    }()
    
    let ribbonButton:UIButton = {
        let bu = UIButton(type: .system)
        bu.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return bu
    }()
    
    let captionLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(optionButton)
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, topConstant: 8, bottom: nil, bottonConstant: 0, left: leftAnchor, leftConstant: 0, right: rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        userProfileImageView.anchor(top: topAnchor, topConstant: 8, bottom: nil, bottonConstant: 0, left: leftAnchor, leftConstant: 8, right: nil, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        usernameLabel.anchor(top: nil, topConstant: 0, bottom: nil, bottonConstant: 0, left: userProfileImageView.rightAnchor, leftConstant: 8, right: optionButton.leftAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        usernameLabel.centerYAnchor.constraint(equalTo: userProfileImageView.centerYAnchor).isActive = true
        optionButton.anchor(top: topAnchor, topConstant: 0, bottom: photoImageView.topAnchor, bottonConstant: 0, left: nil, leftConstant: 0, right: rightAnchor, rightConstant: -8, widthConstant: 44, heightConstant: 0)
        optionButton.centerYAnchor.constraint(equalTo: userProfileImageView.centerYAnchor).isActive = true
        
        setupActionButtons()
        
    }
    
    fileprivate func setupActionButtons() {
        let actionButtonsContainerView = UIStackView(arrangedSubviews: [likeButton,commentButton,sendButton])
        actionButtonsContainerView.axis = .horizontal
        actionButtonsContainerView.distribution = .fillEqually
        
        addSubview(actionButtonsContainerView)
        
        actionButtonsContainerView.anchor(top: photoImageView.bottomAnchor, topConstant: 0, bottom: nil, bottonConstant: 0, left: leftAnchor, leftConstant: 8, right: nil, rightConstant: 0, widthConstant: 120, heightConstant: 50)
        
        
        addSubview(ribbonButton)
        
        ribbonButton.anchor(top: photoImageView.bottomAnchor, topConstant: 0, bottom: nil, bottonConstant: 0, left: nil, leftConstant: 0, right: rightAnchor, rightConstant: 0, widthConstant: 40, heightConstant: 50)
        
        addSubview(captionLabel)
        
        captionLabel.anchor(top: actionButtonsContainerView.bottomAnchor, topConstant: 0, bottom: bottomAnchor, bottonConstant: 0, left: leftAnchor, leftConstant: 8, right: rightAnchor, rightConstant: -8, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
