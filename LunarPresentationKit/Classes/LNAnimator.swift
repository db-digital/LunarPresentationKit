//
//  LNAnimator.swift
//  LunarPresentationKit
//
//  Created by Rajat Agrawal on 9/14/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit

public class LNAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public var isBeingPresented = true
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    }
    
    
}
