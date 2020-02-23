//
//  LNBottomSheetPresentationController.swift
//  LunarPresentationKit
//
//  Created by Rajat Agrawal on 9/13/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit
import CocoaLumberjack

public class LNBottomSheetPresentationController: LNPresentationController {
    let heightFactor : CGFloat = 0.7

    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        animator = LNBottomSheetAnimator()
        needsDimmingView = true
    }
    
    public override func presentationTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] (context) in
            self.presentedViewController.view.layer.cornerRadius = 15
            }, completion: { (context) in
        })
        super.presentationTransitionWillBegin()
    }
    
    override public func initializeDismissalPanGesture() {
        let dismissalPanGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissalPanGestureRecognizer(gesture:)))
        presentedViewController.view.addGestureRecognizer(dismissalPanGesture)
        dismissalViewPanGesture = dismissalPanGesture
        super.initializeDismissalPanGesture()
    }
    
    @objc func dismissalPanGestureRecognizer(gesture : UIPanGestureRecognizer) {
        let translation = gesture.translation(in: containerView).y
        let percentage = translation/frameOfPresentedViewInContainerView.size.height
        DDLogVerbose("dismssal pan gesture translation \(translation), percentage \(percentage)")
        
        if (gesture.state == .began) {
            DDLogDebug("dismissal pan gesture state began")
            (presentedViewController.transitioningDelegate as? LNTransitioningDelegate)?.needsInteractiveDismissal = true
        } else if (gesture.state == .changed) {
            dismissalInteractor?.update(percentage)
            DDLogDebug("dismissal pan gesture state changing")
        } else if (gesture.state == .ended) {
            DDLogDebug("dismissal pan gesture state ended")
            if (percentage > 0.1) {
                DDLogDebug("dismissal pan gesture state finish animation")
                dismissalInteractor?.completionCurve = .easeInOut
                dismissalInteractor?.finish()
            } else {
                DDLogDebug("dismissal pan gesture state cancel animation")
                dismissalInteractor?.cancel()
            }
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] (context) in
            self.presentedViewController.view.layer.cornerRadius = 0
            }, completion: { (complete) in   
        })
        super.dismissalTransitionWillBegin()
    }
    
    override public var frameOfPresentedViewInContainerView: CGRect {
        if let containerView = containerView {
            let height = containerView.frame.height * heightFactor
            return CGRect(x: 0, y: (containerView.frame.height - height), width: containerView.frame.width, height: height)
        } else {
            return .zero
        }
    }
}
