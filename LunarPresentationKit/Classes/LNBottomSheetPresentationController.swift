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
    let heightFactor : CGFloat = 0.5
    let dimmingView = UIView(frame: .zero)
    var dismissalPanGesture : UIPanGestureRecognizer?
    let dismissalAnimator = LNBottomSheetAnimator()

    public override func presentationTransitionWillBegin() {
        initializeTapGesture()
        initializeDimmingView()
        initializeDismissalPanGesture()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] (context) in
            self.dimmingView.alpha = 0.5
            self.presentedViewController.view.layer.cornerRadius = 15
        }, completion: { (context) in
            
        })
    }
    
    override func initializeDismissalPanGesture() {
        let dismissalPanGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissalPanGestureRecognizer(gesture:)))
        presentedViewController.view.addGestureRecognizer(dismissalPanGesture)
        self.dismissalPanGesture = dismissalPanGesture
    }
    
    @objc func dismissalPanGestureRecognizer(gesture : UIPanGestureRecognizer) {
        let translation = gesture.translation(in: containerView).y
        let percentage = translation/frameOfPresentedViewInContainerView.size.height
        DDLogVerbose("dismssal pan gesture translation \(translation), percentage \(percentage)")
        
        if (gesture.state == .began) {
            DDLogDebug("dismissal pan gesture state began")
            let transitioningDelegate = presentedViewController.transitioningDelegate as? LNTransitioningDelegate
            transitioningDelegate?.dismissalAnimator = dismissalAnimator
            dismissalAnimator.isBeingPresented = false
            transitioningDelegate?.needsInteractiveDismissal = true
            presentedViewController.dismiss(animated: true, completion: nil)
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
            self.dimmingView.alpha = 0
            self.presentedViewController.view.layer.cornerRadius = 0
            }, completion: { (context) in
                
        })
    }
    
    func initializeTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureListener(gesture:)))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    func initializeDimmingView() {
        if let containerView = containerView {
            dimmingView.frame = containerView.frame
            dimmingView.backgroundColor = UIColor.black
            dimmingView.alpha = 0
            containerView.addSubview(dimmingView)
        }
    }
    
    @objc func tapGestureListener(gesture : UITapGestureRecognizer) {
        DDLogDebug("dimming view tap gesture listener")
        let transitioningDelegate = presentedViewController.transitioningDelegate as? LNTransitioningDelegate
        transitioningDelegate?.needsInteractiveDismissal = false
        dismissalAnimator.isBeingPresented = false
        transitioningDelegate?.dismissalAnimator = dismissalAnimator
        presentedViewController.dismiss(animated: true, completion: nil)
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
