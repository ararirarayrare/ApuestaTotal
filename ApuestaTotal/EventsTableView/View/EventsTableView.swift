//
//  EventsTableView.swift
//  Bet3
//
//  Created by mac on 28.10.2022.
//

import UIKit
import Combine

class EventsTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
        
    var viewModel: EventsTableViewModel? {
        didSet {
            viewModel?.$currentModels
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.reloadData()
                }
                .store(in: &cancellables)
            
            delegate = self
            dataSource = self
        }
    }
    
    fileprivate var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(frame: .zero, style: .plain)
        
        backgroundColor = .clear
        separatorColor = .clear
        
        allowsSelection = false

        register(ScheduleTableViewCell.self,
                 forCellReuseIdentifier: String(describing: ScheduleTableViewCell.self))
        
        register(BetsTableViewCell.self,
                 forCellReuseIdentifier: String(describing: BetsTableViewCell.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return EventsTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}

class ScheduleTableView: EventsTableView {
    
    let publisher = PassthroughSubject<(EventModel, Team), Never>()
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: ScheduleTableViewCell.self)
        
        guard let cell = dequeueReusableCell(withIdentifier: identifier,
                                             for: indexPath) as? ScheduleTableViewCell else {
            return ScheduleTableViewCell()
        }
    
        if let model = viewModel?.model(forRow: indexPath.row) {
            cell.setup(withModel: model)
            cell.publisher = publisher
        }
        
        return cell
    }
    
}

class BetsTableView: EventsTableView {
    
    let publisher = PassthroughSubject<(SavedEventModel, IndexPath), Never>()

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: BetsTableViewCell.self)
        
        guard let cell = dequeueReusableCell(withIdentifier: identifier,
                                             for: indexPath) as? BetsTableViewCell else {
            return BetsTableViewCell()
        }
    
        if let model = viewModel?.model(forRow: indexPath.row) {
            cell.setup(withModel: model)
            cell.publisher = publisher
            cell.indexPath = indexPath
        }
        
        return cell
    }
    
    override func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        beginUpdates()
        
        super.deleteRows(at: indexPaths, with: animation)
        indexPaths.forEach { viewModel?.removeAt(index: $0.row) }
        
        endUpdates()
    }
    
    func deleteAllRows() {
        viewModel?.removeAll()
    }
    
}
