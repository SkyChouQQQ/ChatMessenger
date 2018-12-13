//
//  ChatLogInputView.swift
//  Chaat
//
//  Created by Admin on 2018/12/13.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit

protocol ChatLogInputViewDelegate {
    func handleUploadPhoto()
    func handleMessageSend()
}

class ChatLogInputView:UIView,UITextFieldDelegate {
    
    var delegate:ChatLogInputViewDelegate?
    
    lazy var messageInputTextField:UITextField = {
        let messageInputTextField = UITextField()
        messageInputTextField.translatesAutoresizingMaskIntoConstraints = false
        messageInputTextField.placeholder = "Enter Message"
        messageInputTextField.delegate = self
        return messageInputTextField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        backgroundColor = .white
     
        
        let uploadPhotoImageView = UIImageView()
        uploadPhotoImageView.image = UIImage(named: "upload_image_icon")
        uploadPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadPhotoImageView.isUserInteractionEnabled = true
        uploadPhotoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadPhoto)))
        
       addSubview(uploadPhotoImageView)
        
        uploadPhotoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        uploadPhotoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadPhotoImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadPhotoImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleMessageSend), for: .touchUpInside)
        
        addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -25).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(messageInputTextField)
        
        messageInputTextField.leftAnchor.constraint(equalTo: uploadPhotoImageView.rightAnchor, constant: 8).isActive = true
        messageInputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        messageInputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        messageInputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        
        let containerSeparatorView = UIView()
        containerSeparatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        containerSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerSeparatorView)
        
        containerSeparatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        containerSeparatorView.bottomAnchor.constraint(equalTo: topAnchor).isActive = true
        containerSeparatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        containerSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func handleUploadPhoto() {
        delegate?.handleUploadPhoto()
    }
    
    @objc func handleMessageSend() {
        delegate?.handleMessageSend()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        handleMessageSend()
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
