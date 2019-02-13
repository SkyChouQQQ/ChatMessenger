//
//  ChatLogController.swift
//  Chaat
//
//  Created by Admin on 2018/12/7.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

class ChatLogController: UICollectionViewController,UITextFieldDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ChatMessageCellDelegate,ChatLogInputViewDelegate {

    
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
                        self.attemptReloadChatCollection()
                    }
                }
            })
        }
    }
    
    var reloadChatCollection:Timer?
    
    private func attemptReloadChatCollection() {
        self.reloadChatCollection?.invalidate()
        self.reloadChatCollection = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(self.handleReloadChatCollection), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadChatCollection() {
        self.collectionView.reloadData()
        if messages.count>0 {
            let indexPath = IndexPath(item: self.messages.count-1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }

    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.ChatLogBGColor()
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView.alwaysBounceVertical = true
        
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
    
        setUpInputCompnenetsView()
        
        subscribeToKeyboardNotifications()
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
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
    
    lazy var inputContainerView:ChatLogInputView = {
        let chatInputContainerView = ChatLogInputView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        chatInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        chatInputContainerView.delegate = self
        return chatInputContainerView
       
    }()
    
    var containerViewBottomAnchor:NSLayoutConstraint?
    
    private func setUpInputCompnenetsView() {
     
        view.addSubview(inputContainerView)
        
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerViewBottomAnchor = inputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant:0)
        containerViewBottomAnchor?.isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    
    func handleUploadPhoto() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.allowsEditing = true
        imagePickerVC.delegate = self
        imagePickerVC.mediaTypes = [kUTTypeImage as String]
        present(imagePickerVC, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            handleVideoSelectedForUrl(url: videoUrl)
        }
        
        handleImageSelectedForInfo(info: info)
        

    }
    
    private func handleVideoSelectedForUrl(url:URL) {
        let videoFile = "videoFile"
        let videoRef = Storage.storage().reference().child(videoFile).child("testvideo.mov")
        let uploadVideoTask = videoRef.putFile(from: url, metadata: nil) { (metaData, error) in
            if error != nil {
                print("upload video failed with error", error as Any)
            }
            
            videoRef.downloadURL(completion: { (url, error) in
                
                guard let videoUrl = url  else {return }
                let properties = ["videoUrl":videoUrl.absoluteString]
                
                let videoAsset = AVURLAsset(url: videoUrl)
                self.sendMessageWithProperties(dictionary: properties)
                if let thumbnailImage = videoAsset.videoThumbnail {
                    let values:[String : Any] = ["imageWidth":thumbnailImage.size.width,"imageHeight":thumbnailImage.size.height,"videoUrl":videoUrl.absoluteString]
                    self.sendMessageWithProperties(dictionary: values)
                }
                
                
            })
            
        }
        
        uploadVideoTask.observe(.progress) { (snapShot) in
            if let uploadUbitCount = snapShot.progress?.completedUnitCount {
                self.navigationItem.title = String(uploadUbitCount)
            }
        }
        
        uploadVideoTask.observe(.success) { (snapShot) in
            self.navigationItem.title = self.user?.name
        }
    }
    

    private func handleImageSelectedForInfo(info:[UIImagePickerController.InfoKey : Any]) {
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
    
    func handleMessageSend() {
        guard let messageText = inputContainerView.messageInputTextField.text else {return }
        if messageText.isEmpty {
            return
        }
        
        sendMessageWithProperties(dictionary: ["text":messageText])
         inputContainerView.messageInputTextField.text = nil
    }
    
    

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.delegate = self
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
            cell.chatBubbleView.backgroundColor = UIColor.purpleBlue
            cell.messageTextView.textColor = UIColor.lightWhite
            cell.profileImageView.isHidden = true
            cell.chatBubbleRightAnchor?.isActive = true
            cell.chatBubbleLeftAnchor?.isActive = false
        } else {
            cell.chatBubbleView.backgroundColor = UIColor.orange
            cell.messageTextView.textColor = UIColor.lightWhite
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
    
    func handleImageViewZoomIn(tapGesture: UITapGestureRecognizer) {
        self.startingZoomInImageView = tapGesture.view as? UIImageView
        performzoominForStartingImageView(startingImageView: startingZoomInImageView!)
    }
    
    var startingZoomInImageView:UIImageView?
    var startingFrame:CGRect?
    var zoomingBackgroundView:UIView?
    
    private func performzoominForStartingImageView(startingImageView:UIImageView) {
            self.startingZoomInImageView?.isHidden = true
         startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomInImageView = UIImageView()
        zoomInImageView.frame = startingFrame!
        zoomInImageView.layer.cornerRadius = 16
        zoomInImageView.layer.masksToBounds = true
        zoomInImageView.image = startingImageView.image
        zoomInImageView.isUserInteractionEnabled = true
        zoomInImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(handleZoomOut(tapGesture:))))
        
        if let window = UIApplication.shared.keyWindow {
            zoomingBackgroundView = UIView(frame: window.frame)
            zoomingBackgroundView?.alpha = 0
            zoomingBackgroundView?.backgroundColor = UIColor.black
            
            
            let height = ((window.frame.width)*startingImageView.frame.height)/startingImageView.frame.width
            
            window.addSubview(zoomingBackgroundView!)
            window.addSubview(zoomInImageView)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.zoomingBackgroundView?.alpha = 1
                zoomInImageView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: height)
                zoomInImageView.center = window.center
                self.inputContainerView.alpha = 0
                
            }, completion: nil)
        }
    }
    
    @objc func handleZoomOut(tapGesture:UITapGestureRecognizer) {
        guard let zoomOutImageView = tapGesture.view as? UIImageView else {return }
        zoomOutImageView.layer.cornerRadius = 16
        zoomOutImageView.clipsToBounds = true
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            zoomOutImageView.frame = self.startingFrame!
            self.zoomingBackgroundView?.alpha = 0
            self.inputContainerView.alpha = 1
            
        }, completion:{ (completion) in
            self.startingZoomInImageView?.isHidden = false
            zoomOutImageView.removeFromSuperview()
        
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}
