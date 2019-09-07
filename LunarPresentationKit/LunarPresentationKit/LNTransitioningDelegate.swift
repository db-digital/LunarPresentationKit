//
//  LNTransitioningDelegate.swift
//  LunarPresentationKit
//
//  Created by Rajat Agrawal on 9/7/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit

class LNTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    weak var presentationController : LNPresentationController?
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = LNPresentationController(presentedViewController: presented, presenting: presenting)
        self.presentationController = presentationController
        return presentationController
    }
}
