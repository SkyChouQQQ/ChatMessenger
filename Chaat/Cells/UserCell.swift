//
//  MessgeCell.swift
//  Chaat
//
//  Created by Admin on 2018/12/6.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    var message:Message? {
        didSet {
            
            setUpNameAndProfileImage()
        }
    }
    let containerView:UIView = {
        let cv = UIView()
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 6
        return cv
    }()
    
    let newestMessageLabel:UILabel = {
        let la = UILabel()
        la.font = UIFont.systemFont(ofSize: 12)
        la.textColor = UIColor.lightWhite
        la.textAlignment = .left
        return la
    }()
    
    private func setUpNameAndProfileImage() {
        if let id = message?.checkChatPartnerId() {
            let messageToUserRef = Database.database().reference().child("users").child(id)
            messageToUserRef.observeSingleEvent(of:.value, andPreviousSiblingKeyWith: { (snapShot, error) in
                if let dic = snapShot.value as? [String:Any] {
                    self.userNameLabel.text = dic["name"] as? String
                    self.newestMessageLabel.text = self.message!.text
                    if let profileImageUrl = dic["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCasheWithUrlString(urlString: profileImageUrl)
                    }
                }
            }, withCancel: nil)
        }
    }
    
    let userCellSeparatorLine:UIView = {
        let iv = UIView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        return iv
    }()
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 76/2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let userNameLabel:UILabel = {
        let la = UILabel()
        la.font = UIFont.boldSystemFont(ofSize: 16)
        la.textColor = UIColor.lightWhite
        return la
    }()
    
    let timeLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightWhite
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.lightWhite
        addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(newestMessageLabel)
        containerView.addSubview(timeLabel)
        //containerView.addSubview(userCellSeparatorLine)
        
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        containerView.anchor(top: topAnchor, topConstant: 0, bottom: bottomAnchor, bottonConstant: 0, left: leftAnchor, leftConstant: 0, right: rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 76).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 76).isActive = true
        
        userNameLabel.anchor(top: nil, topConstant: 0, bottom: nil, bottonConstant: 0, left: profileImageView.rightAnchor, leftConstant: 8, right: timeLabel.rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        userNameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        newestMessageLabel.anchor(top: userNameLabel.bottomAnchor, topConstant: 0, bottom: containerView.bottomAnchor, bottonConstant: 0, left: userNameLabel.leftAnchor, leftConstant: 0, right: timeLabel.rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        timeLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
        
//        userCellSeparatorLine.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        userCellSeparatorLine.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
//        userCellSeparatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        userCellSeparatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y-2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y+2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
