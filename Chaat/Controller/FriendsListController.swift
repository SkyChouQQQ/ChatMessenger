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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear"), style: .plain, target:self , action: #selector(handleLogOut))
        
       fetchUser()
       fetchUserFriends()
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
    fileprivate func fetchUserFriends() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let user = User(id: snapshot.key, dic: dictionary)
                if user.id != Auth.auth().currentUser?.uid {
                    self.users.append(user)
                }
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    fileprivate func fetchUser() {
        let uid = self.userUid ?? (Auth.auth().currentUser?.uid ?? "")
        
        FirebaseApp.fetchUserWithUserUid(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.name
            self.tableView.reloadData()
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCasheWithUrlString(urlString: profileImageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
    }
    
}
