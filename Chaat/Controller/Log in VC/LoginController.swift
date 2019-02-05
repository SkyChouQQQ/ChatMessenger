//
//  LoginController.swift
//  Chaat
//
//  Created by Admin on 2018/12/5.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
        
    lazy var inputProfileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleToFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSeletedProfileImageViewTapped)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let loginRegisterSegmentedControl:UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterSegmentedControlValueChange), for: .valueChanged)
        return sc
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
        button.backgroundColor = UIColor.disableRegisterButtonColor()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var nameInputTextField:UITextField = {
       let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(handleInputValueChange), for: .editingChanged)
        return tf
    }()
    
    let nameSeparatorView:UIView = {
        let nv = UIView()
        nv.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        nv.translatesAutoresizingMaskIntoConstraints = false
        return nv
    }()
    
    lazy var emailInputTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleInputValueChange), for: .editingChanged)
        return tf
    }()
    
    let emailSeparatorView:UIView = {
        let nv = UIView()
        nv.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        nv.translatesAutoresizingMaskIntoConstraints = false
        return nv
    }()
    
    lazy var passWordInputTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocapitalizationType = .none
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleInputValueChange), for: .editingChanged)
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.ChaatBlue()
        
        view.addSubview(inputProfileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)

        
        setUpInputContainerView()
        setUpLoginRegisterButtonView()
        setUpInputImageView()
        setUpLoginRegisterSegmentedControlView()
    }
    
    
    var inputContainerViewHeightAnchor:NSLayoutConstraint?
    var nameTextFieldHeightAnchor:NSLayoutConstraint?
    var emailTextFieldHeightAnchor:NSLayoutConstraint?
    var passwordTextFieldHeightAnchor:NSLayoutConstraint?
    
    
    private func setUpInputImageView(){
        inputProfileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputProfileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -20).isActive = true
        inputProfileImageView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        inputProfileImageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
    }
    private func setUpLoginRegisterSegmentedControlView() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setUpInputContainerView(){
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant:80).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(nameInputTextField)
        inputContainerView.addSubview(nameSeparatorView)
        inputContainerView.addSubview(emailInputTextField)
        inputContainerView.addSubview(emailSeparatorView)
        inputContainerView.addSubview(passWordInputTextField)
        
        nameInputTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameInputTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameInputTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameInputTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameInputTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailInputTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        emailInputTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailInputTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailInputTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailInputTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passWordInputTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passWordInputTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passWordInputTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passWordInputTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    private func setUpLoginRegisterButtonView(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.centerYAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 30).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @objc func handleInputValueChange() {
        let isRegisterInputFinish  = (emailInputTextField.text?.count ?? 0)>0 && (nameInputTextField.text?.count ?? 0)>0 && (passWordInputTextField.text?.count ?? 0)>5
        let isLoginInputFinish = (emailInputTextField.text?.count ?? 0)>0 && (passWordInputTextField.text?.count ?? 0)>5
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            loginRegisterButton.backgroundColor = isLoginInputFinish ? UIColor.enableRegisterButtonColor() :UIColor.disableRegisterButtonColor()
            loginRegisterButton.isEnabled = isLoginInputFinish ? true : false
        } else {
            loginRegisterButton.backgroundColor = isRegisterInputFinish ? UIColor.enableRegisterButtonColor():UIColor.disableRegisterButtonColor()
            loginRegisterButton.isEnabled = isRegisterInputFinish ? true : false
        }
        
    }
    
    @objc func handleLoginRegisterSegmentedControlValueChange(){
        //change title of register button
        handleInputValueChange()
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
            loginRegisterButton.setTitle(title, for: .normal)
        
        //change input container height
        inputContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        //change height of nametextfield
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameInputTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: (loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3))
        nameTextFieldHeightAnchor?.isActive = true
        //change height of emailtextfield
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailInputTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: (loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3))
        emailTextFieldHeightAnchor?.isActive = true
        //change height of passwordtextfield
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passWordInputTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: (loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3))
        passwordTextFieldHeightAnchor?.isActive = true
    }
    

    @objc func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else {
            handleRegister()
        }
    }
    

    
}
    

