//
//  UserSearchController.swift
//  Intasgram
//
//  Created by Admin on 2019/1/19.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit
import Firebase


class UserSearchController:UICollectionViewController,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UserSearchCellDelegate {

    let cellId = "cellId"
    var filteredUser = [User]()
    var users = [User]()
    lazy var userSearchBar:UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Enter Username"
        bar.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230)
        bar.delegate = self
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        setUpNavigationBar()
        
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)

        collectionView.alwaysBounceVertical = true
        
        fetchUsers()
        collectionView?.keyboardDismissMode = .onDrag
    }
    
    fileprivate func fetchUsers() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let usersDic = snapshot.value as? [String:Any] else {return }
            usersDic.forEach({ (key,value) in
                if key == Auth.auth().currentUser?.uid {return }
                guard let userDic = value as? [String:Any] else {return }
                let user = User(id: key, dic: userDic)
                self.users.append(user)
            })
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.name!.compare(u2.name!) == .orderedAscending
            })
            self.filteredUser = self.users
            self.collectionView?.reloadData()
        }
    }
    fileprivate func setUpNavigationBar() {
        applyTheme(withTheme: .Dark)

        setupUserSearchBar()
    }
    
    
    
    fileprivate func setupUserSearchBar() {
        let naviBar = navigationController?.navigationBar
        naviBar?.addSubview(userSearchBar)
        userSearchBar.anchor(top: naviBar?.topAnchor, topConstant:0, bottom: naviBar?.bottomAnchor, bottonConstant: 0, left: naviBar?.leftAnchor, leftConstant: 8, right: naviBar?.rightAnchor, rightConstant: -8, widthConstant: 0, heightConstant: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUser.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUser[indexPath.item]
        cell.delegate = self
        //walkaround
        cell.addFriendButton.isHidden = true
        return cell
    }
    
    func didTapAddFriend(with user: User) {
        print(user.name ?? "")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight:CGFloat = 50+8+8
        return CGSize(width: view.frame.width, height: cellHeight)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUser = searchText.isEmpty ? users : users.filter({ (user) -> Bool in
            return user.name!.lowercased().contains(searchText.lowercased())
        })
        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userSearchBar.isHidden = true
        userSearchBar.resignFirstResponder()
        let selectedUser = filteredUser[indexPath.item]
        let userProfileVC = UserProfileController(collectionViewLayout:UICollectionViewFlowLayout())
        userProfileVC.userUid = selectedUser.id
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userSearchBar.isHidden = false
    }
}
