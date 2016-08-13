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
    var originFrame:CGRect = CGRect.zero
    var finalFrame:CGRect = CGRect.zero
    var panViewController = UIViewController()
    var listViewController = UIViewController()
    var interactionController = UIPercentDrivenInteractiveTransition()

    func EvernoteTransitionWith(selectCell:CollectionViewCell, visibleCells:[CollectionViewCell], originFrame:CGRect, finalFrame:CGRect, panViewController:UIViewController, listViewController:UIViewController) {
        self.selectCell = selectCell
        self.visibleCells = visibleCells
        self.originFrame = originFrame
        self.finalFrame = finalFrame
        self.panViewController = panViewController
        self.listViewController = listViewController
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(EvernoteTransition.handlePanGesture(_:)))
        pan.edges = UIRectEdge.left
        self.panViewController.view.addGestureRecognizer(pan)
    }
    
    // UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.45
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let nextVC = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey)
        transitionContext.containerView.backgroundColor = BGColor
        selectCell.frame = isPresent ? originFrame : finalFrame
        let addView = nextVC?.view
        addView!.isHidden = isPresent ? true : false
        transitionContext.containerView.addSubview(addView!)
        let removeCons = isPresent ? selectCell.labelLeadCons : selectCell.horizonallyCons
        let addCons = isPresent ? selectCell.horizonallyCons : selectCell.labelLeadCons
        selectCell.removeConstraint(removeCons!)
        selectCell.addConstraint(addCons!)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            for visibleCell:CollectionViewCell in self.visibleCells {
                if visibleCell != self.selectCell {
                    var frame = visibleCell.frame
                    if visibleCell.tag < self.selectCell.tag {
                        let yDistance = self.originFrame.origin.y - self.finalFrame.origin.y + 30
                        let yUpdate = self.isPresent ? yDistance : -yDistance
                        frame.origin.y -= yUpdate
                    }else if visibleCell.tag > self.selectCell.tag{
                        let yDistance = self.finalFrame.maxY - self.originFrame.maxY + 30
                        let yUpdate = self.isPresent ? yDistance : -yDistance
                        frame.origin.y += yUpdate
                    }
                    visibleCell.frame = frame
                    visibleCell.transform = self.isPresent ? CGAffineTransform(scaleX: 0.8, y: 1.0):CGAffineTransform.identity
                }
            }
            self.selectCell.backButton.alpha = self.isPresent ? 1.0 : 0.0
            self.selectCell.titleLine.alpha = self.isPresent ? 1.0 : 0.0
            self.selectCell.textView.alpha = self.isPresent ? 1.0 : 0.0
            self.selectCell.frame = self.isPresent ? self.finalFrame : self.originFrame
            self.selectCell.layoutIfNeeded()
            }) { (stop) -> Void in
                addView!.isHidden = false
                transitionContext.completeTransition(true)
        }

    }
    
    // UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        selectCell.textView.isScrollEnabled = false
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresent = false
        return self
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func handlePanGesture(_ recognizer:UIScreenEdgePanGestureRecognizer) {
        let view = panViewController.view
        if recognizer.state == UIGestureRecognizerState.began {
            panViewController.dismiss(animated: true, completion: { () -> Void in
            })
        } else if recognizer.state == UIGestureRecognizerState.changed {
            let translation = recognizer.translation(in: view)
            let d = fabs(translation.x / (view?.bounds.width)!)
            interactionController.update(d)
        } else if recognizer.state == UIGestureRecognizerState.ended {
            if recognizer.velocity(in: view).x > 0 {
                finishInteractive()
            } else {
                interactionController.cancel()
                listViewController.present(panViewController, animated: false, completion: { () -> Void in
                    
                })
            }
            interactionController = UIPercentDrivenInteractiveTransition()
        }
    }
    
    // NoteViewControllerDelegate
    func didClickGoBack() {
        panViewController.dismiss(animated: true, completion: { () -> Void in
        })
        finishInteractive()
    }
    
    func finishInteractive() {
        interactionController.finish()
        selectCell.textView.isScrollEnabled = true
    }
    
}
