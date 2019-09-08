//
//  LNPresentationAnimator.swift
//  LunarPresentationKit
//
//  Created by Rajat Agrawal on 9/7/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit

class LNPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        Swift.print("animated transitioning function called")
        guard let toVC = transitionContext.viewController(forKey: .to), let toView = transitionContext.view(forKey: .to) else {
            return
        }
        transitionContext.containerView.addSubview(toView)
        let finalFrame = transitionContext.finalFrame(for: toVC)
        toView.frame = finalFrame.offsetBy(dx: transitionContext.containerView.frame.size.width, dy: 0)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0,
                       options: .beginFromCurrentState,
                       animations: {
            toView.frame = finalFrame
        }) { (success) in
            transitionContext.completeTransition(success)
        };
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 1.0, animations: { 
            self.animateTransition(using: transitionContext)
        })
    }

}
