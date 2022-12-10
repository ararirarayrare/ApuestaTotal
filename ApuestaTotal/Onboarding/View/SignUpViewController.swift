//
//  SignUpViewController.swift
//  BetFair
//
//  Created by mac on 07.12.2022.
//

import UIKit
import Combine

class SignUpViewController: BaseVC, UITextFieldDelegate {
    
    private let registrationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jomhuria-Regular", size: 80)
        label.textColor = .lightRed
        label.textAlignment = .center
        label.text = "Registration"
        return label
    }()

    private lazy var firstNameTextField = createTextField(placeholder: "First name")
    private lazy var lastNameTextField = createTextField(placeholder: "Last name")
        
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "create-button"), for: .normal)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
        
    @Published
    private var firstName: String = ""
    
    @Published
    private var lastName: String = ""
        
    private var validToRegister: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest($firstName, $lastName)
            .map { (firstName, lastName) -> Bool in
                return !firstName.isEmpty && !lastName.isEmpty
            }
            .eraseToAnyPublisher()
    }
    
    let viewModel: SignUpViewModel
    
    init(coordinator: Coordinator?, viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundImage()

        view.addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.widthAnchor.constraint(equalToConstant: 200),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        view.addSubview(lastNameTextField)
        NSLayoutConstraint.activate([
            lastNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lastNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                      multiplier: 0.6),
            lastNameTextField.bottomAnchor.constraint(equalTo: createButton.topAnchor,
                                                   constant: -24),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(firstNameTextField)
        NSLayoutConstraint.activate([
            firstNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                      multiplier: 0.6),
            firstNameTextField.bottomAnchor.constraint(equalTo: lastNameTextField.topAnchor,
                                                       constant: -12),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(registrationLabel)
        NSLayoutConstraint.activate([
            registrationLabel.bottomAnchor.constraint(equalTo: firstNameTextField.topAnchor,
                                                      constant: -0),
            registrationLabel.centerXAnchor.constraint(equalTo: firstNameTextField.centerXAnchor)
        ])

        validToRegister
            .receive(on: RunLoop.main)
            .sink { [weak self] valid in
                self?.createButton.isEnabled = valid
            }
            .store(in: &cancellables)
        
        view.subviews.forEach {
            if let _ = $0 as? UIImageView { return }
            $0.alpha = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addShape(to: firstNameTextField)
        addShape(to: lastNameTextField)
    }
    
    private func addShape(to view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: view.bounds,
                                       cornerRadius: view.layer.cornerRadius).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        if let sublayers = view.layer.sublayers {
            guard !sublayers.contains(shapeLayer) else {
                return
            }
        }
        
        view.layer.insertSublayer(shapeLayer, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.subviews.forEach {
            if let _ = $0 as? UIImageView { return }
            $0.alpha = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.subviews.reversed().enumerated().forEach { (index, subview) in
            if let _ = subview as? UIImageView { return }
            UIView.animate(withDuration: 0.3, delay: Double(index) / 5.0) {
                subview.alpha = 1
            }
        }
    }
    
    @objc
    private func signUpButtonTapped() {
        let userModel = UserModel(firstName: firstName,
                                  lastName: lastName)
            
        viewModel.saveUser(userModel)
        
        let successAlertView = SuccessAlertView { [weak self] in
            self?.coordinator?.start()
        }
        
        view.window?.addSubview(successAlertView)
        
        if !viewModel.hapticsDisabled {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
    
    @objc
    private func textDidChange(_ textField: UITextField) {
        if textField == firstNameTextField {
            firstName = textField.text ?? ""
        }
        
        if textField == lastNameTextField {
            lastName = textField.text ?? ""
        }
    }
    
    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.textColor = .white
        textField.tintColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .font : UIFont(name: "Jost-Regular", size: 26) ?? .boldSystemFont(ofSize: 26),
                .foregroundColor : UIColor.white
            ]
        )
        textField.backgroundColor = .darkGray
        textField.textAlignment = .center
        
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        
        textField.layer.cornerRadius = 12
        
        return textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
