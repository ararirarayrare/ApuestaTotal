//
//  MyBetsViewController.swift
//  Bet3
//
//  Created by mac on 01.11.2022.
//

import UIKit

class MyBetsViewController: BaseVC {
    
    private var hasSetPointOrigin: Bool = false
    private var pointOrigin: CGPoint?
    
    let viewModel: MyBetsViewModel
    
    private let tableView: BetsTableView = {
        let tableView = BetsTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 250, height: 250)
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jost-Bold", size: 30)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.text = "No saved events found :("
        
        imageView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor,
                                           constant: -20),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                            constant: 20),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                       constant: 16)
        ])
        
        return imageView
    }()
    
    init(viewModel: MyBetsViewModel, coordinator: Coordinator?) {
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
        
        tableView.viewModel = viewModel.betsTableViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundImage()
        
        tableView.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (savedEventModel, indexPath) in
                
                let alertTitle = "You want to delete this bet?"
                
                let alertAction = { [weak self] in
                    self?.viewModel.removeBet(savedEventModel)
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                }
                
                self?.coordinator?.eventOccured(
                    .alert(alertTitle, alertAction)
                )
                
            }
            .store(in: &cancellables)
        
        let indicatorLineView = UIView()
        indicatorLineView.frame.size = CGSize(width: 60, height: 4)
        indicatorLineView.frame.origin.y = 16
        indicatorLineView.center.x = view.center.x
        indicatorLineView.layer.cornerRadius = 1
        indicatorLineView.backgroundColor = .lightGray
        
        view.addSubview(indicatorLineView)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: indicatorLineView.bottomAnchor,
                                           constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let backBarButton = UIBarButtonItem(
            image: .close,
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        backBarButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = backBarButton
        
        let removeAllBarButton = UIBarButtonItem(
            image: .trash,
            style: .plain,
            target: self,
            action: #selector(removeAllTapped)
        )
        removeAllBarButton.tintColor = .white
        
        viewModel.betsTableViewModel.$currentModels
            .map { $0.isEmpty }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEmpty in
                removeAllBarButton.isEnabled = !isEmpty
                if isEmpty {
                    self?.showStar()
                }
            }
            .store(in: &cancellables)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(sender:)))
        view.addGestureRecognizer(panGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !hasSetPointOrigin {
            pointOrigin = view.frame.origin
            hasSetPointOrigin = true
        }
        
        let shapeLayer = CAShapeLayer()
        let rect = CGRect(x: -2,
                          y: 2,
                          width: view.bounds.width + 4,
                          height: view.bounds.height + 20)
        shapeLayer.path = UIBezierPath(roundedRect: rect,
                                       cornerRadius: 20).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 4.0
        
        view.layer.addSublayer(shapeLayer)
    }
    
    @objc
    private func panGestureAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        guard let pointOrigin = pointOrigin, translation.y >= 0 else {
            return
        }
        
        view.frame.origin = CGPoint(x: 0, y: pointOrigin.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 || translation.y >= (view.frame.height / 2) {
                coordinator?.eventOccured(.dismiss)
            } else {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.view.frame.origin = pointOrigin
                }
            }
        }
        
        let blurAlpha = 0.5 * (1 - translation.y / view.frame.height)
        (presentationController as? PresentationController)?.blurEffectView.alpha = blurAlpha
    }
    
    @objc
    private func backTapped() {
        coordinator?.eventOccured(.pop)
    }
    
    @objc
    private func removeAllTapped() {
        let alertTitle = "Remove all saved bets?"
        
        let alertAction = { [weak self] in
            self?.viewModel.removeAllBets()
            self?.tableView.deleteAllRows()
        }
        
        coordinator?.eventOccured(
            .alert(alertTitle, alertAction)
        )
    }
    
    private func showStar() {
        starImageView.frame.origin.y = 40
        starImageView.center.x = view.center.x
        view.addSubview(starImageView)
        
//        starImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
//        UIView.animate(withDuration: 0.3) { [weak self] in
//            self?.starImageView.transform = .identity
//        }
    }
}
