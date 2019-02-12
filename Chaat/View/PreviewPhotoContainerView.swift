//
//  PreviewPhotoContainerView.swift
//  Intasgram
//
//  Created by Admin on 2019/1/20.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView:UIView {
    let cancelButton:UIButton = {
        let bu = UIButton(type: .system)
        bu.setImage(UIImage(named:"cancel_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bu.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return bu
    }()
    
    let savePhotoButton:UIButton = {
        let bu = UIButton(type: .system)
        bu.setImage(UIImage(named:"save_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bu.addTarget(self, action: #selector(handleSavePhoto), for: .touchUpInside)
        return bu
    }()
    
    @objc func handleSavePhoto() {
        guard let image = previewPhotoImageView.image else {return }
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if let error = error {
                print("Fail to save captured photo to device", error)
            }
            print("Successfully save photo to device")
            DispatchQueue.main.async {
                let savedSucessfullyLabel = UILabel()
                savedSucessfullyLabel.text = "Saved Successfully"
                savedSucessfullyLabel.textColor = .white
                savedSucessfullyLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                savedSucessfullyLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedSucessfullyLabel.numberOfLines = 0
                savedSucessfullyLabel.textAlignment = .center
                savedSucessfullyLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                savedSucessfullyLabel.center = self.center
                self.addSubview(savedSucessfullyLabel)
                
                savedSucessfullyLabel.popupWithAnimation()
            }
            
        }
    }
    @objc func handleCancel() {
        self.removeFromSuperview()
    }
    
    let previewPhotoImageView:UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        addSubview(previewPhotoImageView)
        previewPhotoImageView.anchor(top: topAnchor, topConstant: 0, bottom: bottomAnchor, bottonConstant: 0, left: leftAnchor, leftConstant: 0, right: rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        addSubview(cancelButton)
        addSubview(savePhotoButton)
        
        cancelButton.anchor(top: topAnchor, topConstant: 12, bottom: nil, bottonConstant: 0, left: leftAnchor, leftConstant: 12, right: nil, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
        savePhotoButton.anchor(top: nil, topConstant: 0, bottom: bottomAnchor, bottonConstant: -12, left: leftAnchor, leftConstant: 12, right: nil, rightConstant: 0, widthConstant: 50, heightConstant: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
