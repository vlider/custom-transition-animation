//
//  TransitionAnimator.swift
//  TransitionAnimator
//
//  Created by Valerii Lider on 4/14/17.
//  Copyright © 2017 Valerii Lider. All rights reserved.
//

import Foundation

class TransitionAnimator: UIPercentDrivenInteractiveTransition {
    
    weak var from: UIViewController!
    
    weak var to: UIViewController! {
        didSet {
            to.transitioningDelegate = self
            to.modalPresentationStyle = .overCurrentContext
        }
    }
    
    fileprivate(set) var isPresenting: Bool = false
}

protocol TransitionSupport: class {
    func prepareForPresentingTransition()
    func performPresentingTransition()
    func performDismissingTransition()
}








import UIKit

// Default implementation
//
extension UIViewController: TransitionSupport {
    func supportInteractiveDismissingTransition() -> Bool {
        if let nav = self as? UINavigationController {
            return nav.viewControllers.first!.supportInteractiveDismissingTransition()
        }
        return false
    }
    
    func prepareForPresentingTransition() {
        view.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
    }
    
    func performPresentingTransition() {
        view.transform = .identity
    }
    
    func performDismissingTransition() {
        view.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
    }
}

extension TransitionAnimator: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}

extension TransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        
        let from = transitionContext.viewController(forKey: .from)!
        let to = transitionContext.viewController(forKey: .to)!
        
        let bottom: UIViewController! = isPresenting ? from : to
        let top: UIViewController! = isPresenting ? to: from
        
        if isPresenting {
            // ask `top` viewController to prepare for being presened
            top.prepareForPresentingTransition()
        }
        
        container.addSubview(bottom.view)
        container.addSubview(top.view)
        
        let duration = transitionDuration(using: transitionContext)
        let options: UIViewAnimationOptions = [.allowAnimatedContent, .allowUserInteraction]
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: options, animations: {
            
            if self.isPresenting {
                // ask `top` viewController to animate presentation
                top.performPresentingTransition()
            } else {
                // ask `top` viewController to animate dismissing
                top.performDismissingTransition()
            }
        }, completion: { finished in
            
            // tell our transitionContext object that we've finished animating
            if (transitionContext.transitionWasCancelled) {
                transitionContext.completeTransition(false)
                // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                UIApplication.shared.keyWindow?.addSubview(from.view)
            } else {
                transitionContext.completeTransition(true)
                // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                UIApplication.shared.keyWindow?.addSubview(to.view)
            }
        })
    }
}
