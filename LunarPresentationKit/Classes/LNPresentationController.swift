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
    weak public var presentationViewPanGesture : UIScreenEdgePanGestureRecognizer?
    weak public var dismissalViewPanGesture : UIScreenEdgePanGestureRecognizer?
    weak public var presentationInteractor : UIPercentDrivenInteractiveTransition?
    weak public var dismissalInteractor : UIPercentDrivenInteractiveTransition?
    
    public override func presentationTransitionWillBegin() {
        initializePresentationPanGesture()
    }
    
    public override func dismissalTransitionWillBegin() {
        initializeDismissalPanGesture()
    }
    
    func initializePresentationPanGesture() {
        presentationViewPanGesture?.addTarget(self, action: #selector(self.handlePanGesture(panGesture:)))
    }
    
    func initializeDismissalPanGesture() {
        DDLogDebug("presentation controller add target for updating progress for dismissal for pan gesture : \(String(describing: dismissalViewPanGesture))")
        dismissalViewPanGesture?.addTarget(self, action: #selector(self.handleDismissalPanGesture(panGesture:)))
    }
    
    @objc public func handleDismissalPanGesture(panGesture : UIScreenEdgePanGestureRecognizer) {
        DDLogVerbose("presentation controller : dismissal pan gesture listener")
        guard let containerView = containerView, let window = containerView.window else {
            DDLogWarn("dismissal container view or window not present")
            return
        }
        let locationInContainer = panGesture.location(in: containerView).x
        let percentage = locationInContainer/window.bounds.size.width
        
        DDLogVerbose("location in container \(locationInContainer) percentage is \(percentage)")
        DDLogVerbose("dismissal pan gesture state is \(panGesture.state.rawValue)")
        if (panGesture.state == .changed) {
            DDLogDebug("Dismissal percentage is \(percentage)")
            dismissalInteractor?.update(percentage)
        } else if (panGesture.state == .ended) {
            if (percentage >= 0.3) {
                DDLogDebug("pan gesture finishing dismissal at percentage \(percentage)")
                dismissalInteractor?.finish()
            } else {
                DDLogDebug("pan gesture cancelling dismissal at percentage \(percentage)")
                dismissalInteractor?.cancel()
            }
        } else {
            DDLogDebug("dismissal pan gesture came in the else with state \(panGesture.state.rawValue)")
        }
    }
    @objc public func handlePanGesture(panGesture : UIScreenEdgePanGestureRecognizer) {
        guard let containerView = containerView, let window = containerView.window else {
            return
        }
        let location = panGesture.location(in: nil).x
        var percentage = location/window.bounds.size.width
        if (panGesture.edges == .right) {
            percentage = 1.0 - percentage
        }
        
        if (panGesture.state == .changed) {
            DDLogDebug("presentation percentage is \(percentage)")
            presentationInteractor?.update(percentage)
        } else if (panGesture.state == .ended) {
            if (percentage >= 0.3) {
                DDLogDebug("pan gesture finishing presentation at percentage \(percentage)")
                presentationInteractor?.finish()
            } else {
                DDLogDebug("pan gesture cancelling presentation at percentage \(percentage)")
                presentationInteractor?.cancel()
            }
        }
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        return containerView?.frame ?? .zero
    }
}
