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
        present(loginController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))
        
        //user not login
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        }
        

}
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

