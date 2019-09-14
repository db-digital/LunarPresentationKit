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
    weak public var presentationAnimator : LNAnimator?
    weak public var dismissalAnimator : LNAnimator?
    public var needsInteractivePresentation = true
    public var needsInteractiveDismissal = true
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DDLogDebug("animation controller for presentation vended \(String(describing: presentationAnimator))")
        return presentationAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DDLogDebug("animation controller for dismissal vended \(String(describing: dismissalAnimator))")
        return dismissalAnimator
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if (needsInteractiveDismissal) {
            let interactor = UIPercentDrivenInteractiveTransition()
            presentationController?.dismissalInteractor = interactor
            DDLogDebug("interaction controller for dismissal vended")
            return interactor
        } else {
            DDLogDebug("nil interaction controller for dismissal vended")
            return nil
        }
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if (needsInteractivePresentation) {
            let interactor = UIPercentDrivenInteractiveTransition()
            presentationController?.presentationInteractor = interactor
            DDLogDebug("interaction controller for presentation vended")
            return interactor
        } else {
            DDLogDebug("nil interaction controller for presentation vended")
            return nil
        }
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self.presentationController
    }
}
