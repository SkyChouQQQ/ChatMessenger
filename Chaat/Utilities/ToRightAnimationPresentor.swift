//
//  ToRightAnimationPresentor.swift
//  Intasgram
//
//  Created by Admin on 2019/1/21.
//  Copyright © 2019 Sky. All rights reserved.
//

import UIKit

class ToRightAnimationPresentor:NSObject,UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to) else {return }
        guard let fromView = transitionContext.view(forKey: .from) else {return }
        let strartFrame = CGRect(x: toView.frame.width
            , y: 0, width: toView.frame.width, height: toView.frame.height)
        containerView.addSubview(toView)
        toView.frame = strartFrame
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
        
    }
}
