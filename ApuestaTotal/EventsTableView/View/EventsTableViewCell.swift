//
//  EventsTableViewCell.swift
//  Bet3
//
//  Created by mac on 28.10.2022.
//

import UIKit
import Combine

class EventsTableViewCell: UITableViewCell {
    
    let containerView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "container-bg")
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    var model: EventModel!

    func setup(withModel model: EventModel) {
        self.model = model
        backgroundColor = .clear
        
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: 8),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: -8),
            containerView.topAnchor.constraint(equalTo: topAnchor,
                                               constant: 8),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -8)
        ])
    }
}

class ScheduleTableViewCell: EventsTableViewCell {
    
    var publisher: PassthroughSubject<(EventModel, Team), Never>?
    
    private let eventLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont(name: "Jost-Bold", size: 32)
        label.textAlignment = .center
        label.textColor = .white
        
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont(name: "Jost-Regular", size: 22)
        label.textAlignment = .center
        label.textColor = .white
        
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }()
    
    private lazy var homeBetButton = createButton()
    private lazy var awayBetButton = createButton()
        
    override func setup(withModel model: EventModel) {
        super.setup(withModel: model)
        
        eventLabel.text = model.event
        containerView.addSubview(eventLabel)
        NSLayoutConstraint.activate([
            eventLabel.topAnchor.constraint(equalTo: containerView.topAnchor,
                                            constant: 8),
            eventLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                constant: 12),
            eventLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                 constant: -12),
            eventLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        timeLabel.text = "Today - " + (model.eventTime ?? "00:00")
        containerView.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                              constant: -8),
            timeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 150),
            timeLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        homeBetButton.tag = Team.home.rawValue
        homeBetButton.setTitle(model.homeOdd?.replacingOccurrences(of: ",", with: "."), for: .normal)
        containerView.addSubview(homeBetButton)
        NSLayoutConstraint.activate([
            homeBetButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                   constant: 40),
            homeBetButton.bottomAnchor.constraint(equalTo: timeLabel.topAnchor,
                                               constant: -16),
            homeBetButton.widthAnchor.constraint(equalToConstant: 100),
            homeBetButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        awayBetButton.tag = Team.away.rawValue
        awayBetButton.setTitle(model.awayOdd?.replacingOccurrences(of: ",", with: "."), for: .normal)
        containerView.addSubview(awayBetButton)
        NSLayoutConstraint.activate([
            awayBetButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                   constant: -40),
            awayBetButton.bottomAnchor.constraint(equalTo: timeLabel.topAnchor,
                                               constant: -16),
            awayBetButton.widthAnchor.constraint(equalToConstant: 100),
            awayBetButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    @objc
    private func betButtonTapped(_ sender: UIButton) {
        if let team = Team(rawValue: sender.tag) {
            publisher?.send((model, team))
            
            if !UserDefaultsManager().hapticsDisabled {
                UISelectionFeedbackGenerator().selectionChanged()
            }
        }
    }
    
    private func createButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = UIFont(name: "Jost-Bold", size: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        
        button.setBackgroundImage(UIImage(named: "bet-button-bg"), for: .normal)
        
        button.addTarget(self, action: #selector(betButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
}


class BetsTableViewCell: EventsTableViewCell {
    
    var publisher: PassthroughSubject<(SavedEventModel, IndexPath), Never>?
    
    private let removeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.trash, for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var sportLabel: UILabel = createLabel(type: .sport)
    
    private lazy var eventLabel: UILabel = createLabel(type: .event)
    
    private lazy var betLabel: UILabel = createLabel(type: .bet)
    
    private var savedEventModel: SavedEventModel?
    var indexPath: IndexPath?
        
    override func setup(withModel model: EventModel) {
        super.setup(withModel: model)
        
        guard let savedEventModel = model as? SavedEventModel else {
            fatalError("Bets table view must have [SavedEventModel] models!")
        }
        
        self.savedEventModel = savedEventModel
        
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        containerView.addSubview(removeButton)
        NSLayoutConstraint.activate([
            removeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                   constant: -12),
            removeButton.topAnchor.constraint(equalTo: containerView.topAnchor,
                                              constant: 6),
            removeButton.widthAnchor.constraint(equalToConstant: 40),
            removeButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        
        sportLabel.text = model.sport
        containerView.addSubview(sportLabel)
        NSLayoutConstraint.activate([
            sportLabel.topAnchor.constraint(equalTo: containerView.topAnchor,
                                            constant: 8),
            sportLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            sportLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor,
                                              multiplier: 0.6),
            sportLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        eventLabel.text = model.event
        containerView.addSubview(eventLabel)
        NSLayoutConstraint.activate([
            eventLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                constant: 20),
            eventLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                 constant: -20),
            eventLabel.topAnchor.constraint(equalTo: sportLabel.bottomAnchor,
                                            constant: 20),
            eventLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        if let odd = (savedEventModel.betTeam == .home) ? savedEventModel.homeOdd : savedEventModel.awayOdd {
            betLabel.text = "Win: \(savedEventModel.betTeam.string) | \(savedEventModel.betAmount)$ | x\(odd)"
        }
        
        containerView.addSubview(betLabel)
        NSLayoutConstraint.activate([
            betLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                constant: 20),
            betLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                 constant: -20),
            betLabel.topAnchor.constraint(equalTo: eventLabel.bottomAnchor,
                                            constant: 16),
            betLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc
    private func removeTapped() {
        if let savedEventModel = savedEventModel, let indexPath = indexPath {
            publisher?.send((savedEventModel, indexPath))
        }
    }
    
    enum LabelType {
        case sport, event, bet
    }
    
    private func createLabel(type: LabelType) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.textColor = .white
        
        label.adjustsFontSizeToFitWidth = true
        
        switch type {
        case .sport:
            label.font = UIFont(name: "Jost-Bold", size: 40)
            label.numberOfLines = 1
        case .event:
            label.font = UIFont(name: "Jost-Regular", size: 22)
            label.numberOfLines = 2
            label.minimumScaleFactor = 0.5
        case .bet:
            label.font = UIFont(name: "Jost-Regular", size: 22)
            label.numberOfLines = 1
        }
        
        return label
    }
    
}
