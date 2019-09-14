//
//  LNSideSheetAnimator.swift
//  LunarPresentationKit
//
//  Created by Rajat Agrawal on 9/7/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit
import CocoaLumberjack

public class LNSideSheetAnimator: LNAnimator {
    var propertyAnimator : UIViewPropertyAnimator?
    
    public override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if (self.isBeingPresented) {
            DDLogDebug("animated transitioning function called for presentation")
            presentationSetup(using: transitionContext)
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                           delay: 0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0,
                           options: .beginFromCurrentState,
                           animations: {
                            self.presentationAnimation(using: transitionContext)
            }) { (success) in
                DDLogDebug("success during animation is \(success)")
                DDLogDebug("transition cancelled is \(transitionContext.transitionWasCancelled)")
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            };
        } else {
            DDLogDebug("animated transitioning function called for dismissal")
            guard let fromVC = transitionContext.viewController(forKey: .from), let fromView = transitionContext.view(forKey: .from) else {
                return
            }
            let finalFrame = transitionContext.finalFrame(for: fromVC).offsetBy(dx: transitionContext.containerView.frame.size.width, dy: 0)
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                           delay: 0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0,
                           options: .beginFromCurrentState,
                           animations: {
                            fromView.frame = finalFrame
            }) { (success) in
                DDLogDebug("success during animation is \(success)")
                DDLogDebug("transition cancelled is \(transitionContext.transitionWasCancelled)")
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            };
        }
    }
    
    public func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if (isBeingPresented) {
            DDLogDebug("interruptible animator method called for presentation")
            presentationSetup(using: transitionContext)
            let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 1.0, animations: {
                let toView = transitionContext.view(forKey: .to)
                toView?.backgroundColor = .cyan
                self.presentationAnimation(using: transitionContext)
            })
            animator.addCompletion { (position) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            return animator
        } else {
            DDLogDebug("interruptible animator method called for dismissal")
            return UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 1.0, animations: {
                self.animateTransition(using: transitionContext)
            })
        }
    }
    
    func presentationSetup(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) , let toView = transitionContext.view(forKey: .to) else {
            return
        }
        transitionContext.containerView.addSubview(toView)
        let finalFrame = transitionContext.finalFrame(for: toVC)
        DDLogDebug("final frame for to vc is \(finalFrame)")
        toView.frame = finalFrame.offsetBy(dx: transitionContext.containerView.frame.size.width, dy: 0)
    }
    
    func presentationAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to), let toView = transitionContext.view(forKey: .to) else {
            return
        }
        let finalFrame = transitionContext.finalFrame(for: toVC)
        toView.frame = finalFrame
    }
}
