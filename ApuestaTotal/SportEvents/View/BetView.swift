//
//  BetView.swift
//  Bet3
//
//  Created by mac on 31.10.2022.
//

import UIKit
import Combine

class BetView: UIView, Coordinating {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.frame.size = CGSize(width: UIScreen.main.bounds.width - 64,
                                 height: 280)
        view.center.x = center.x
        view.center.y = center.y - 64
        
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "container-bg")
        view.addSubview(imageView)
        
        view.transform = CGAffineTransform(scaleX: 0, y: 0)
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(.close, for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var sportLabel = createLabel(type: .sport)
    private lazy var eventLabel = createLabel(type: .event)
    private lazy var betLabel = createLabel(type: .bet)
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .darkGray
        textField.tintColor = .white
        textField.textColor = .white
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: "Bet amount",
            attributes: [
                .font : UIFont(name: "Jost-Regular", size: 22) ?? .boldSystemFont(ofSize: 22),
                .foregroundColor : UIColor.lightGray
            ]
        )
        textField.font = UIFont(name: "Jost-Bold", size: 22)
        
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = UIFont(name: "Jomhuria-Regular", size: 40)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .customGreen
        button.setTitle("Save bet", for: .normal)
        
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    @Published
    private var amount: String = ""
    
    private var isValidToSave: AnyPublisher<Bool, Never> {
        return $amount
            .map { !$0.isEmpty && Double($0) ?? -1 > 0 }
            .eraseToAnyPublisher()
    }
        
    private var cancellables = Set<AnyCancellable>()
    
    let viewModel: BetViewModel
    
    var coordinator: Coordinator?
    
    init(viewModel: BetViewModel, coordinator: Coordinator?) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(frame: UIScreen.main.bounds)
        
        backgroundColor = .black.withAlphaComponent(0.7)
        alpha = 0
        
        addSubview(containerView)
        
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        containerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                  constant: -8),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor,
                                             constant: 8),
            closeButton.widthAnchor.constraint(equalToConstant: 48),
            closeButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        sportLabel.text = viewModel.eventModel.sport
        containerView.addSubview(sportLabel)
        NSLayoutConstraint.activate([
            sportLabel.topAnchor.constraint(equalTo: containerView.topAnchor,
                                            constant: 12),
            sportLabel.heightAnchor.constraint(equalToConstant: 40),
            sportLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            sportLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor,
                                              multiplier: 0.65)
        ])
        
        eventLabel.text = viewModel.eventModel.event
        containerView.addSubview(eventLabel)
        NSLayoutConstraint.activate([
            eventLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                constant: 12),
            eventLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                 constant: -12),
            eventLabel.topAnchor.constraint(equalTo: sportLabel.bottomAnchor,
                                            constant: 8),
            eventLabel.heightAnchor.constraint(equalToConstant: 50)
        ])

        if let odd = viewModel.odd?.replacingOccurrences(of: ",", with: ".") {
            betLabel.text = "Win: \(viewModel.team.string) | Odd: \(odd)"
        }
        
        containerView.addSubview(betLabel)
        NSLayoutConstraint.activate([
            betLabel.leadingAnchor.constraint(equalTo: eventLabel.leadingAnchor),
            betLabel.trailingAnchor.constraint(equalTo: eventLabel.trailingAnchor),
            betLabel.topAnchor.constraint(equalTo: eventLabel.bottomAnchor,
                                          constant: 8),
            betLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        amountTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        containerView.addSubview(amountTextField)
        NSLayoutConstraint.activate([
            amountTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                     constant: 48),
            amountTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                      constant: -48),
            amountTextField.topAnchor.constraint(equalTo: betLabel.bottomAnchor,
                                                 constant: 12),
            amountTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        isValidToSave
            .receive(on: DispatchQueue.main)
            .sink { [weak self] valid in
                
                self?.saveButton.isUserInteractionEnabled = valid
                self?.saveButton.setTitleColor(.white, for: .normal)
                UIView.animate(withDuration: 0.1) { [weak self] in
                    self?.saveButton.backgroundColor = valid ? .customGreen : .gray
                    self?.saveButton.alpha = valid ? 1 : 0.6
                }
                
            }
            .store(in: &cancellables)
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        containerView.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor,
                                            constant: 16),
            saveButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 180),
            saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                               constant: -20)
        ])
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.alpha = 1
            self?.containerView.transform = .identity
        }
        
        amountTextField.becomeFirstResponder()
    }
    
    @objc
    private func close() {
        if !viewModel.hapticsDisabled {
            UISelectionFeedbackGenerator().selectionChanged()
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.alpha = 0
        } completion: { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
    
    @objc
    private func textDidChange(_ sender: UITextField) {
        sender.text = sender.text?.replacingOccurrences(of: ",", with: ".")
        amount = sender.text ?? ""
    }
    
    @objc
    private func saveButtonTapped() {
        if let doubleAmount = Double(amount), doubleAmount > 0 {
            viewModel.saveBet(amount: doubleAmount)
            
            if !viewModel.hapticsDisabled {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
            
            coordinator?.eventOccured(
                .successAlert { [weak self] in
                    self?.close()
                }
            )
        }
    }
    
    
    enum LabelType {
        case sport, event, bet
    }
    
    private func createLabel(type: LabelType) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        
        switch type {
        case .sport:
            label.font = UIFont(name: "Jost-Bold", size: 72)
            label.textAlignment = .center
            label.numberOfLines = 1
        case .event:
            label.font = UIFont(name: "Jost-Regular", size: 20)
            label.textAlignment = .center
            label.numberOfLines = 2
            label.lineBreakMode = .byWordWrapping
            label.minimumScaleFactor = 0.25
        case .bet:
            label.font = UIFont(name: "Jost-Regular", size: 22)
            label.textAlignment = .center
            label.numberOfLines = 1
        }
        
        return label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
