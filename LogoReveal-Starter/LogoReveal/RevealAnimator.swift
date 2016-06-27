//
//  RevealAnimator.swift
//  LogoReveal
//
//  Created by Marin Todorov on 1/15/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

// use one of Apple’s built-in interactive animator classes: UIPercentDrivenInteractiveTransition. This class conforms to UIViewControllerInteractiveTransitioning
class RevealAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {

  // tell the animator whether or not it should drive the transition in an interactive fashion
  var interactive = false
  let animationDuration = 2.0
  var operation: UINavigationControllerOperation = .Push

  weak var storedContext: UIViewControllerContextTransitioning?

  // you’ll pass the recognizer to handlePan() in RevealAnimator, at which point you’ll update the current progress of the transition
  func handlePan(recognizer: UIPanGestureRecognizer) {
    // the translation lets you know how many points the user moved their finger on both the X and Y axes
    let translation = recognizer.translationInView(recognizer.view!.superview!)
    // You shouldn’t care whether the user pans to the right or to the left – that’s why you use abs()
    var progress: CGFloat = abs(translation.x / 200.0)
    // you cap the progress variable between 0.01 and 0.99;
    progress = min(max(progress, 0.01), 0.99)

    switch recognizer.state {
        case .Changed:
            updateInteractiveTransition(progress)
        case .Cancelled, .Ended:
            // Setting the time and speed is a workaround for what seems like a UIKit bug; if you don’t use layer animations in the transition, you don’t have to set the layer’s begin time and the completion speed
            let transitionLayer = storedContext!.containerView()!.layer
            transitionLayer.beginTime = CACurrentMediaTime()
            if progress < 0.5 {
                completionSpeed = -1.0
                // an inherited method – to animate the transition back to its initial state.
                cancelInteractiveTransition()
            } else {
                completionSpeed = 1.0
                // an inherited method – to animate the transition to its finish state.
                finishInteractiveTransition()
            }
            interactive = false
        default:
            break
    }
}
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return animationDuration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    storedContext = transitionContext
    
    if operation == .Push {
      
      let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MasterViewController
      let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! DetailViewController
      
      transitionContext.containerView()?.addSubview(toVC.view)

      let animation = CABasicAnimation(keyPath: "transform")
      
      animation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
      animation.toValue = NSValue(CATransform3D:
        CATransform3DConcat(
          CATransform3DMakeTranslation(0.0, -10.0, 0.0),
          CATransform3DMakeScale(150.0, 150.0, 1.0)
        )
      )

      animation.duration = animationDuration
      animation.delegate = self
      animation.fillMode = kCAFillModeForwards
      animation.removedOnCompletion = false
      animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

      toVC.maskLayer.addAnimation(animation, forKey: nil)
      fromVC.logo.addAnimation(animation, forKey: nil)
      
      let fadeIn = CABasicAnimation(keyPath: "opacity")
      fadeIn.fromValue = 0.0
      fadeIn.toValue = 1.0
      fadeIn.duration = animationDuration
      toVC.view.layer.addAnimation(fadeIn, forKey: nil)
    } else {
      
      let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
      let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
      
      transitionContext.containerView()?.insertSubview(toView, belowSubview: fromView)
      
      UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveEaseIn, animations: {
        fromView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        }, completion: {_ in
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
      })
      
    }
  }

  override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
      
      if let context = storedContext {
        context.completeTransition(!context.transitionWasCancelled())
        
        //reset logo
        let fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MasterViewController
        fromVC.logo.removeAllAnimations()
      }
      
      storedContext = nil
  }
  
}
