//
//  LNRightPresentedViewController.swift
//  LunarPresentationKit
//
//  Created by Rajat Agrawal on 9/7/19.
//  Copyright © 2019 Rajat Agrawal. All rights reserved.
//

import UIKit
import LunarPresentationKit
import CocoaLumberjack


class LNRightPresentedViewController: UIViewController {
    let panGesture = UIScreenEdgePanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPanGesture()
        view.backgroundColor = .orange
        if let lnPresentationController = presentationController as? LNPresentationController {
            lnPresentationController.dismissalViewPanGesture = panGesture
        }

        // Do any additional setup after loading the view.
    }
    
    func addPanGesture() {
        panGesture.edges = .left
        panGesture.addTarget(self, action:#selector(self.handlePan(gesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(gesture : UIScreenEdgePanGestureRecognizer) {
        if (gesture.state == .began && (!isBeingDismissed) && !isBeingPresented) {
            DDLogDebug("dismissal pan gesture : Dismissing presented view controller")
            dismiss(animated: true, completion: nil)
        } else {
            DDLogDebug("dismissal pan gesture : Falling through")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
