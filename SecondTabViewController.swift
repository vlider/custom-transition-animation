//
//  SecondTabViewController.swift
//  animator bug
//
//  Created by Valerii Lider on 8/6/17.
//  Copyright © 2017 Valerii Lider. All rights reserved.
//

import UIKit

class SecondTabViewController: UIViewController {

    lazy var transitionAnimator: TransitionAnimator = {
        let animator = TransitionAnimator()
        animator.from = self
        
        return animator
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        transitionAnimator.to = segue.destination
    }
}
