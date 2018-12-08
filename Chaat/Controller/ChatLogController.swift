//
//  ChatLogController.swift
//  Chaat
//
//  Created by Admin on 2018/12/7.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    var user:User? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    lazy var messageInputTextField:UITextField = {
        let messageInputTextField = UITextField()
        messageInputTextField.translatesAutoresizingMaskIntoConstraints = false
        messageInputTextField.placeholder = "Enter Message"
        messageInputTextField.delegate = self
        return messageInputTextField
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        setUpInputCompnenetsView()
    }
    
    private func setUpInputCompnenetsView() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
      
        
        view.addSubview(containerView)
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleMessageSend), for: .touchUpInside)
        
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        

        
        containerView.addSubview(messageInputTextField)
        
        messageInputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        messageInputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        messageInputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        messageInputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        
        let containerSeparatorView = UIView()
        containerSeparatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        containerSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(containerSeparatorView)
        
        containerSeparatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerSeparatorView.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        containerSeparatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func handleMessageSend() {
        let reference = Database.database().reference().child("messages")
        let messageToId = user!.id!
        let messageFromId = Auth.auth().currentUser!.uid
        
        let childReference = reference.childByAutoId()
        let timeStamp = Int(Date().timeIntervalSince1970)

        let values = ["text":messageInputTextField.text!,"messageToId":messageToId,"messageFromId":messageFromId,"timeStamp":timeStamp] as [String : Any]
        // childReference.updateChildValues(values)
        
        
        childReference.updateChildValues(values) { (error, reference) in
            if error != nil {
                print(error as Any)
                return
            }
            
            guard let messageId = childReference.key else {return}

            let fromUserMessageRef = Database.database().reference().child("user-messages").child(messageFromId)
            
            fromUserMessageRef.updateChildValues([messageId:1])
            
            let toUserMessageRef = Database.database().reference().child("user-messages").child(messageToId)
            
            toUserMessageRef.updateChildValues([messageId:1])
        }
         messageInputTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleMessageSend()
        return true
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
