//
//  MyBetsPresentationController.swift
//  BetFair
//
//  Created by mac on 07.12.2022.
//

import UIKit

class PresentationController: UIPresentationController, Coordinating {
    
    var coordinator: Coordinator?
    
    let blurEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override init(presentedViewController: UIViewController,
                  presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = self.containerView else {
            return .zero
        }
        
        let origin = CGPoint(x: 0, y: containerView.frame.height * 0.4)
        let size = CGSize(width: containerView.frame.width,
                          height: containerView.frame.height * 0.6)
        
        return CGRect(origin: origin, size: size)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate { [weak self] _ in
            self?.blurEffectView.alpha = 0.5
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        self.presentedViewController.transitionCoordinator?.animate { [weak self] _ in
            self?.blurEffectView.alpha = 0
        } completion: { [weak self] _ in
            self?.blurEffectView.removeFromSuperview()
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        guard let presentedView = self.presentedView else {
            return
        }
        
        let path = UIBezierPath(roundedRect: presentedView.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 20, height: 20))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        presentedView.layer.mask = mask
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView?.bounds ?? .zero
    }
    
    @objc
    private func tapped() {
        coordinator?.eventOccured(.dismiss)
    }
}
