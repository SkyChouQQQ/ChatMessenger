//
//  NewsFeedController.swift
//  Intasgram
//
//  Created by Admin on 2019/1/16.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit
import Firebase

class NewsFeedController:UICollectionViewController,UICollectionViewDelegateFlowLayout,NewsFeedCellDelegate {
    
    
    
    
    let cellId = "cellId"
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(NewsFeedCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        applyTheme(withTheme: .Dark)
        
        setupNavigationBar()
        
        fetchAllPost()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlenewsharePostUploaded), name:SharePhotoController.sharePostDoneNotificationName, object: nil)
    }
    
    
    @objc func handlenewsharePostUploaded() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        self.posts.removeAll()
        fetchAllPost()
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.title =  "News Feed "
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus_unselected"), style: .plain, target: self, action: #selector(handleShowPhotoSelectorVC))
    }
    
    @objc func handleShowPhotoSelectorVC() {
        let layout = UICollectionViewFlowLayout()
        let photoSelectorController = PhotoSelectorController(collectionViewLayout:layout)
        let photoSelectorNavController = UINavigationController(rootViewController: photoSelectorController)
        present(photoSelectorNavController, animated: true, completion: nil)
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height:CGFloat = 40+8+8  //user profile image
        height += view.frame.width    //photo image
        height += 50   //action buttons
        height += 80  //comment
        return CGSize(width: view.frame.width, height: height)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsFeedCell
        cell.delegate = self
        if indexPath.item < posts.count {
            cell.post = posts[indexPath.item]
        }
        return cell
    }
    func didTapComment(post:Post) {
        let commentsVC = CommentsController(collectionViewLayout:UICollectionViewFlowLayout())
        commentsVC.post = post
        navigationController?.pushViewController(commentsVC, animated: true)
    }
    
    func didTapLike(for cell: NewsFeedCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else {return }
        var post = self.posts[indexPath.item]
        guard let userUid = Auth.auth().currentUser?.uid else {return }
        let values = [userUid:(post.isLike == true ? 0 : 1)]
        let likeRef = Database.database().reference().child("likes").child(post.id)
        likeRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Fail to upload like status ",error)
            }
            post.isLike = !post.isLike
            self.posts[indexPath.item] = post
            self.collectionView?.reloadItems(at: [indexPath])
        }
        
    }
    
    fileprivate func fetchAllPost() {
        fetchPosts()
        fetchFollowingUserUid()
    }
    
    fileprivate func fetchPosts() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return }
        FirebaseApp.fetchUserWithUserUid(uid: currentUserUid) { (user) in
            self.fetchPostsWithUser(user)
        }
    }
    
    fileprivate func fetchFollowingUserUid() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return }
        let ref = Database.database().reference().child("following").child(currentUserUid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let followinguserUidDic = snapshot.value as? [String:Any] else {return }
            followinguserUidDic.forEach({ (key, value) in
                FirebaseApp.fetchUserWithUserUid(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user)
                })
            })
        }
    }
    fileprivate func fetchPostsWithUser(_ user: User) {
        guard let userUid = user.id else {return }
        let postRef = Database.database().reference().child("posts").child(userUid)
        postRef.observeSingleEvent(of:.value, with: { (snapshot) in
            self.collectionView.refreshControl?.endRefreshing()
            guard let postDictionary = snapshot.value as? [String:Any] else {return }
            postDictionary.forEach({ (key, value) in
                
                guard let dictionary = value as? [String:Any] else {return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                guard let uid = Auth.auth().currentUser?.uid else {return }
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? Int, value == 1 {
                        post.isLike = true
                    } else {
                        post.isLike = false
                    }
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView?.reloadData()
                }, withCancel: { (error) in
                    print("Fail to fetch likes info reom db with error ,", error)
                })
                
            })
            
            
        }) { (error) in
            print("Fail to fetch user posts" ,error as Any)
        }
    }
}


