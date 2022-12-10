//
//  MainCollectionViewCell.swift
//  Bet3
//
//  Created by mac on 25.10.2022.
//

import UIKit
import Combine

class MainCollectionViewCell: UICollectionViewCell {
    
    private var buttonCenterXConstraint: NSLayoutConstraint?
    
    var publisher: PassthroughSubject<(String, [EventModel]), Never>?
    
    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "cell-background"), for: .normal)
        
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var sport: String?
    private var eventModels: [EventModel]?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jomhuria-Regular", size: 36)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.layer.cornerRadius = button.bounds.height / 2
    }
    
    func configure(withModel model: MainCollectionViewCellModel, containerViewMirrored mirrored: Bool) {
        self.eventModels = model.eventModels
        self.sport = model.sportTitle
        
        if !model.hasEvents {
            button.alpha = 0.6
            button.isUserInteractionEnabled = false
        }
        
        NSLayoutConstraint.deactivate(button.constraints)

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor,
                                               constant: 12),
            button.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -12),
            button.widthAnchor.constraint(equalTo: button.heightAnchor),
        ])

        if buttonCenterXConstraint == nil {
            buttonCenterXConstraint = button.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                                      constant: 0)
            buttonCenterXConstraint?.isActive = true
        }
        
        let buttonSide = bounds.height - 24
        let centerXConstant = mirrored ? (buttonSide / 2) : -(buttonSide / 2)
        buttonCenterXConstraint?.constant = centerXConstant
        layoutIfNeeded()

        imageView.image = model.image
        button.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: button.topAnchor,
                                           constant: 32),
            imageView.widthAnchor.constraint(equalTo: button.widthAnchor,
                                             multiplier: 0.35),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        titleLabel.text = model.sportTitle
        button.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                            constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: button.widthAnchor,
                                              multiplier: 0.6)
        ])
            
        button.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    @objc
    private func buttonTapped() {
        guard let sport = sport,
              let eventModels = eventModels else {
            return
        }
        
        publisher?.send((sport, eventModels))
        
        if !UserDefaultsManager().hapticsDisabled {
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }
    
    func appearAnimated() {
        let randomScale = CGFloat.random(in: 0.9...1.1)
        
        UIView.animate(withDuration: 0.5,
                       delay: Double.random(in: 0.1...0.3),
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 2,
                       options: [.layoutSubviews]) { [weak self] in

            self?.button.transform = CGAffineTransform(scaleX: randomScale, y: randomScale)
        }
        
        if !UserDefaultsManager().hapticsDisabled {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    func disappear() {
        button.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
}
