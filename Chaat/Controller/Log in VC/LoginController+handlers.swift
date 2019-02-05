//
//  LoginController+handlers.swift
//  Chaat
//
//  Created by Admin on 2018/12/7.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit
import Firebase


extension LoginController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func handleRegister(){
        
        guard let email = emailInputTextField.text, email.count>0 else {return }
        guard let password = passWordInputTextField.text,password.count>0 else {return }
        guard let name = nameInputTextField.text, name.count>0 else {return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error as Any)
                return
            }
            // Successfully register to firebase
            guard let uid = result?.user.uid else{
                print(" user's uid unwrapped fails")
                return
            }
            let imageName = NSUUID().uuidString
            let storageReference = Storage.storage().reference().child("users_profile_images").child("\(imageName).jpeg")
            if let imageUpLoadedData = self.inputProfileImageView.image?.jpegData(compressionQuality: 0.1) {
                storageReference.putData(imageUpLoadedData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    
                    storageReference.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print("download profileImageUrl fail")
                            return
                        }
                        guard let profileImageUrl = url?.absoluteString else {return }
                        let value = ["name":name,"email":email,"profileImageUrl":profileImageUrl]
                        self.registerUerIntoDatabaseWithUid(uid: uid, values: value)


                    })
                })
            }
        }
    }
    
    private func registerUerIntoDatabaseWithUid(uid:String, values:[String:Any]) {
        let user = User(id: uid, dic: values)
        user.setValuesForKeys(values)
        let reference = Database.database().reference()
        let childReference = reference.child("users").child(uid)
        childReference.updateChildValues(values, withCompletionBlock: { (err, reference) in
            if err != nil {
                print(err as Any)
                return
            }
            
            print("Save User Successfully into firebase DB")
            self.showMainTabBarVCAfterLogin()
           
        
        })
    }
    
    func handleLogin(){
        guard let email = emailInputTextField.text, let password = passWordInputTextField.text else {
            print("Form of Input is not correct")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print("user sign in fails")
                return
            }
            print("user successfully sign in")
            self.showMainTabBarVCAfterLogin()
          
        }
    }
    
    fileprivate func showMainTabBarVCAfterLogin() {
        guard let maintabBarVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return }
        maintabBarVC.setUpViewController()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSeletedProfileImageViewTapped() {
        let imagePickerVC:UIImagePickerController = {
            let pickerVC = UIImagePickerController()
            pickerVC.delegate = self
            pickerVC.sourceType = .photoLibrary
            pickerVC.allowsEditing = true
            return pickerVC
        }()
        present(imagePickerVC, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker:UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            self.inputProfileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

