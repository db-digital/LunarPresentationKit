//
//  ViewController.swift
//  LNPresentationKitTestApp
//
//  Created by Rajat Agrawal on 9/7/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit
import LunarPresentationKit

class LNPresentingVC: UIViewController {
    var rightVCTransitioningDelegate = LNTransitioningDelegate()
    let rightPresentedVC = LNRightPresentedViewController()
    let panGesture = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addPanGesture()
        print("view controller called")
        view.backgroundColor = .red
        
        rightVCTransitioningDelegate.presentationVCConfigBlock = { [weak self] (presentationVC : LNPresentationController) in
            presentationVC.presentationViewPanGesture = self?.panGesture
        }
//        rightVCTransitioningDelegate.myPresentationController?.presentationViewPanGesture = panGesture
        rightPresentedVC.transitioningDelegate = rightVCTransitioningDelegate
        rightPresentedVC.modalPresentationStyle = .custom
        
    }
    
    func addPanGesture() {
        panGesture.addTarget(self, action:#selector(self.handlePan(gesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(gesture : UIPanGestureRecognizer) {
        print("presnted view controller is \(presentedViewController)")
        if (gesture.state == .began && (presentedViewController == nil)) {
            present(rightPresentedVC, animated: true, completion: nil)
        }
        
//        print("handle pan called \(gesture)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

