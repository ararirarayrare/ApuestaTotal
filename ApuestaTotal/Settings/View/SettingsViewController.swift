//
//  ProfileViewController.swift
//  Bet3
//
//  Created by mac on 26.10.2022.
//

import UIKit

class SettingsViewController: BaseVC {
    
    let viewModel: SettingsViewModel
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        //        scrollView.delegate = self
        return scrollView
    }()
    
    private var containerView: SettingsContentView!
    
    init(viewModel: SettingsViewModel, coordinator: Coordinator?) {
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundImage()
        
        let backBarButton = UIBarButtonItem(
            image: .back,
            style: .plain,
            target: self,
            action: #selector(backBarButtonTapped)
        )
        backBarButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        guard containerView == nil, let username = viewModel.username, viewModel.isLogged  else {
            coordinator?.eventOccured(.pop)
            return
        }
        
        setupScrollView()
        setupContaierView()
        
        containerView.setupLayout()
        setNavigationTitle("Hello, \(username)", animated: true, delay: 0.3)
    }
    
    
    @objc
    private func backBarButtonTapped() {
        coordinator?.eventOccured(.pop)
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupContaierView() {
        let viewModel = viewModel.getLoggedInViewModel()
        self.containerView = SettingsContentView(viewModel: viewModel,
                                          coordinator: self.coordinator)
                
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        let contentGuide = scrollView.contentLayoutGuide

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: contentGuide.topAnchor,
                                               constant: 80)
        ])
        
        let contentViewCenterY = containerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        contentViewCenterY.priority = .defaultLow
        
        let contentViewHeight = containerView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentViewCenterY,
            contentViewHeight
        ])
    }
    
    private func setNavigationTitle(_ title: String, animated: Bool, delay: TimeInterval = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            
            var text = ""
            
            for char in title {
                text += String(describing: char)
                RunLoop.current.run(until: Date() + (animated ? 0.05 : 0 ) )
                self?.navigationItem.title = text
            }
            
        }
    }
}
