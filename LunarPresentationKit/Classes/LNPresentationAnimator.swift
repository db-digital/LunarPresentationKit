//
//  LNPresentationAnimator.swift
//  LunarPresentationKit
//
//  Created by Rajat Agrawal on 9/7/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit
import CocoaLumberjack

class LNPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var propertyAnimator : UIViewPropertyAnimator?
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        DDLogDebug("animated transitioning function called")
        guard let toVC = transitionContext.viewController(forKey: .to), let toView = transitionContext.view(forKey: .to) else {
            return
        }
        transitionContext.containerView.addSubview(toView)
        let finalFrame = transitionContext.finalFrame(for: toVC)
        DDLogDebug("final frame for to vc is \(finalFrame)")
        toView.frame = finalFrame.offsetBy(dx: transitionContext.containerView.frame.size.width, dy: 0)
        DDLogDebug("initial frame for to vc is \(toView.frame)")
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0,
                       options: .beginFromCurrentState,
                       animations: {
            toView.frame = finalFrame
        }) { (success) in
            DDLogDebug("success during animation is \(success)")
            DDLogDebug("transition cancelled is \(transitionContext.transitionWasCancelled)")
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        };
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        DDLogDebug("interruptible animator method called")
        if let propertyAnimator = propertyAnimator {
            return propertyAnimator
        }
        guard let toVC = transitionContext.viewController(forKey: .to), let toView = transitionContext.view(forKey: .to) else {
            return UIViewPropertyAnimator(duration: 0, dampingRatio: 0, animations: nil)
        }
        transitionContext.containerView.addSubview(toView)
        let finalFrame = transitionContext.finalFrame(for: toVC)
        DDLogDebug("final frame for to vc is \(finalFrame)")
        toView.frame = finalFrame.offsetBy(dx: transitionContext.containerView.frame.size.width, dy: 0)
        DDLogDebug("initial frame for to vc is \(toView.frame)")

        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext),
                                              dampingRatio: 1.0,
                                              animations: {
            toView.frame = finalFrame
        })
        animator.addCompletion { (position) in
            transitionContext.completeTransition(!(transitionContext.transitionWasCancelled))
        }
        propertyAnimator = animator
        return animator
    }
}
