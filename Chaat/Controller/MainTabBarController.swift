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
    
    fileprivate func setUpViewController() {
        
        let friendsNavVC = templateNavVC(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootVC: UIViewController())
        
        let messagesNavVC = templateNavVC(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!,rootVC: MessageController())
        
        let userProfileNavVC = templateNavVC(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootVC: UIViewController())
        
        
        tabBar.tintColor = .black
        
        viewControllers = [friendsNavVC,messagesNavVC,userProfileNavVC]
        
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
//            DispatchQueue.main.async {
//                let signupController = SignUpViewController()
//                let navigationController = UINavigationController(rootViewController: signupController)
//                self.present(navigationController, animated: true, completion: nil)
//            }
            
            return
        }
        
        setUpViewController()
        
    }
    

    
    func templateNavVC(unselectedImage:UIImage,selectedImage:UIImage,rootVC:UIViewController = UIViewController())->UINavigationController {
        let viewController = rootVC
        let navViewController = UINavigationController(rootViewController: viewController)
        
        navViewController.tabBarItem.image = unselectedImage
        navViewController.tabBarItem.selectedImage = selectedImage
        return navViewController
    }
    
    //MARK:- tab bar VC delegate method
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        let selectedIndex = viewControllers?.index(of:viewController)
        
//        if selectedIndex == 2{
//
//            let layout = UICollectionViewFlowLayout()
//            let photoSelectorController = PhotoSelectorController(collectionViewLayout:layout)
//            let photoSelectorNavController = UINavigationController(rootViewController: photoSelectorController)
//            present(photoSelectorNavController, animated: true, completion: nil)
//            return false
//        }
        
        return true
    }
    
}

