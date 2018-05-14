//
//  ZoomTransitionDelegate.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/13.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

protocol ZoomingViewController {
    func zoomingImageView()-> UIImageView?
}

enum TransitionState {
    case initial
    case final
}

class ZoomTransitionDelegate: NSObject {
    var transitionTime = 0.8
    var damping: CGFloat = 0.6
    var operation: UINavigationControllerOperation = .none
    private let zoomScale = CGFloat(15)
    private let backgroundScale = CGFloat(0.8)

    func configureView(for state: TransitionState, container: UIView, backgroundViewController: UIViewController, backgroundImageView: UIImageView, foregroundViewController: UIViewController, foregroundImageView: UIImageView, snapShotView: UIImageView) {
        switch state {
        case .initial:
            backgroundViewController.view.transform = .identity
            backgroundViewController.view.alpha = 1
            snapShotView.frame = container.convert(backgroundImageView.frame, from: backgroundImageView.superview)
        case .final:
            backgroundViewController.view.transform = CGAffineTransform(scaleX: backgroundScale, y: backgroundScale)
            backgroundViewController.view.alpha = 0
            snapShotView.frame = container.convert(foregroundImageView.frame, from: foregroundImageView.superview)
        }
    }
}

extension ZoomTransitionDelegate: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionTime
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView

        guard let toViewControllerExist = toViewController,
            let fromViewControllerExist = fromViewController else {return}
        
        var backgroundViewController = fromViewControllerExist
        var foregroundViewController = toViewControllerExist
        
        if operation == .pop {
            backgroundViewController = toViewControllerExist
            foregroundViewController = fromViewControllerExist
        }

        var backgroundZoomingViewController = backgroundViewController as? ZoomingViewController
        var foregroundZoomingViewController = foregroundViewController as? ZoomingViewController

        guard let backgroundImageView = backgroundZoomingViewController?.zoomingImageView(),
              let foregroundImageView = foregroundZoomingViewController?.zoomingImageView()
              else {return}

        let imageViewSnapShot = UIImageView(image: backgroundImageView.image)
        imageViewSnapShot.contentMode = .scaleAspectFill
        imageViewSnapShot.layer.masksToBounds = true

        backgroundImageView.isHidden = true
        foregroundImageView.isHidden = true
        let foregroundViewBackgroundColor = foregroundImageView.backgroundColor
        foregroundImageView.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.white

        containerView.addSubview(backgroundViewController.view)
        containerView.addSubview(foregroundViewController.view)
        containerView.addSubview(imageViewSnapShot)

        var preTransitionState = TransitionState.initial
        var postTransitionState = TransitionState.final

        if operation == .pop {
            preTransitionState = TransitionState.final
            postTransitionState = TransitionState.initial
            damping = 1
        } else {
            damping = 0.6
        }

        configureView(for: preTransitionState, container: containerView, backgroundViewController: backgroundViewController, backgroundImageView: backgroundImageView, foregroundViewController: foregroundViewController, foregroundImageView: foregroundImageView, snapShotView: imageViewSnapShot)

        foregroundViewController.view.layoutIfNeeded()

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0.0, options: [], animations: {
            self.configureView(for: postTransitionState, container: containerView, backgroundViewController: backgroundViewController, backgroundImageView: backgroundImageView, foregroundViewController: foregroundViewController, foregroundImageView: foregroundImageView, snapShotView: imageViewSnapShot)
        }) { (finished) in
            backgroundViewController.view.transform = .identity
            imageViewSnapShot.removeFromSuperview()
            backgroundImageView.isHidden = false
            foregroundImageView.isHidden = false
            foregroundViewController.view.backgroundColor = foregroundViewBackgroundColor
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
}

extension ZoomTransitionDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is ZoomingViewController && toVC is ZoomingViewController {
            self.operation = operation
            return self
        } else {
            return nil
        }
    }
}





