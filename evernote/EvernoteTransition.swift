//
//  EvernoteTransition.swift
//  evernote
//
//  Created by 梁树元 on 10/31/15.
//  Copyright © 2015 com. All rights reserved.
//

import UIKit

class EvernoteTransition: NSObject,UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate,NoteViewControllerDelegate {
    internal var isPresent = true
    var selectCell:CollectionViewCell = CollectionViewCell()
    var visibleCells = [CollectionViewCell]()
    var originFrame:CGRect = CGRectZero
    var finalFrame:CGRect = CGRectZero
    var panViewController = UIViewController()
    var listViewController = UIViewController()
    var interactionController = UIPercentDrivenInteractiveTransition()

    func EvernoteTransitionWith(selectCell selectCell:CollectionViewCell, visibleCells:[CollectionViewCell], originFrame:CGRect, finalFrame:CGRect, panViewController:UIViewController, listViewController:UIViewController) {
        self.selectCell = selectCell
        self.visibleCells = visibleCells
        self.originFrame = originFrame
        self.finalFrame = finalFrame
        self.panViewController = panViewController
        self.listViewController = listViewController
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(EvernoteTransition.handlePanGesture(_:)))
        pan.edges = UIRectEdge.Left
        self.panViewController.view.addGestureRecognizer(pan)
    }
    
    // UIViewControllerAnimatedTransitioning
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.45
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let nextVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        transitionContext.containerView()?.backgroundColor = BGColor
        selectCell.frame = isPresent ? originFrame : finalFrame
        let addView = nextVC?.view
        addView!.hidden = isPresent ? true : false
        transitionContext.containerView()?.addSubview(addView!)
        let removeCons = isPresent ? selectCell.labelLeadCons : selectCell.horizonallyCons
        let addCons = isPresent ? selectCell.horizonallyCons : selectCell.labelLeadCons
        selectCell.removeConstraint(removeCons)
        selectCell.addConstraint(addCons)
        UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            for visibleCell:CollectionViewCell in self.visibleCells {
                if visibleCell != self.selectCell {
                    var frame = visibleCell.frame
                    if visibleCell.tag < self.selectCell.tag {
                        let yDistance = self.originFrame.origin.y - self.finalFrame.origin.y + 30
                        let yUpdate = self.isPresent ? yDistance : -yDistance
                        frame.origin.y -= yUpdate
                    }else if visibleCell.tag > self.selectCell.tag{
                        let yDistance = CGRectGetMaxY(self.finalFrame) - CGRectGetMaxY(self.originFrame) + 30
                        let yUpdate = self.isPresent ? yDistance : -yDistance
                        frame.origin.y += yUpdate
                    }
                    visibleCell.frame = frame
                    visibleCell.transform = self.isPresent ? CGAffineTransformMakeScale(0.8, 1.0):CGAffineTransformIdentity
                }
            }
            self.selectCell.backButton.alpha = self.isPresent ? 1.0 : 0.0
            self.selectCell.titleLine.alpha = self.isPresent ? 1.0 : 0.0
            self.selectCell.textView.alpha = self.isPresent ? 1.0 : 0.0
            self.selectCell.frame = self.isPresent ? self.finalFrame : self.originFrame
            self.selectCell.layoutIfNeeded()
            }) { (stop) -> Void in
                addView!.hidden = false
                transitionContext.completeTransition(true)
        }

    }
    
    // UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        selectCell.textView.scrollEnabled = false
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresent = false
        return self
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func handlePanGesture(recognizer:UIScreenEdgePanGestureRecognizer) {
        let view = panViewController.view
        if recognizer.state == UIGestureRecognizerState.Began {
            panViewController.dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        } else if recognizer.state == UIGestureRecognizerState.Changed {
            let translation = recognizer.translationInView(view)
            let d = fabs(translation.x / CGRectGetWidth(view.bounds))
            interactionController.updateInteractiveTransition(d)
        } else if recognizer.state == UIGestureRecognizerState.Ended {
            if recognizer.velocityInView(view).x > 0 {
                finishInteractive()
            } else {
                interactionController.cancelInteractiveTransition()
                listViewController.presentViewController(panViewController, animated: false, completion: { () -> Void in
                    
                })
            }
            interactionController = UIPercentDrivenInteractiveTransition()
        }
    }
    
    // NoteViewControllerDelegate
    func didClickGoBack() {
        panViewController.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
        finishInteractive()
    }
    
    func finishInteractive() {
        interactionController.finishInteractiveTransition()
        selectCell.textView.scrollEnabled = true
    }
    
}
