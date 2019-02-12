//
//  SharePhotoController.swift
//  Intasgram
//
//  Created by Admin on 2019/1/15.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController:UIViewController {
    
    var photoImage:UIImage? {
        didSet {
            self.photoImageView.image = photoImage
        }
    }
    
    let photoImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .red
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    let captiontextView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(r: 240, g: 240, b: 240)
        
        setUpNavigationBar()
        setUpVCView()
    }
    fileprivate func setUpNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    }
    
    fileprivate func setUpVCView() {
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.addSubview(photoImageView)
        containerView.addSubview(captiontextView)
        
        if #available(iOS 11.0, *) {
            containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 0, bottom: nil, bottonConstant: 0, left: view.leftAnchor, leftConstant: 0, right: view.rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 100)
        } else {
            // Fallback on earlier versions
        }
        
        photoImageView.anchor(top: containerView.topAnchor, topConstant: 8, bottom: containerView.bottomAnchor, bottonConstant: -8, left: containerView.leftAnchor, leftConstant: 8, right: nil, rightConstant: 0, widthConstant: 84, heightConstant: 0)
        
        captiontextView.anchor(top: containerView.topAnchor, topConstant: 0, bottom: containerView.bottomAnchor, bottonConstant: 0, left: photoImageView.rightAnchor, leftConstant: 4, right: containerView.rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    @objc func handleShare() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        let fileName = UUID.init().uuidString
        let reference = Storage.storage().reference().child("posts").child(fileName)
        guard let uploadData = self.photoImage?.jpegData(compressionQuality: 0.5) else {return }
        
        reference.putData(uploadData, metadata: nil) { (metaData, error) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("upload photo fails with error", error as Any)
            }
            print("upload photos sucessfully")
            
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("download photo url fails with error", error as Any)
                }
                guard let url = url?.absoluteString else {return }
                self.savePost2DBWithImageUrl(imageUrl: url)
            })
            
        }
        
        
    }
    
    static let sharePostDoneNotificationName = Notification.Name(rawValue: "sharePostDone")
    
    fileprivate func savePost2DBWithImageUrl(imageUrl:String) {
        guard let captiontext = captiontextView.text else {return }
        guard let selectedImage = self.photoImage else {return }
        guard let userUid = Auth.auth().currentUser?.uid else {return }
        let postRef = Database.database().reference().child("posts").child(userUid).childByAutoId()
        let uploadPostInfo:[String:Any] = ["imageUrl":imageUrl,"imageWidth":selectedImage.size.width,"imageHeight":selectedImage.size.height,"creationDate":Date().timeIntervalSince1970,"caption":captiontext]
        postRef.updateChildValues(uploadPostInfo) { (error, ref) in
            if let error = error {
                print("Fail to upload post info with error", error as Any)
            }
            print("Sucessfully upload post info to DB")
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: SharePhotoController.sharePostDoneNotificationName, object: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
