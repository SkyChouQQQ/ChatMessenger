//
//  LoginController.swift
//  Chaat
//
//  Created by Admin on 2018/12/5.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    let inputImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let inputContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginRegisterButton:UIButton = {
       let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameInputTextField:UITextField = {
       let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView:UIView = {
        let nv = UIView()
        nv.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        nv.translatesAutoresizingMaskIntoConstraints = false
        return nv
    }()
    
    let emailInputTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView:UIView = {
        let nv = UIView()
        nv.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        nv.translatesAutoresizingMaskIntoConstraints = false
        return nv
    }()
    
    let passWordInputTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        view.addSubview(inputImageView)
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(emailInputTextField)
        view.addSubview(emailSeparatorView)
        view.addSubview(passWordInputTextField)
        
        setUpInputContainerView()
        setUpLoginRegisterButtonView()
        setUpInputImageView()
    }
    
    private func setUpInputImageView(){
        inputImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputImageView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        inputImageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        inputImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    private func setUpInputContainerView(){
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputContainerView.addSubview(nameInputTextField)
        inputContainerView.addSubview(nameSeparatorView)
        
        nameInputTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameInputTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameInputTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameInputTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameInputTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailInputTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        emailInputTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailInputTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailInputTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailInputTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passWordInputTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passWordInputTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passWordInputTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passWordInputTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
    }
    
    private func setUpLoginRegisterButtonView(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.centerYAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 30).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    
}
    


extension UIColor {
    
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
