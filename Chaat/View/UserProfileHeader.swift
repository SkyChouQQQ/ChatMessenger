//
//  UserProfileHeader.swift
//  Intasgram
//
//  Created by Admin on 2018/12/17.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToGridView()
    func didChangeToListView()
}

class UserProfileHeader:UICollectionViewCell {
    
    var delegate:UserProfileHeaderDelegate?
    
    var user:User? {
        didSet{
            print(self.user?.name ?? "no name")
            print(self.user?.email ?? "no email")
            guard let userProfileImageUrl = self.user?.profileImageUrl else {return }
            guard let userName = self.user?.name else {return }
            //guard let userEmail = self.user?.email else {return }
            profileImageView.loadImageUsingCasheWithUrlString(urlString: userProfileImageUrl)
            self.usernameLabel.text = user?.name
            setupUserInfo(name: userName, email: "foo@gmail.com")
            setupEditFollowButtonAppearance()
        }
    }
    fileprivate func setupEditFollowButtonAppearance() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return }
        guard let uid = user?.id else {return }
        
        Database.database().reference().child("friends").child(currentUserUid).child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                self.setupUnfollowStyleButton()
            }else {
                (currentUserUid == uid) ? self.setupEditProfileStyleButton() : self.setupFollowStyleButton()
            }
        }
    }
    
    
    let usernameLabel:UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var gridButton:UIButton = {
        let bu = UIButton(type: .system)
        bu.setImage(UIImage(named: "grid"), for: .normal)
        bu.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return bu
    }()
    
    @objc fileprivate func handleChangeToGridView() {
        gridButton.tintColor = UIColor.ChaatBlue()
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToGridView()
    }
    
    lazy var listButton:UIButton = {
        let bu = UIButton(type: .system)
        bu.setImage(UIImage(named: "list"), for: .normal)
        bu.tintColor = UIColor(white: 0, alpha: 0.3)
        bu.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return bu
    }()
    
    @objc fileprivate func handleChangeToListView() {
        listButton.tintColor = UIColor.ChaatBlue()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToListView()
    }
    let bookButton:UIButton = {
        let bu = UIButton(type: .system)
        bu.setImage(UIImage(named: "ribbon"), for: .normal)
        bu.tintColor = UIColor(white: 0, alpha: 0.3)
        return bu
    }()
    
    let bottomToolBarTopSeparatorView:UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.lightGray
        return iv
    }()
    
    let bottomToolBarBottomSeparatorView:UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.lightGray
        return iv
    }()
    
    let profileImageView:UIImageView = {
        let iv = UIImageView()
        iv .backgroundColor = .white
        iv.layer.cornerRadius = 80/2
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        let attributedText = self.makeUserInfoAttributedText(title: "Name : ", body: "foo")
        label.numberOfLines = 0
        label.attributedText = attributedText
        return label
    }()
    fileprivate func setupUserInfo(name:String,email:String) {
        let nameAttributedText = makeUserInfoAttributedText(title: "Name : ", body: name)
        nameLabel.attributedText = nameAttributedText
        let emailAttributedText = makeUserInfoAttributedText(title: "Name : ", body: email)
        emailLabel.attributedText = emailAttributedText
    }
    
    fileprivate func makeUserInfoAttributedText(title:String,body:String)->NSAttributedString {
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: body, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black]))
        return attributedText
    }
    lazy var emailLabel:UILabel = {
        let label = UILabel()
        let attributedText = self.makeUserInfoAttributedText(title: "Email : ", body: "foo@fmail.com")
        label.numberOfLines = 0
        label.attributedText = attributedText
        return label
    }()
    
    let postLabel:UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "100\n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray]))
        label.numberOfLines = 0
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    let followerLabel:UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray]))
        label.numberOfLines = 0
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    let followingLabel:UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray]))
        label.numberOfLines = 0
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    lazy var editProfileOrFollowButton:UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleEditOrFollowButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func handleEditOrFollowButtonTapped() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return }
        guard let userUid = user?.id else {return }
        
        guard let titleLabel = self.editProfileOrFollowButton.titleLabel?.text else {return }
        if titleLabel == "Delete Friend" {
            let ref = Database.database().reference().child("friends").child(currentUserUid).child(userUid)
            let conjugateRef = Database.database().reference().child("friends").child(userUid).child(currentUserUid)
            ref.removeValue { (error, ref) in
                if let error = error {
                    print("Fail to remove unfollowed user with error, ",error as Any)
                    return
                }
                print("Sucessfully remove following user at DB")
                NotificationCenter.default.post(name: UserProfileHeader.updateFriendsInfoNotificationName, object: nil)
                self.setupFollowStyleButton()
            }
            conjugateRef.removeValue { (error, ref) in
                if let error = error {
                    print("Fail to remove unfollowed user with error, ",error as Any)
                    return
                }
                print("Sucessfully remove following user at DB")
                
                self.setupFollowStyleButton()
            }
        } else if titleLabel == "Add Friend" {
            let ref = Database.database().reference().child("friends").child(currentUserUid)
            let conjugateRef = Database.database().reference().child("friends").child(userUid)
            let values:[String:Any] = [userUid:1]
            let conjugateValues:[String:Any] = [currentUserUid:1]
            ref.updateChildValues(values) { (error, ref) in
                if let error = error {
                    print("Update friends at DB failed with error", error as Any)
                }
                NotificationCenter.default.post(name: UserProfileHeader.updateFriendsInfoNotificationName, object: nil)
                self.setupUnfollowStyleButton()
            }
            conjugateRef.updateChildValues(conjugateValues) { (error, ref) in
                if let error = error {
                    print("Update following at DB failed with error", error as Any)
                }
                
                self.setupUnfollowStyleButton()
            }
        }
        
        
    }
    
        static let updateFriendsInfoNotificationName = Notification.Name(rawValue: "updateFriendsInfo")
    fileprivate func setupEditProfileStyleButton() {
        self.editProfileOrFollowButton.setTitle("Edit Profile", for: .normal)
        self.editProfileOrFollowButton.backgroundColor = UIColor.white
        self.editProfileOrFollowButton.setTitleColor(UIColor.black, for: .normal)
        self.editProfileOrFollowButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    fileprivate func setupFollowStyleButton() {
        self.editProfileOrFollowButton.setTitle("Add Friend", for: .normal)
        self.editProfileOrFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileOrFollowButton.backgroundColor = UIColor.ChaatBlue()
        self.editProfileOrFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    fileprivate func setupUnfollowStyleButton() {
        
        self.editProfileOrFollowButton.setTitle("Delete Friend", for: .normal)
        self.editProfileOrFollowButton.setTitleColor(UIColor.black, for: .normal)
        self.editProfileOrFollowButton.backgroundColor = .white
        self.editProfileOrFollowButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        
        
        setUpProfileImageView()
        setUpHeaderBottomToolBar()
        setUpUsernameLabel()
        setupUserInfoLabel()
        //setUpPostFollowLabel()
        setUpEditProfileButtonView()
    }
    
    fileprivate func setUpEditProfileButtonView() {
        addSubview(editProfileOrFollowButton)
        editProfileOrFollowButton.anchor(top: emailLabel.bottomAnchor, topConstant: 6, bottom: nil, bottonConstant: 0, left: profileImageView.rightAnchor, leftConstant: 12, right: self.rightAnchor, rightConstant: -12, widthConstant: 0, heightConstant: 30)
    }
    
    fileprivate func setupUserInfoLabel() {
        let userInfoStackView = UIStackView(arrangedSubviews: [nameLabel,emailLabel])
        userInfoStackView.axis = .vertical
        addSubview(userInfoStackView)
        userInfoStackView.anchor(top: self.topAnchor, topConstant: 6, bottom: nil, bottonConstant: 0, left: profileImageView.rightAnchor, leftConstant: 12, right: self.rightAnchor, rightConstant: -12, widthConstant: 0, heightConstant: 50)
    }
    
    fileprivate func setUpPostFollowLabel() {
        let postStackView = UIStackView(arrangedSubviews: [postLabel,followerLabel,followingLabel])
        addSubview(postStackView)
        postStackView.anchor(top: self.topAnchor, topConstant: 4, bottom: nil, bottonConstant: 0, left: profileImageView.rightAnchor, leftConstant: 12, right: self.rightAnchor, rightConstant: -12, widthConstant: 0, heightConstant: 50)
        
    }
    fileprivate func setUpProfileImageView() {
        addSubview(profileImageView)
        
        profileImageView.anchor(top: self.topAnchor, topConstant: 12, bottom: nil, bottonConstant: 0, left: self.leftAnchor, leftConstant: 12, right: nil, rightConstant: 0, widthConstant: 80, heightConstant: 80)
    }
    
    
    fileprivate func setUpUsernameLabel () {
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, topConstant: 4, bottom: gridButton.topAnchor, bottonConstant: 0, left: self.leftAnchor, leftConstant: 12, right: self.rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func setUpHeaderBottomToolBar() {
        let headerBottomStackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookButton])
        headerBottomStackView.axis = .horizontal
        headerBottomStackView.distribution = .fillEqually
        
        addSubview(headerBottomStackView)
        addSubview(bottomToolBarTopSeparatorView)
        addSubview(bottomToolBarBottomSeparatorView)
        
        headerBottomStackView.anchor(top: nil, topConstant: 0, bottom: self.bottomAnchor, bottonConstant: 0, left: self.leftAnchor, leftConstant: 0, right: self.rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        bottomToolBarTopSeparatorView.anchor(top: headerBottomStackView.topAnchor, topConstant: 0, bottom: nil, bottonConstant: 0, left: self.leftAnchor, leftConstant: 0, right: self.rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        bottomToolBarBottomSeparatorView.anchor(top: nil, topConstant: 0, bottom: headerBottomStackView.bottomAnchor, bottonConstant: 0, left: self.leftAnchor, leftConstant: 0, right: self.rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
