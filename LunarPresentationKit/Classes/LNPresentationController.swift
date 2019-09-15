//
//  LNPresentationController.swift
//  LunarPresentationKit
//
//  Created by Rajat Agrawal on 9/7/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit
import CocoaLumberjack

public class LNPresentationController: UIPresentationController {
    weak public var presentationViewPanGesture : UIGestureRecognizer?
    public var dismissalViewPanGesture : UIGestureRecognizer?
    weak public var presentationInteractor : UIPercentDrivenInteractiveTransition?
    weak public var dismissalInteractor : UIPercentDrivenInteractiveTransition?
    public var animator : LNAnimator?
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        initializeDismissalPanGesture()
    }
    
    public override func presentationTransitionWillBegin() {
        initializePresentationPanGesture()
    }
    
    public override func dismissalTransitionWillBegin() {
        DDLogDebug("turning animator mode to dismissal")
        animator?.isBeingPresented = false
    }
    
    public func initializePresentationPanGesture() {
        presentationViewPanGesture?.addTarget(self, action: #selector(self.presentationPanGestureListener(panGesture:)))
    }
    
    public func initializeDismissalPanGesture() {
        dismissalViewPanGesture?.addTarget(self, action: #selector(self.dismissalPanGestureListener(panGesture:)))
        DDLogDebug("presentation controller add target for updating progress for dismissal for pan gesture : \(String(describing: dismissalViewPanGesture))")
    }
    
    @objc public func dismissalPanGestureListener(panGesture : UIScreenEdgePanGestureRecognizer) {
        DDLogDebug("dismisal pan gesture listener in LNPresentationController")
    }
    
    @objc public func presentationPanGestureListener(panGesture : UIScreenEdgePanGestureRecognizer) {
        
    }
}
