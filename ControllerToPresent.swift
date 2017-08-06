//
//  ControllerToPresent.swift
//  animator bug
//
//  Created by Valerii Lider on 8/6/17.
//  Copyright © 2017 Valerii Lider. All rights reserved.
//

import UIKit

class ControllerToPresent: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBAction func onDismiss(_: UIGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepareForPresentingTransition() {
        view.backgroundColor = .clear
        label.transform = CGAffineTransform(translationX: 0, y: -500)
    }
    
    override func performPresentingTransition() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        label.transform = .identity
    }
    
    override func performDismissingTransition() {
        view.backgroundColor = .clear
        label.transform = CGAffineTransform(translationX: 0, y: -500)
    }
}
