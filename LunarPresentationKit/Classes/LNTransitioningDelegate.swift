//
//  LNTransitioningDelegate.swift
//  LunarPresentationKit
//
//  Created by Rajat Agrawal on 9/7/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit

public class LNTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    weak public var myPresentationController : LNPresentationController?
    public var presentationVCConfigBlock: ((LNPresentationController) -> Void)?
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LNPresentationAnimator()
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return UIPercentDrivenInteractiveTransition()
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = LNPresentationController(presentedViewController: presented, presenting: presenting)
        self.myPresentationController = presentationController
        presentationVCConfigBlock?(presentationController)
        return presentationController
    }
}
