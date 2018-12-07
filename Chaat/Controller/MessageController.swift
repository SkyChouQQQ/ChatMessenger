//
//  ViewController.swift
//  Chaat
//
//  Created by Admin on 2018/12/5.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {
    
    @objc func handleLogOut() {
        do{
            try Auth.auth().signOut()
        }catch let logOutError {
            print(logOutError)
        }
        
        print("user is logOut")
        let loginController = LoginController()
        loginController.messageVC = self
        present(loginController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        } else {
                fetchUserAndSetUpNavBar()
        }
    }
    
    func fetchUserAndSetUpNavBar() {
        guard let uid = Auth.auth().currentUser?.uid else {return }
        Database.database().reference().child("users").child(uid).observe(.value){ (dataSnapShot) in
            if let dictionary = dataSnapShot.value as? [String:Any] {
                let user = User()
                DispatchQueue.main.async {
                    user.setValuesForKeys(dictionary)
                    self.setUpNaviBarWithUser(user: user)
                }
            }
        }
    }
    
    func setUpNaviBarWithUser(user:User) {
        let titleView:UIView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
            view.backgroundColor = .cyan
            return view
        }()
        
        let containerView:UIView = {
           let cv = UIView()
            cv.translatesAutoresizingMaskIntoConstraints =  false
            return cv
        }()
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        if let profileImageUrl = user.profileImageUrl {
        profileImageView.loadImageUsingCasheWithUrlString(urlString: profileImageUrl)
        }
        
        let nameLabel:UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = user.name
            label.font = UIFont.boldSystemFont(ofSize: 16)
            return label
        }()
        
        titleView.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    @objc func handleNewMessage(){
        let newMessageVC = NewMessageController()
        let naviVC = UINavigationController(rootViewController: newMessageVC)
        present(naviVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        let newMessageIconImage = #imageLiteral(resourceName: "new_message_icon")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessageIconImage, style: .plain, target: self, action: #selector(handleNewMessage))


}

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

