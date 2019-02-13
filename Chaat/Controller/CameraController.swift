//
//  CameraController.swift
//  Intasgram
//
//  Created by Admin on 2019/1/20.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController:UIViewController,AVCapturePhotoCaptureDelegate,UIViewControllerTransitioningDelegate {
    
    let returnArrowButton:UIButton = {
        let bu = UIButton(type: .system)
        bu.setImage(UIImage(named: "right_arrow_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bu.addTarget(self, action: #selector(handleReturnButtonTapped), for: .touchUpInside)
        return bu
    }()
    let capturePhotoButton:UIButton = {
        let bu = UIButton(type: .system)
        bu.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bu.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return bu
    }()
    
    
    @objc func handleReturnButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
        setupAVCaptureSession()
        setupHUD()
    }
    
    fileprivate func setupHUD() {
        view.addSubview(returnArrowButton)
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, topConstant: 0, bottom: view.bottomAnchor, bottonConstant: -24, left: nil, leftConstant: 0, right: nil, rightConstant: 0, widthConstant: 80, heightConstant: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        returnArrowButton.anchor(top: view.topAnchor, topConstant: 12, bottom: nil, bottonConstant: 0, left: nil, leftConstant: 0, right: view.rightAnchor, rightConstant: -12, widthConstant: 50, heightConstant: 50)
    }
    
    let output = AVCapturePhotoOutput()
    @objc func handleCapturePhoto() {
        let capturePhotoSetting = AVCapturePhotoSettings()
        guard let previewFormatType = capturePhotoSetting.availablePreviewPhotoPixelFormatTypes.first else {return }
        capturePhotoSetting.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String:previewFormatType]
        output.capturePhoto(with: capturePhotoSetting, delegate: self)
    }
    
    fileprivate func setupAVCaptureSession() {
        let captureSession = AVCaptureSession()
        //setup input
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print("Could not set up camera input,", error)
        }
        
        //setup output
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        //setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
    }
    
    
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imagedata = photo.fileDataRepresentation() else {return }
        let previewImage = UIImage(data: imagedata)
        
        let previewPhotoContainerView = PreviewPhotoContainerView()
        previewPhotoContainerView.previewPhotoImageView.image = previewImage
        view.addSubview(previewPhotoContainerView)
        previewPhotoContainerView.anchor(top: view.topAnchor, topConstant: 0, bottom: view.bottomAnchor, bottonConstant: 0, left: view.leftAnchor, leftConstant: 0, right: view.rightAnchor, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    let toLeftAnimationPresentor = ToLeftAnimationPresentor()
    let toRightAnimationPresentor = ToRightAnimationPresentor()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return toLeftAnimationPresentor
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return toRightAnimationPresentor
    }
}



