//
//  ViewController+theme.swift
//  Chaat
//
//  Created by Admin on 2019/2/5.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit
enum Theme {
    case Light
    case Dark
    case DarkTranslucent
}
extension UIViewController {
    
    
    func applyTheme(withTheme theme:Theme){
        switch theme {
        case .Light:
            setUpLightTheme()
            break
        case .Dark:
            setUpDarkTheme()
            break
        case .DarkTranslucent:
            setUpDarkTransTheme()
            break
        }
        
    }
    
    
    private func setBackImageAtnaviBar() {
        
    }
    
    private func setUpDarkTheme() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.ChaatBlue()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let height: CGFloat = 100 //whatever height you want to add to the existing height
        guard let bounds = self.navigationController?.navigationBar.bounds else {return }
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
    }
    private func setUpLightTheme() {
        let darkThemeBarTintColor = UIColor.init(red: 255.0/255.0, green: 51.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.tintColor = darkThemeBarTintColor
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.init(red: 46.0/255.0, green: 61.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        ]
        self.view.backgroundColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let height: CGFloat = 50 //whatever height you want to add to the existing height
        guard let bounds = self.navigationController?.navigationBar.bounds else {return }
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
    }
    private func setUpDarkTransTheme() {
        self.view.backgroundColor = UIColor.init(red: 46.0/255.0, green: 61.0/255.0, blue: 73.0/255.0, alpha: 0.9)
    }
    
}

