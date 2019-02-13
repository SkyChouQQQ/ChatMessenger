//
//  FriendsListController.swift
//  Chaat
//
//  Created by Admin on 2019/2/5.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit
import Firebase


class FriendsListController:UITableViewController  {
    var user:User?
    var userUid:String?
    let cellId = "cellId"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme(withTheme: .Dark)
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView?.refreshControl = refreshControl
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear"), style: .plain, target:self , action: #selector(handleLogOut))
       fetchUser()
       fetchUserFriendsUid()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleWhereFriendsInfoUpdated), name:UserProfileHeader.updateFriendsInfoNotificationName, object: nil)
    }
    
    @objc func handleWhereFriendsInfoUpdated() {
        handleRefresh()
        
    }
    
    @objc func handleRefresh() {
        self.users.removeAll()
        fetchUserFriendsUid()
    }
    
    @objc fileprivate func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            print("Log out")
            do
            {
                try Auth.auth().signOut()
                let loginVC = LoginController()
                let naviVC = UINavigationController(rootViewController: loginVC)
                self.present(naviVC, animated: true, completion: nil)
            } catch let signOutError {
                print("User sign out fails with error", signOutError)
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        present(alertController, animated: true, completion: nil)
    }
    fileprivate func fetchUserFriendsUid() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return }
        let ref = Database.database().reference().child("friends").child(currentUserUid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            self.tableView?.refreshControl?.endRefreshing()
            guard let followinguserUidDic = snapshot.value as? [String:Any] else {return }
            followinguserUidDic.forEach({ (key, value) in
                FirebaseApp.fetchUserWithUserUid(uid: key, completion: { (user) in
                    self.users.append(user)
                   self.tableView.reloadData()
                })
                
            })
            
        }
       
    
    
}
    

    
    fileprivate func fetchUser() {
        let uid = self.userUid ?? (Auth.auth().currentUser?.uid ?? "")
        
        FirebaseApp.fetchUserWithUserUid(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = "Friends"
            self.tableView.reloadData()
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        if indexPath.row < users.count {
            
            let user = users[indexPath.row]
           
            cell.userNameLabel.text = user.name
            cell.containerView.backgroundColor = setTableCellBackgroundColor(with: indexPath.row)
            if let profileImageUrl = user.profileImageUrl {
                cell.profileImageView.loadImageUsingCasheWithUrlString(urlString: profileImageUrl)
            }
        }
        return cell
    }
    
    fileprivate func setTableCellBackgroundColor(with index:Int)->UIColor{
        return UIColor.chaatColorBox[index%5]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        showChatVC(with: user)
    }
    fileprivate func showChatVC(with user:User) {
        let chatLogVC = ChatLogController(collectionViewLayout:UICollectionViewFlowLayout())
        chatLogVC.user = user
        navigationController?.pushViewController(chatLogVC, animated: true)
        

    }
}
