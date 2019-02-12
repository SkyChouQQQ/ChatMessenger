//
//  PhotoSelectorController.swift
//  Intasgram
//
//  Created by Admin on 2019/1/14.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController:UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    let photoCellId = "photoCellId"
    let photoHeaderId = "photoHeaderId"
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage:UIImage?
    var photoSelectorHeader:PhotoSelectorHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        collectionView?.backgroundColor = .white
        
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: photoCellId)
        collectionView?.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: photoHeaderId)
        
        fetchPhotos()
    }
    
    fileprivate func setUpNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: photoHeaderId, for: indexPath) as! PhotoSelectorHeader
        
        self.photoSelectorHeader = header
        let imageManager = PHImageManager.default()
        guard let selectedImage = self.selectedImage else {return header}
        guard let indexOfSelectedImage = self.images.index(of:selectedImage) else {return header}
        let selectedAsset = self.assets[indexOfSelectedImage]
        let targetSize = CGSize(width: 600, height: 600)
        imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .aspectFit, options: nil) { (image, info) in
            header.photoImageView.image = image
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellId, for: indexPath) as! PhotoSelectorCell
        
        cell.photoImageView.image = images[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.item]
        self.collectionView?.reloadData()
        let indexPathToBeScrollTo = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPathToBeScrollTo, at: .bottom, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-3)/4
        return CGSize(width: width, height: width)
    }
    
    @objc func handleNext() {
        let sharePhotoVC = SharePhotoController()
        sharePhotoVC.photoImage = self.photoSelectorHeader?.photoImageView.image
        navigationController?.pushViewController(sharePhotoVC, animated: true)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func getAssetfetchOptions()->PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    fileprivate func fetchPhotos() {
        
        let allPhotos = PHAsset.fetchAssets(with:.image, options: getAssetfetchOptions())
        
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    guard let image = image else {return }
                    
                    self.images.append(image)
                    self.assets.append(asset)
                    if self.selectedImage == nil {
                        self.selectedImage = image
                    }
                    
                    if count == allPhotos.count-1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                        
                    }
                    
                })
                
            }
        }
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

