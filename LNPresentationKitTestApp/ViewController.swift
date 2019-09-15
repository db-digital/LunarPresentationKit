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
    let customTransitioningDelegate = LNTransitioningDelegate()
    var bottomSheetPresentationController : LNBottomSheetPresentationController?
    let rightPresentedVC = LNRightPresentedViewController()
    let sideSheetPresentationPanGesture = UIScreenEdgePanGestureRecognizer()
    var sideSheetPresentationController : LNPresentationController?
    let bottomSheeetButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DDLogDebug("app main view controller loaded")
        view.backgroundColor = .red
        
        setupSideSheetPresentation()
        initializeBottomSheetButton()
    }
    
    func setupSideSheetPresentation() {
        addPanGesture()
        rightPresentedVC.transitioningDelegate = customTransitioningDelegate
        sideSheetPresentationController = LNSideSheetPresentationController(presentedViewController: rightPresentedVC, presenting: self)
        sideSheetPresentationController?.presentationViewPanGesture = sideSheetPresentationPanGesture
        customTransitioningDelegate.presentationController = sideSheetPresentationController
        rightPresentedVC.modalPresentationStyle = .custom
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
        bottomSheetVC.transitioningDelegate = customTransitioningDelegate
        setupTransitioningDelegateForBotttomSheetPresentation(presentedVC :bottomSheetVC, delegate: customTransitioningDelegate)
        present(bottomSheetVC, animated: true, completion: nil)
    }
    
    func addPanGesture() {
        sideSheetPresentationPanGesture.edges = .right
        sideSheetPresentationPanGesture.addTarget(self, action:#selector(self.handlePan(gesture:)))
        view.addGestureRecognizer(sideSheetPresentationPanGesture)
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
        delegate.presentationController = bottomSheetPresentationController
        delegate.needsInteractivePresentation = false
    }
}

