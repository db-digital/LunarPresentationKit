//
//  ViewController.swift
//  LNPresentationKitTestApp
//
//  Created by Rajat Agrawal on 9/7/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit
import LunarPresentationKit
import CocoaLumberjack

class LNPresentingVC: UIViewController {
    var rightVCTransitioningDelegate = LNTransitioningDelegate()
    let rightPresentedVC = LNRightPresentedViewController()
    let panGesture = UIScreenEdgePanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DDLogDebug("app main view controller loaded")
        addPanGesture()
        view.backgroundColor = .red
        
        rightVCTransitioningDelegate.presentationVCConfigBlock = { [weak self] (presentationVC : LNPresentationController) in
            presentationVC.presentationViewPanGesture = self?.panGesture
        }
        rightPresentedVC.transitioningDelegate = rightVCTransitioningDelegate
        rightPresentedVC.modalPresentationStyle = .custom
        
    }
    
    func addPanGesture() {
        panGesture.edges = .right
        panGesture.addTarget(self, action:#selector(self.handlePan(gesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(gesture : UIScreenEdgePanGestureRecognizer) {
        if (presentedViewController == nil) {
            DDLogDebug("presented view controller is nil")
        }
        
        if (gesture.state == .began && (presentedViewController == nil)) {
            present(rightPresentedVC, animated: true, completion: nil)
        }
    }
}

