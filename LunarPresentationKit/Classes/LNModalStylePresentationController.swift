//
//  LNModalStylePresentationController.swift
//  LunarPresentationKit
//
//  Created by Rajat Agrawal on 9/15/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit

public class LNModalStylePresentationController: LNPresentationController {
    
    override public init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        animator = LNModalAnimator()
        needsDimmingView = true
    }
    
    override public var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return .zero
        }
        
        let height = containerView.frame.height
        let width = containerView.frame.width
        
        return containerView.frame.insetBy(dx: width * 0.10, dy: height * 0.25)
    }

}
