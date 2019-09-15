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
    let rightVCTransitioningDelegate = LNTransitioningDelegate()
    var bottomSheetPresentationController : LNBottomSheetPresentationController?
    var sideSheetPresentationController : LNPresentationController?
    let bottomSheetTransitioningDelegate = LNTransitioningDelegate()
    let rightPresentedVC = LNRightPresentedViewController()
    let panGesture = UIScreenEdgePanGestureRecognizer()
    let bottomSheeetButton = UIButton(type: .system)
    let bottomSheetPresentationAnimator = LNBottomSheetAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DDLogDebug("app main view controller loaded")
        addPanGesture()
        view.backgroundColor = .red
        
        rightPresentedVC.transitioningDelegate = rightVCTransitioningDelegate
        sideSheetPresentationController = LNSideSheetPresentationController(presentedViewController: rightPresentedVC, presenting: self)
        sideSheetPresentationController?.presentationViewPanGesture = panGesture
        rightVCTransitioningDelegate.presentationController = sideSheetPresentationController
        rightPresentedVC.modalPresentationStyle = .custom
        initializeBottomSheetButton()
    }
    
    func initializeBottomSheetButton() {
        view.addSubview(bottomSheeetButton)
        bottomSheeetButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            bottomSheeetButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        } else {
            // Fallback on earlier versions
            bottomSheeetButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        }
        
        bottomSheeetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        bottomSheeetButton.setTitle("BottomSheet", for: .normal)
        bottomSheeetButton.addTarget(self, action: #selector(self.bottomSheetButtonAction(sender:)), for: .touchUpInside)
    }
    
    @objc func bottomSheetButtonAction(sender : UIButton) {
        DDLogVerbose("Bottom sheet action button pressed")
        let bottomSheetVC = LNBottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .custom
        bottomSheetVC.transitioningDelegate = bottomSheetTransitioningDelegate
        setupTransitioningDelegateForBotttomSheetPresentation(presentedVC :bottomSheetVC, delegate: bottomSheetTransitioningDelegate)
        present(bottomSheetVC, animated: true, completion: nil)
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
    
    func setupTransitioningDelegateForBotttomSheetPresentation(presentedVC : UIViewController, delegate : LNTransitioningDelegate) {
        bottomSheetPresentationController = LNBottomSheetPresentationController(presentedViewController: presentedVC, presenting: self)
        delegate.presentationAnimator = bottomSheetPresentationAnimator
        delegate.presentationController = bottomSheetPresentationController
        delegate.needsInteractivePresentation = false
    }
}

