/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import QuartzCore

//
// Util delay function
//
func delay(seconds seconds: Double, completion:()->()) {
  let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
  
  dispatch_after(popTime, dispatch_get_main_queue()) {
    completion()
  }
}

class MasterViewController: UIViewController {
  
  let logo = RWLogoLayer.logoLayer()
  let transition = RevealAnimator()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Start"
    
    navigationController?.delegate = self
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    // add the tap gesture recognizer
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
    view.addGestureRecognizer(tap)
    
    // As the user pans across the screen, the recognizer invokes didPan() on your MasterViewController class.
    let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan))
    view.addGestureRecognizer(pan)
    
    // add the logo to the view
    logo.position = CGPoint(x: view.layer.bounds.size.width/2,
      y: view.layer.bounds.size.height/2 - 30)
    logo.fillColor = UIColor.whiteColor().CGColor
    view.layer.addSublayer(logo)
  }
  
  //
  // MARK: Gesture recognizer handler
  //
  func didTap() {
    performSegueWithIdentifier("details", sender: nil)
  }

  func didPan(recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
    case .Began:
        transition.interactive = true
        performSegueWithIdentifier("details", sender: nil)
    default:
        // pass guesture to animator
        transition.handlePan(recognizer)
    }
  }
  
}

extension MasterViewController: UINavigationControllerDelegate {

   func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.operation = operation
        return transition
    }

   func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

    // You only return an interaction controller when you want the transition to be interactive
    if !transition.interactive {
        return nil;
    } else {
        return transition;
    }

  }

  
}
