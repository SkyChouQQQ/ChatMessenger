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
    
    private func setUpNameAndProfileImage() {
        if let id = message?.checkChatPartnerId() {
            let messageToUserRef = Database.database().reference().child("users").child(id)
            messageToUserRef.observeSingleEvent(of:.value, andPreviousSiblingKeyWith: { (snapShot, error) in
                if let dic = snapShot.value as? [String:Any] {
                    self.textLabel?.text = dic["name"] as? String
                    self.detailTextLabel?.text = self.message!.text
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
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
       
        addSubview(profileImageView)
        addSubview(timeLabel)
        addSubview(userCellSeparatorLine)
        
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor,constant:18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
        
        userCellSeparatorLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        userCellSeparatorLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        userCellSeparatorLine.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        userCellSeparatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
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
