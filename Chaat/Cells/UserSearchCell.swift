//
//  UserSearchCell.swift
//  Intasgram
//
//  Created by Admin on 2019/1/19.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit
import Firebase

protocol UserSearchCellDelegate {
    func didTapAddFriend(with user:User)
}

class UserSearchCell: UICollectionViewCell {
    var delegate:UserSearchCellDelegate?
    var isFriend:Bool = false
    var user:User? {
        didSet{
            self.usernameLabel.text = user?.name
            guard let urlString = user?.profileImageUrl else {return }
            self.userProfileImage.loadImageUsingCasheWithUrlString(urlString: urlString)
        }
    }
    
    let userProfileImage:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 50/2
        return iv
    }()
    let usernameLabel:UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .white
        setupUserSearchCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var addFriendButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "add_friend")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleAddFriendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    fileprivate func setupAddFriendButtonAppearance() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return }
        guard let uid = user?.id else {return }
        
        Database.database().reference().child("friends").child(currentUserUid).child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                self.isFriend = true
                self.setupDeletFriendStyleButton()
                
            }else {
                self.isFriend = false
                (currentUserUid == uid) ? self.setupAddFriendStyleButton() : self.setupAddFriendStyleButton()
            }
        }
    }
    @objc func handleAddFriendButtonTapped() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return }
        guard let userUid = user?.id else {return }
        
        
        if self.isFriend {
            let ref = Database.database().reference().child("friends").child(currentUserUid).child(userUid)
            let conjugateRef = Database.database().reference().child("friends").child(userUid).child(currentUserUid)
            ref.removeValue { (error, ref) in
                if let error = error {
                    print("Fail to remove unfollowed user with error, ",error as Any)
                    return
                }
                print("Sucessfully remove following user at DB")
                self.isFriend = false
                self.setupAddFriendStyleButton()
            }
            conjugateRef.removeValue { (error, ref) in
                if let error = error {
                    print("Fail to remove unfollowed user with error, ",error as Any)
                    return
                }
                print("Sucessfully remove following user at DB")
                self.isFriend = false
                self.setupAddFriendStyleButton()
            }
        } else  {
            let ref = Database.database().reference().child("friends").child(currentUserUid)
            let conjugateRef = Database.database().reference().child("friends").child(userUid)
            let values:[String:Any] = [userUid:1]
            let conjugateValues:[String:Any] = [currentUserUid:1]
            ref.updateChildValues(values) { (error, ref) in
                if let error = error {
                    print("Update friends at DB failed with error", error as Any)
                }
                self.isFriend = true
                self.setupDeletFriendStyleButton()
            }
            conjugateRef.updateChildValues(conjugateValues) { (error, ref) in
                if let error = error {
                    print("Update following at DB failed with error", error as Any)
                }
                self.isFriend = true
                self.setupDeletFriendStyleButton()
            }
        }
        
        
    }
    fileprivate func setupDeletFriendStyleButton() {
        self.addFriendButton.setImage(UIImage(named: "remove_friend")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    fileprivate func setupAddFriendStyleButton() {
        self.addFriendButton.setImage(UIImage(named: "add_friend")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    @objc func didHandleAddFriendButtonTapped() {
        guard let user = user else {return }
        delegate?.didTapAddFriend(with: user)
    }
    
    fileprivate func setupUserSearchCell() {
        addSubview(userProfileImage)
        addSubview(usernameLabel)
        addSubview(addFriendButton)
        userProfileImage.anchor(top: nil, topConstant: 0, bottom: nil, bottonConstant: 0, left: leftAnchor, leftConstant: 8, right: nil, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        userProfileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        usernameLabel.anchor(top: self.topAnchor, topConstant: 0, bottom: self.bottomAnchor, bottonConstant: 0, left: userProfileImage.rightAnchor, leftConstant: 8, right: self.rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        addFriendButton.anchor(top:nil , topConstant: 0, bottom: nil, bottonConstant: 0, left: nil, leftConstant: 0, right: self.rightAnchor, rightConstant: -8, widthConstant: 44, heightConstant: 44)
        addFriendButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        addSubview(separatorLineView)
        
        separatorLineView.anchor(top: nil, topConstant: 0, bottom: self.bottomAnchor, bottonConstant: 0, left: usernameLabel.leftAnchor, leftConstant: 0, right: self.rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
    }
}
