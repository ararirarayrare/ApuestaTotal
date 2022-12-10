//
//  EventsViewController.swift
//  Bet3
//
//  Created by mac on 28.10.2022.
//

import UIKit

class EventsViewController: BaseVC {
    
    let viewModel: EventsViewModel
    
    private lazy var tableView: ScheduleTableView = {
        let tableView = ScheduleTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    init(title: String, viewModel: EventsViewModel, coordinator: Coordinator?) {
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
        
        tableView.viewModel = viewModel.eventsTableViewModel
        
        navigationItem.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundImage()
        
        tableView.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (eventModel, team) in
                
                if let viewModel = self?.viewModel.betViewModel(eventModel: eventModel, team: team) {
                    let betView = BetView(viewModel: viewModel, coordinator: self?.coordinator)
                    self?.view.window?.addSubview(betView)
                }
                
            }
            .store(in: &cancellables)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
        
        let searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = .darkGray
        searchBar.searchTextField.textColor = .white
        searchBar.autocorrectionType = .no
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.tintColor = .white
        navigationItem.titleView = searchBar
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc
    private func backTapped() {
        coordinator?.eventOccured(.pop)
        
        if !viewModel.hapticsDisabled {
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }

}

extension EventsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.viewModel?.filterModels(by: searchText)
    }
}
