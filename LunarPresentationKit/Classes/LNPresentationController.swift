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
    public var needsDimmingView = false
    var dimmingView : UIView?
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        initializeDismissalPanGesture()
    }
    
    public override func presentationTransitionWillBegin() {
        initializePresentationPanGesture()
        if (needsDimmingView) {
            initializeDimmingView()
            guard let dimmingView = dimmingView else {
                return
            }
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
                dimmingView.alpha = 0.5
                }, completion: { (context) in
            })
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        DDLogDebug("turning animator mode to dismissal")
        animator?.isBeingPresented = false
        if needsDimmingView, let dimmingView = dimmingView {
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
                dimmingView.alpha = 0
                }, completion: { (context) in
            })
        }   
    }
    
    public func initializePresentationPanGesture() {
        presentationViewPanGesture?.addTarget(self, action: #selector(self.presentationGestureListener(gesture:)))
    }
    
    public func initializeDismissalPanGesture() {
        dismissalViewPanGesture?.addTarget(self, action: #selector(self._dismissalGestureListener(gesture:)))
        dismissalViewPanGesture?.addTarget(self, action: #selector(self.dismissalGestureListener(gesture:)))
        DDLogDebug("presentation controller add target for updating progress for dismissal for pan gesture : \(String(describing: dismissalViewPanGesture))")
    }
    
    @objc func _dismissalGestureListener(gesture : UIGestureRecognizer) {
        DDLogDebug("dismisal pan gesture listener in LNPresentationController")
        if (gesture.state == .began) {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc public func dismissalGestureListener(gesture : UIGestureRecognizer) {
        
    }
    
    @objc public func presentationGestureListener(gesture : UIGestureRecognizer) {
        
    }
    
    func initializeDimmingView() {
        if let containerView = containerView {
            let dimmingView = UIView(frame: .zero)
            dimmingView.frame = containerView.frame
            dimmingView.backgroundColor = UIColor.black
            dimmingView.alpha = 0
            containerView.addSubview(dimmingView)
            self.dimmingView = dimmingView
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dimmingViewTapGestureListener(gesture:)))
            dimmingView.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func dimmingViewTapGestureListener(gesture : UITapGestureRecognizer) {
        DDLogDebug("dimming view tap gesture listener")
        let transitioningDelegate = presentedViewController.transitioningDelegate as? LNTransitioningDelegate
        transitioningDelegate?.needsInteractiveDismissal = false
        animator?.isBeingPresented = false
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
