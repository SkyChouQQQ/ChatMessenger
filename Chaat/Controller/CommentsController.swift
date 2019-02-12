//
//  CommentsController.swift
//  Intasgram
//
//  Created by Admin on 2019/1/21.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit
import Firebase

class CommentsController:UICollectionViewController,UICollectionViewDelegateFlowLayout,CommentInputAccessoryViewDelegate {
    
    
    var post:Post?
    var comments = [Comment]()
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        fetchComments()
    }
    fileprivate func fetchComments() {
        guard let postId = self.post?.id else {return }
        let commentsRef = Database.database().reference().child("comments").child(postId)
        commentsRef.observe(.childAdded, with: { (snapshot) in
            guard let dic = snapshot.value as? [String:Any] else {return }
            guard let uid = dic["uid"] as? String else {return }
            FirebaseApp.fetchUserWithUserUid(uid: uid, completion: { (user) in
                let comment = Comment(user:user,dictionary: dic)
                self.comments.append(comment)
                self.collectionView?.reloadData()
            })
            
        }) { (error) in
            print("Fail to fetch comments ", error )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    
    lazy var inputContainerView:CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()
    
    func didSubmitComment(of comment: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let postId = self.post?.id ?? ""
        let commentsRef = Database.database().reference().child("comments").child(postId).childByAutoId()
        let commentText = comment
        let values:[String:Any] = ["text":commentText,"creationDate":Date().timeIntervalSince1970,"uid":uid]
        commentsRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Fail to update comments to DB ",error)
            }
            self.inputContainerView.clearCommentTextField()
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = self.comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40+8+8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = self.comments[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override var inputAccessoryView: UIView? {
        get {
            
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
