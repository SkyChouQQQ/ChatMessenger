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
    
    let inputImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleToFill
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
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
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
        tf.autocapitalizationType = .none
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
        tf.autocapitalizationType = .none
        tf.isSecureTextEntry = true
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        view.addSubview(inputImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(emailInputTextField)
        view.addSubview(emailSeparatorView)
        view.addSubview(passWordInputTextField)
        
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
        inputImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        inputImageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        inputImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    private func setUpLoginRegisterSegmentedControlView() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setUpInputContainerView(){
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(nameInputTextField)
        inputContainerView.addSubview(nameSeparatorView)
        
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
    
    @objc func handleLoginRegisterSegmentedControlValueChange(){
        //change title of register button
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
    
    func handleLogin(){
        guard let email = emailInputTextField.text, let password = passWordInputTextField.text, let name = nameInputTextField.text else {
            print("Form of Input is not correct")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print("user sign in fails")
                return
            }
            print("user successfully sign in")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
     func handleRegister(){
        
        guard let email = emailInputTextField.text, let password = passWordInputTextField.text, let name = nameInputTextField.text else {
            print("Form of Input is not correct")
            return
        }
    
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print("\(error)")
                return
            }
            // Successfully register to firebase
            guard let uid = result?.user.uid else{
                print(" user's uid unwrapped fails")
                return
            }
            let reference = Database.database().reference(fromURL: "https://chaat-f074a.firebaseio.com")
            let childReference = reference.child("users").child(uid)
            let value = ["name":name,"email":email]
            childReference.updateChildValues(value, withCompletionBlock: { (err, reference) in
                if err != nil {
                    print("\(err)")
                    return
                }
                print("Save User Successfully into firebase DB")
                self.dismiss(animated: true, completion: nil)
            })
            
        }
        
        
    }
    
}
    


extension UIColor {
    
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}