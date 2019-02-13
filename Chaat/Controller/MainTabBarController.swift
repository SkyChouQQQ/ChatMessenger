//
//  MainTabBarController.swift
//  Chaat
//
//  Created by Admin on 2019/2/2.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController:UITabBarController,UITabBarControllerDelegate {
    
        func setUpViewController() {
        
            let friendsNavVC = templateNavVC(unselectedImage: UIImage(named: "friends_unselected")!, selectedImage: UIImage(named: "friends_selected")!, rootVC: FriendsListController())
            
            let messagesNavVC = templateNavVC(unselectedImage: UIImage(named: "chat_unselected")!, selectedImage: UIImage(named: "chat_selected")!,rootVC:MessageController())
            
            let searchNavVC = templateNavVC(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!,rootVC: UserSearchController(collectionViewLayout:UICollectionViewFlowLayout()))
            
            let newsFeedLayout = UICollectionViewFlowLayout()
            let newsFeedVC = NewsFeedController(collectionViewLayout:newsFeedLayout)
            let newsFeedNvVC = templateNavVC(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!,rootVC:newsFeedVC)
            
            let userProfileLayout = UICollectionViewFlowLayout()
            let userProfileVC = UserProfileController(collectionViewLayout:userProfileLayout)
            let userProfileNavVC = templateNavVC(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootVC: userProfileVC)
            
            
            if let messageVC = messagesNavVC.rootViewController as? MessageController {
                messageVC.fetchUserAndSetUpNavBar()
            }
            
            tabBar.tintColor = .black
            
        viewControllers = [friendsNavVC,messagesNavVC,searchNavVC,newsFeedNvVC,userProfileNavVC]
        
        //modify tab bar item insets
        guard let tabBarItems = tabBar.items else {return }
        
        for item in tabBarItems {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self

        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginVC = LoginController()
                self.present(loginVC, animated: true, completion: nil)
            }
            
            return
        }
        
        setUpViewController()
        
    }
    

    
    func templateNavVC(unselectedImage:UIImage,selectedImage:UIImage,rootVC:UIViewController)->UINavigationController {
        let viewController = rootVC
        let navViewController = UINavigationController(rootViewController: viewController)
        
        navViewController.tabBarItem.image = unselectedImage
        navViewController.tabBarItem.selectedImage = selectedImage
        return navViewController
    }
    
    //MARK:- tab bar VC delegate method
    

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        return true
    }
    
}

