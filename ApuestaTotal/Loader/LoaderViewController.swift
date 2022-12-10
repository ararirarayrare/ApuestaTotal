//
//  LoaderViewController.swift
//  Bet3
//
//  Created by mac on 02.11.2022.
//

import UIKit

class LoaderViewController: BaseVC {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 250, height: 250)
        imageView.center = view.center
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var progressView: UIProgressView!
    
    private let completion: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
        super.init(coordinator: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundImage()
        
        view.addSubview(imageView)
        
        progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = .lightGray.withAlphaComponent(0.5)
        progressView.progressTintColor = .red
        progressView.layer.cornerRadius = 8
        progressView.layer.masksToBounds = true
        
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: 80),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant: -80),
            progressView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -80),
            progressView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        UIView.animate(withDuration: 1.0,
//                       delay: 0,
//                       options: [.autoreverse, .repeat]) { [weak self] in
//            self?.imageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//        }

        let intRandom = Int.random(in: 3...5)
        for i in 1...intRandom {
            let progress = Float(i) / Float(intRandom)
            progressView.setProgress(progress, animated: true)
            RunLoop.current.run(until: Date() + Double.random(in: 0.4...0.8))
        }

        self.completion()
        
    }
    
}
