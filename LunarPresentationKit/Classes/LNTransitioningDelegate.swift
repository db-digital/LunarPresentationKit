//
//  LNTransitioningDelegate.swift
//  LunarPresentationKit
//
//  Created by Rajat Agrawal on 9/7/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit

public class LNTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    weak public var presentationController : LNPresentationController?
    public var presentationVCConfigBlock: ((LNPresentationController) -> Void)?
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LNPresentationAnimator()
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        let interactor = UIPercentDrivenInteractiveTransition()
        presentationController?.presentationInteractor = interactor
        return interactor
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = LNPresentationController(presentedViewController: presented, presenting: presenting)
        self.presentationController = presentationController
        presentationVCConfigBlock?(presentationController)
        return presentationController
    }
}
