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
    
    var messages = [Message]()
    let cellId = "cellId"
    var messageDictionary = [String:Message]()
    
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
                user.setValuesForKeys(dictionary)
                self.setUpNaviBarWithUser(user: user)
            }
        }
    }
    


    

    func setUpNaviBarWithUser(user:User) {
        
        messages.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        

        observeUserMessages()
        
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.isUserInteractionEnabled = true
        
        
        
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints =  false
        containerView.isUserInteractionEnabled = true
        
        titleView.addSubview(containerView)
        
        let profileImageView:UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 20
            imageView.layer.masksToBounds = true
            if let profileImageUrl = user.profileImageUrl {
                imageView.loadImageUsingCasheWithUrlString(urlString: profileImageUrl)
            }
            return imageView
        }()
        
        let nameLabel:UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = user.name
            label.font = UIFont.boldSystemFont(ofSize: 16)
            return label
        }()
        
        
        
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
        newMessageVC.messageController = self
        let naviVC = UINavigationController(rootViewController: newMessageVC)
        present(naviVC, animated: true, completion: nil)
    }
    
    @objc func showChatLogControllerWithUser(_ user:User) {
        let chatLogVC = ChatLogController(collectionViewLayout:UICollectionViewFlowLayout())
            chatLogVC.user = user
        navigationController?.pushViewController(chatLogVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        let newMessageIconImage = #imageLiteral(resourceName: "new_message_icon")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessageIconImage, style: .plain, target: self, action: #selector(handleNewMessage))

        
}
    
    var reloadtableTimer:Timer?
    
    
    func observeUserMessages() {
        guard let userId = Auth.auth().currentUser?.uid else  {return }
        let ref = Database.database().reference().child("user-messages").child("\(userId)")
        ref.observe(.childAdded) { (snapShot) in
            
            let messageId = snapShot.key
            let messageRef = Database.database().reference().child("messages").child("\(messageId)")
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dic = snapshot.value as? [String:Any] {
                    let message = Message()
                    message.setValuesForKeys(dic)
                    if let chatPartnerId = message.checkChatPartnerId() {
                        self.messageDictionary[chatPartnerId] = message
                        self.messages = Array(self.messageDictionary.values)
                        self.messages = self.messages.sorted(by: { (m1, m2) -> Bool in
                            return m1.timeStamp!.intValue > m2.timeStamp!.intValue
                        })
                    }
                    self.reloadtableTimer?.invalidate()
                    self.reloadtableTimer = Timer.scheduledTimer(timeInterval: 0.12, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    
                }
            })
        }
    }

    @objc func handleReloadTable() {
        DispatchQueue.main.async {
            print("reload table")
            self.tableView.reloadData()
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        if let seconds = message.timeStamp, let timeInterval = TimeInterval(exactly: seconds)  {
            let date = Date(timeIntervalSince1970: timeInterval)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "a hh:mm"
            cell.timeLabel.text = dateFormatter.string(from: date)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return messages.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.checkChatPartnerId() else {return }
        let chatPartnerRef = Database.database().reference().child("users").child(chatPartnerId)
        chatPartnerRef.observeSingleEvent(of: .value) { (snapShot) in
            if let dic = snapShot.value as? [String:Any] {
                let user = User()
                user.id = chatPartnerId
                user.setValuesForKeys(dic)
                self.showChatLogControllerWithUser(user)
            }
        }
    }
    
}


