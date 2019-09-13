//
//  LNTransitioningDelegate.swift
//  LunarPresentationKit
//
//  Created by Rajat Agrawal on 9/7/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit
import CocoaLumberjack

public class LNTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    weak public var presentationController : LNPresentationController?
    public var presentationVCConfigBlock: ((LNPresentationController) -> Void)?
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DDLogDebug("animation controller for presentation vended")
        return LNPresentationAnimator()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = LNPresentationAnimator()
        animator.isBeingPresented = false
        DDLogDebug("animation controller for dismissal vended")
        return animator
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        let interactor = UIPercentDrivenInteractiveTransition()
        presentationController?.dismissalInteractor = interactor
        DDLogDebug("interaction controller for dismissal vended")
        return interactor
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        let interactor = UIPercentDrivenInteractiveTransition()
        presentationController?.presentationInteractor = interactor
        DDLogDebug("interaction controller for presentation vended")
        return interactor
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = LNPresentationController(presentedViewController: presented, presenting: presenting)
        self.presentationController = presentationController
        presentationVCConfigBlock?(presentationController)
        return presentationController
    }
}
