//
//  ChatLogController.swift
//  Chaat
//
//  Created by Admin on 2018/12/7.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let cellId = "cellId"
    
    var messages = [Message]()
    
    var user:User? {
        didSet {
            navigationItem.title = user?.name
            
            observeMessages()
        }
        
    }
    func observeMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid, let chatPartnerId = user?.id else {return }
        let messagesCurrentUserRef = Database.database().reference().child("user-messages").child("\(currentUserId)").child(chatPartnerId)
        messagesCurrentUserRef.observe(.childAdded) { (snapshot) in
            
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observe(.value, with: { (snapshot) in
                if let dic = snapshot.value as? [String:Any] {
                    let message = Message.init(dictionary: dic)
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        let indexPath = IndexPath(item: self.messages.count-1, section: 0)
                        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
              NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidHide), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    func unSubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardDidHide() {
        if messages.count>0 {
            let indexPath = IndexPath(item: messages.count-1, section: 0)
            collectionView.scrollToItem(at: indexPath, at:.top, animated: true)
        }
    }
    
    @objc func handleKeyboardWillShow(notification:Notification) {
        if let kbFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,let kbShowDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            containerViewBottomAnchor?.constant = -kbFrame.height
            UIView.animate(withDuration: kbShowDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func handleKeyboardWillHide(notification:Notification) {
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
        
        
        let uploadPhotoImageView = UIImageView()
        uploadPhotoImageView.image = UIImage(named: "upload_image_icon")
        uploadPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadPhotoImageView.isUserInteractionEnabled = true
        uploadPhotoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadPhoto)))
        
        containerView.addSubview(uploadPhotoImageView)
        
        uploadPhotoImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4).isActive = true
        uploadPhotoImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadPhotoImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadPhotoImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
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
        
        messageInputTextField.leftAnchor.constraint(equalTo: uploadPhotoImageView.rightAnchor, constant: 8).isActive = true
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
    
    
    @objc func handleUploadPhoto() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.allowsEditing = true
        imagePickerVC.delegate = self
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
            upLoadToFirDBWithSelectedImage(of: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func upLoadToFirDBWithSelectedImage(of image:UIImage) {
        let imageName = NSUUID().uuidString
        let storageReference = Storage.storage().reference().child("message_images").child("\(imageName).jpeg")
        if let imageUpLoadedData = image.jpegData(compressionQuality: 0.1) {
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
                    guard let imageUrlString = url?.absoluteString else {return }
                    
                    self.sendMessageWithImageUrl(imageUrlString, image:image)
                    
                    
                })
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func sendMessageWithImageUrl(_ imageUrlString:String,image:UIImage) {

        
        let values:[String : Any] = ["imageUrl":imageUrlString,"imageWidth":image.size.width,"imageHeight":image.size.height,"text":"Image has been sent."]

        sendMessageWithProperties(dictionary: values)
    }
    
    
    private func sendMessageWithProperties(dictionary:[String:Any]) {
        let reference = Database.database().reference().child("messages")
        let messageToId = user!.id!
        let messageFromId = Auth.auth().currentUser!.uid
        
        let childReference = reference.childByAutoId()
        let timeStamp = Int(Date().timeIntervalSince1970)
        
        var values:[String : Any] = ["messageToId":messageToId,"messageFromId":messageFromId,"timeStamp":timeStamp]
        dictionary.forEach{values[$0] = $1}
        
        childReference.updateChildValues(values) { (error, reference) in
            if error != nil {
                print(error as Any)
                return
            }
            
            guard let messageId = childReference.key else {return}
            
            let fromUserMessageRef = Database.database().reference().child("user-messages").child(messageFromId).child(messageToId)
            
            fromUserMessageRef.updateChildValues([messageId:1])
            
            let toUserMessageRef = Database.database().reference().child("user-messages").child(messageToId).child(messageFromId)
            
            toUserMessageRef.updateChildValues([messageId:1])
        }
    }
    
    @objc func handleMessageSend() {
        guard let messageText = messageInputTextField.text else {return }
        if messageText.isEmpty {
            return
        }
        
        sendMessageWithProperties(dictionary: ["text":messageText])
         messageInputTextField.text = nil
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
        
        
        cell.messageTextView.text = message.text
        
        if let messageText = message.text, message.imageUrl == nil {
            let offset:CGFloat = messageText.isEmpty ? 0 : 26
            cell.chatBubbleViewWidthAnchor?.constant = estimtatedRectForText(messageText).width + offset
            cell.messageTextView.isHidden = false
        } else if message.imageUrl != nil {
            cell.messageTextView.isHidden = true
            cell.chatBubbleViewWidthAnchor?.constant = 200
        }
        
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
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCasheWithUrlString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.chatBubbleView.backgroundColor = .clear
        } else {
            cell.messageImageView.isHidden = true
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
        
        let message = messages[indexPath.item]
        if let messageText = message.text, message.imageUrl == nil {
            let offset:CGFloat = (messageText.isEmpty ? 0 :20)
             height = estimtatedRectForText(messageText).height+offset
        } else if let imageHeight = message.imageHeight?.floatValue, let imageWidth = message.imageWidth?.floatValue {
            // h1/h2 = w1/w2
            height = CGFloat(((imageHeight*200)/imageWidth))
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
