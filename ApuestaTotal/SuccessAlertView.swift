//
//  SuccessAlertView.swift
//  Bet3
//
//  Created by mac on 31.10.2022.
//

import UIKit

class SuccessAlertView: UIView, CAAnimationDelegate {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.frame.size = CGSize(width: bounds.width * 0.35,
                                 height: bounds.width * 0.35)
        view.center = center
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
                
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
        effectView.frame = view.bounds
        
        view.addSubview(effectView)
            
        return view
    }()
    
    private let completion: () -> Void
    
    init(completion: @escaping () -> Void ) {
        self.completion = completion
        super.init(frame: UIScreen.main.bounds)
        
//        backgroundColor = .black.withAlphaComponent(0.5)
        alpha = 0
        
        addSubview(containerView)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        UIView.animate(withDuration: 0.35) { [weak self] in
            self?.alpha = 1
        } completion: { [weak self] _ in
            self?.animate()
        }
    }
    
    private func animate() {
        let layer = CAShapeLayer()
        
        let path = UIBezierPath()
        
        let inset = 36.0
        
        let leftMid = CGPoint(x: containerView.frame.minX + inset,
                              y: containerView.frame.midY)
        
        let midBottom = CGPoint(x: containerView.frame.midX,
                                y: containerView.frame.maxY - inset)
        
        let rightTop = CGPoint(x: containerView.frame.maxX - inset,
                               y: containerView.frame.minY + inset)
        
        path.move(to: leftMid)
        path.addLine(to: midBottom)
        path.addLine(to: rightTop)
        
        layer.path = path.cgPath
        
        layer.lineWidth = 8
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        
        layer.lineJoin = .round
        layer.lineCap = .round
        
        layer.strokeEnd = 0
        
        self.layer.addSublayer(layer)
        
        
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.duration = 0.4
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            layer.strokeEnd = 1
            layer.add(animation, forKey: "stroke")
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.completion()
            self?.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
