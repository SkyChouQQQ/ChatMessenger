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
    let headerId = "headerId"
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme(withTheme: .Dark)
        view.backgroundColor = .cyan
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
       fetchUser()
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
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
}
