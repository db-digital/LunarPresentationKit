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
    weak public var presentationInteractor : UIPercentDrivenInteractiveTransition?
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    public override func presentationTransitionWillBegin() {
        initializePanGesture()
    }
    
    func initializePanGesture() {
        if let presentationViewPanGesture = presentationViewPanGesture {
            presentationViewPanGesture.addTarget(self, action: #selector(self.handlePanGesture(panGesture:)))
        }
    }
    
    @objc func handlePanGesture(panGesture : UIScreenEdgePanGestureRecognizer) {
        guard let containerView = containerView, let window = containerView.window else {
            return
        }
        let location = panGesture.location(in: nil).x
        var percentage = location/window.bounds.size.width
        if (panGesture.edges == .right) {
            percentage = 1.0 - percentage
        }
        DDLogDebug("percentage is \(percentage)")
        if (panGesture.state == .changed) {
            presentationInteractor?.update(percentage)
        } else if (panGesture.state == .ended) {
            if (percentage >= 0.3) {
                presentationInteractor?.finish()
            } else {
                presentationInteractor?.cancel()
            }
        }
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        return containerView?.frame ?? .zero
    }
}
