//
//  LNPresentationController.swift
//  LunarPresentationKit
//
//  Created by Rajat Agrawal on 9/7/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit

public class LNPresentationController: UIPresentationController {
    weak public var presentationViewPanGesture : UIPanGestureRecognizer?
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
    
    @objc func handlePanGesture(panGesture : UIPanGestureRecognizer) {
        Swift.print("Presentation pan gesture handler called")
        if (panGesture.state == .changed) {
            guard let containerView = containerView else {
                return
            }
            let translation = abs(panGesture.translation(in: containerView).x)
            let percentage = translation/containerView.bounds.size.width
            Swift.print("Percentage is \(percentage)")
            presentationInteractor?.update(percentage)
        } else if (panGesture.state == .ended) {
            presentationInteractor?.finish()
        }
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        return containerView?.frame ?? .zero
    }

}
