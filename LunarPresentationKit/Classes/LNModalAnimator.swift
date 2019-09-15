//
//  LNModalAnimator.swift
//  LunarPresentationKit
//
//  Created by Rajat Agrawal on 9/15/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit

public class LNModalAnimator: LNAnimator {
    override public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if (isBeingPresented) {
            guard let toVC = transitionContext.viewController(forKey: .to), let toView = transitionContext.view(forKey: .to) else {
                return
            }
            
            transitionContext.containerView.addSubview(toView)
            toView.frame = transitionContext.finalFrame(for: toVC)
            toView.alpha = 0
            toView.transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 4.0, initialSpringVelocity: 5, options: .beginFromCurrentState, animations: {
                toView.transform = CGAffineTransform.identity
                toView.layer.cornerRadius = 10
                toView.alpha = 1
                toView.layer.masksToBounds = true
            }) { (complete) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            guard let fromView = transitionContext.view(forKey: .from) else {
                return
            }
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .beginFromCurrentState, animations: {
                fromView.transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
                fromView.layer.cornerRadius = 0
                fromView.alpha = 0
            }) { (complete) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        
    }
    
    override public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
}
