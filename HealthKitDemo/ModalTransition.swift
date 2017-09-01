//
//  ModalTransition.swift
//  WorldTrotter
//
//  Created by Michael Williams on 6/14/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ModalTransition: NSObject, UIViewControllerAnimatedTransitioning {

    
    let animationDuration: TimeInterval = 0.35
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else {
            preconditionFailure("Transition started with missing context info")
        }
        
        container.addSubview(toView)
        toView.transform = toView.transform.translatedBy(x: 0, y: -container.bounds.height)
    
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveLinear, animations: {
            toView.transform = toView.transform.translatedBy(x: 0, y: container.bounds.height)
        }) { (didComplete) in
            transitionContext.completeTransition(true)
        }
    }

}
