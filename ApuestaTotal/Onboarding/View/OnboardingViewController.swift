//
//  OnboardingViewController.swift
//  BetFair
//
//  Created by mac on 07.12.2022.
//

import UIKit

class OnboardingViewController: BaseVC {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jomhuria-Regular", size: 80)
        label.textColor = .lightRed
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jost-Bold", size: 28)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(image: UIImage?, title: String, subtitle: String) {
        super.init(coordinator: nil)
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundImage()
        
        layout()
    }
    
    private func layout() {
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 64),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: 64),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -64),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                           constant: 24),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 40),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -40),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                               constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant: -24),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                  constant: -24)
        ])
    }
    
}
