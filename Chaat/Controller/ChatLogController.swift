//
//  ChatLogController.swift
//  Chaat
//
//  Created by Admin on 2018/12/7.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate,UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    
    var user:User? {
        didSet {
            navigationItem.title = user?.name
            
            observeMessages()
        }
        
    }
    func observeMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return }
        let messagesCurrentUserRef = Database.database().reference().child("user-messages").child("\(currentUserId)")
        messagesCurrentUserRef.observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observe(.value, with: { (snapshot) in
                if let dic = snapshot.value as? [String:Any] {
                    let message = Message()
                    message.setValuesForKeys(dic)

                }
            })
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
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    
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

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleMessageSend()
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
