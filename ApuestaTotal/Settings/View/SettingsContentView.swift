//
//  SettingView.swift
//  Bet3
//
//  Created by mac on 27.10.2022.
//

import UIKit
import Combine

class SettingsContentView: UIView, Coordinating {
    
    var coordinator: Coordinator?
    
    let viewModel: LoggedInViewModel
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2.0
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .black
        
        stackView.layer.cornerRadius = 20
        stackView.layer.masksToBounds = true
        
        return stackView
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Courier New Bold", size: 16)
        label.textColor = .black
        label.textAlignment = .right
        label.text = "Version - 1.0 (1)"
        return label
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: LoggedInViewModel, coordinator: Coordinator?) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        backgroundColor = UIColor(red: 233/255, green: 52/255, blue: 39/255, alpha: 1.0)
        layer.cornerRadius = 24
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
        addSubview(versionLabel)
        NSLayoutConstraint.activate([
            versionLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -20),
            versionLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                 constant: -12)
        ])
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: 4),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -4),
            stackView.topAnchor.constraint(equalTo: topAnchor,
                                           constant: 4),
            stackView.bottomAnchor.constraint(greaterThanOrEqualTo: versionLabel.topAnchor,
                                              constant: -64)
        ])
        
        let settingTypes: [SettingView.SettingType] = [
            .privacyPolicy,
            .shareApp,
            .notifications(!viewModel.notificationsDisabled),
            .haptics(!viewModel.hapticsDisabled),
            .delete
        ]
        
        settingTypes.forEach { type in
            let settingView = SettingView(type: type)
            settingView.publisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] type in
                    self?.configure(withType: type)
                }
                .store(in: &cancellables)
            
            stackView.addArrangedSubview(settingView)
        }
        

        stackView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.stackView.alpha = 1
        }
        
    }
    
    private func configure(withType type: SettingView.SettingType) {
        if !viewModel.hapticsDisabled {
            UISelectionFeedbackGenerator().selectionChanged()
        }
        
        
        switch type {
        case .haptics(let isOn):
            viewModel.hapticsDisabled = !isOn
            
        case .notifications(let isOn):
            viewModel.notificationsDisabled = !isOn
            
        case .privacyPolicy:
            if let url = viewModel.privacyPolicyURL {
                coordinator?.eventOccured(.web(url))
            }
        case .shareApp:
            if let url = viewModel.appstoreURL {
                coordinator?.eventOccured(.share(url))
            }
        case .delete:
            
            let alertTitle = "You want to delete your account?"
            let alertAction = { [weak self] in
                self?.viewModel.deleteAccount()
                self?.coordinator?.eventOccured(
                    .successAlert { [weak self] in
                        self?.coordinator?.onboard()
                    }
                )
            }
            
            self.coordinator?.eventOccured(.alert(alertTitle, alertAction))
            
        }
    }
}


class SettingView: UIView {
    
    enum SettingType {

        case shareApp, privacyPolicy, delete, notifications(Bool), haptics(Bool)
        
        var title: String {
            switch self {
            case .shareApp:
                return "Share app"
            case .privacyPolicy:
                return "Privacy Policy"
            case .notifications:
                return "Notifications"
            case .delete:
                return "Delete my account"
            case .haptics:
                return "Haptics"
            }
        }
    }
    
    let type: SettingType
    
    let publisher = PassthroughSubject<SettingType, Never>()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jost-Bold", size: 22)
        label.textColor = .white
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    init(type: SettingType) {
        self.type = type
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 233/255, green: 52/255, blue: 39/255, alpha: 1.0)
        
        titleLabel.text = type.title
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        switch type {
        case .privacyPolicy:
            let button = createButton(image: .chevronRight)
            setButton(button, stretched: true)
        case .shareApp:
            let button = createButton(image: .share)
            setButton(button)
        case .delete:
            let button = createButton(image: .trash)
            setButton(button)
        case .notifications(let isOn):
            let uiSwitch = createSwitch(isOn: isOn)
            setSwitch(uiSwitch)
        case .haptics(let isOn):
            let uiSwitch = createSwitch(isOn: isOn)
            setSwitch(uiSwitch)
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc
    private func buttonTapped() {
        publisher.send(type)
    }
    
    @objc
    private func switchTapped(_ sender: UISwitch) {
        switch type {
        case .notifications:
            publisher.send(.notifications(sender.isOn))
        case .haptics:
            publisher.send(.haptics(sender.isOn))
        default:
            break
        }
    }
    
    private func createButton(image: UIImage?) -> UIButton {
        let button = UIButton(type: .system)
        button.setBackgroundImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }
    
    private func createSwitch(isOn: Bool) -> UISwitch {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = isOn
        uiSwitch.addTarget(self, action: #selector(switchTapped(_:)), for: .valueChanged)
        return uiSwitch
    }
    
    private func setButton(_ button: UIButton, stretched: Bool = false) {
        clearSubviews()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: -20),
            button.topAnchor.constraint(equalTo: topAnchor,
                                        constant: 12),
            button.bottomAnchor.constraint(equalTo: bottomAnchor,
                                           constant: -12),
            button.widthAnchor.constraint(equalTo: button.heightAnchor,
                                          multiplier: stretched ? 0.5 : 1.0),
            titleLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor,
                                                 constant: -20)
        ])
    }
    
    private func setSwitch(_ uiSwitch: UISwitch) {
        clearSubviews()
        
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        addSubview(uiSwitch)
        NSLayoutConstraint.activate([
            uiSwitch.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: -20),
            uiSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: uiSwitch.leadingAnchor,
                                                 constant: -20)
        ])
    }
    
    private func clearSubviews() {
        subviews.forEach { subview in
            if subview != titleLabel {
                subview.removeFromSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
