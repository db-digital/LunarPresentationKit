//
//  LNBottomSheetAnimator.swift
//  LunarPresentationKit
//
//  Created by Rajat Agrawal on 9/14/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit

public class LNBottomSheetAnimator: LNAnimator {
    
    public override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if (isBeingPresented) {
            guard let toVC = transitionContext.viewController(forKey: .to), let toView = transitionContext.view(forKey: .to) else {
                return
            }
            let containerView = transitionContext.containerView
            containerView.addSubview(toView)
            let initialFrame = containerView.frame.offsetBy(dx: 0, dy: containerView.bounds.size.height)
            toView.frame = initialFrame
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .beginFromCurrentState, animations: {
                toView.frame = transitionContext.finalFrame(for: toVC)
            }) { (complete) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            guard let fromView = transitionContext.view(forKey: .from) else {
                return
            }
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .beginFromCurrentState, animations: {
                let containerView = transitionContext.containerView
                fromView.frame = containerView.frame.offsetBy(dx: 0, dy: containerView.frame.size.height)
            }) { (complete) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
    public func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 1.0) {
            self.animateTransition(using: transitionContext)
        }
    }
}
