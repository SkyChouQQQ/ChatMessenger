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
    
    var messages = [Message]()
    
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
                    if message.checkChatPartnerId() == self.user?.id {
                        self.messages.append(message)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }

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
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
    
        setUpInputCompnenetsView()
        
        subscribeToKeyboardNotifications()
        

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unSubscribeToKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unSubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        if let kbFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,let kbShowDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            containerViewBottomAnchor?.constant = -kbFrame.height
            UIView.animate(withDuration: kbShowDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        containerViewBottomAnchor?.constant = 0
        if let kbHideDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: kbHideDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    var containerViewBottomAnchor:NSLayoutConstraint?
    
    private func setUpInputCompnenetsView() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
      
        
        view.addSubview(containerView)
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant:0)
        containerViewBottomAnchor?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleMessageSend), for: .touchUpInside)
        
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -25).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerView.addSubview(messageInputTextField)
        
        messageInputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 25).isActive = true
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
        if messageInputTextField.text!.isEmpty {
            return
        }
        
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

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        setUpChatMessageCell(cell: cell, message: message)
        
        return cell
    }
    
    private func setUpChatMessageCell(cell:ChatMessageCell,message:Message) {
        
        if let profileImageUrlString = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCasheWithUrlString(urlString: profileImageUrlString)
        }
        
        let offset:CGFloat = message.text!.isEmpty ? 0 : 26
        cell.messageTextView.text = message.text
        cell.chatBubbleViewWidthAnchor?.constant = estimtatedRectForText(message.text!).width + offset
        
        if message.messageFromId == Auth.auth().currentUser?.uid {
            cell.chatBubbleView.backgroundColor = ChatMessageCell.chatBubbleBlue
            cell.messageTextView.textColor = .white
            cell.profileImageView.isHidden = true
            cell.chatBubbleRightAnchor?.isActive = true
            cell.chatBubbleLeftAnchor?.isActive = false
        } else {
            cell.chatBubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.messageTextView.textColor = .black
            cell.profileImageView.isHidden = false
            cell.chatBubbleRightAnchor?.isActive = false
            cell.chatBubbleLeftAnchor?.isActive = true
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        handleMessageSend()
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 80
        
        if let messageText = messages[indexPath.item].text {
            let offset:CGFloat = (messageText.isEmpty ? 0 :20)
             height = estimtatedRectForText(messageText).height+offset
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height:height)
    }
    
    
    private func estimtatedRectForText(_ string:String)->CGRect {
        let size = CGSize(width: 200, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        if string.isEmpty == true {
            return .zero
        }
        
        return NSString(string: string).boundingRect(with: size, options: option, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], context: nil)
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
