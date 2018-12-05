//
//  ViewController.swift
//  Chaat
//
//  Created by Admin on 2018/12/5.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    @objc func handleLogOut() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))
   


}
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

