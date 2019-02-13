//
//  UserProfileController.swift
//  Intasgram
//
//  Created by Admin on 2018/12/16.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController:UICollectionViewController,UICollectionViewDelegateFlowLayout,UserProfileHeaderDelegate {
    
    let headerId = "headerId"
    let gridCellId = "gridCellId"
    let listCellId = "listCellId"
    var user:User?
    var userUid:String?
    var posts = [Post]()
    var isGridView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader , withReuseIdentifier: headerId)
        
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: gridCellId)
        collectionView.register(NewsFeedCell.self, forCellWithReuseIdentifier: listCellId)
        
        
        applyTheme(withTheme: .Dark)
        
        fetchUser()
        
    }
    
    func fetchUser() {
        let uid = self.userUid ?? (Auth.auth().currentUser?.uid ?? "")
        
        FirebaseApp.fetchUserWithUserUid(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = "User"
            self.collectionView.reloadData()
            
            //self.fetchOrderedPosts(with:user)
            self.paginatePosts()
        }
        
    }
    

    
    var isPagingfinished = false
    fileprivate func paginatePosts() {
        guard let uid = self.user?.id else {return }
        guard let user = self.user else {return }
        let ref = Database.database().reference().child("posts").child(uid)
        var query = ref.queryOrdered(byChild: "creationDate")
        if posts.count>0 {
            guard let value = posts.last?.creationDate.timeIntervalSince1970 else {return }
            query = query.queryEnding(atValue: value)
        }
        query.queryLimited(toLast: 2).observeSingleEvent(of: .value, with: { (snapshot) in
            guard var postsAllObjects = snapshot.children.allObjects as? [DataSnapshot] else {return }
            postsAllObjects.reverse()
            if postsAllObjects.count<2 {
                self.isPagingfinished = true
            }
            if self.posts.count > 0 && postsAllObjects.count > 0 {
                postsAllObjects.removeFirst()
            }
            postsAllObjects.forEach({ (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else {return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = snapshot.key
                self.posts.append(post)
                
            })
            self.collectionView.reloadData()
            
        }) { (error) in
            print("Fail to fetch post from DB ",error)
        }
        
    }
    fileprivate func fetchOrderedPosts(with user:User) {
        guard let userUid = user.id else {return }
        let postRef = Database.database().reference().child("posts").child(userUid)
        postRef.queryOrdered(byChild: "creationDate").observe(.childAdded) { (snapshot) in
            guard let postDictionary = snapshot.value as? [String:Any] else {return }
            guard let user = self.user else {return }
            let post = Post(user: user, dictionary: postDictionary)
            self.posts.insert(post, at: 0)
            self.collectionView?.reloadData()
        }
    }
    
    

    
    
    
    // MARK:- collection view method
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        header.user = self.user
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-2)/3
        if isGridView {
            return CGSize(width: width, height: width)
        } else {
            var height:CGFloat = 40+8+8  //user profile image
            height += view.frame.width    //photo image
            height += 50   //action buttons
            height += 80  //comment
            return CGSize(width: view.frame.width, height: height)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == self.posts.count-1 && !isPagingfinished {
            self.paginatePosts()
        }
        
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCellId, for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.item]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listCellId, for: indexPath) as! NewsFeedCell
            cell.post = posts[indexPath.item]
            return cell
        }
        
    }
    
    func didChangeToGridView() {
        isGridView = true
        collectionView?.reloadData()
    }
    func didChangeToListView() {
        isGridView = false
        collectionView?.reloadData()
    }
}
