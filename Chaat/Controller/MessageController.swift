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
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observe(.value) { (dataSnapShot) in
                
                if let dictionary = dataSnapShot.value as? [String:Any] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
                print(dataSnapShot)
            }
        }
    }
    @objc func handleNewMessage(){
        let newMessageVC = NewMessageController()
        let naviVC = UINavigationController(rootViewController: newMessageVC)
        present(naviVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newMessageIconImage = UIImage(named: "new_message_icon")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessageIconImage, style: .plain, target: self, action: #selector(handleNewMessage))
        //user not login
        checkIfUserIsLoggedIn()
    

}
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

