//
//  MainCollectionView.swift
//  Bet3
//
//  Created by mac on 25.10.2022.
//

import UIKit
import Combine

class MainCollectionView: UICollectionView {
    
    var viewModel: MainCollectionViewModel! {
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
    
    let publisher = PassthroughSubject<(String, [EventModel]), Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let inset = 12.0
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        super.init(frame: .zero, collectionViewLayout: layout)
        contentInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        
        let cellClass = MainCollectionViewCell.self
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: MainCollectionViewCell.self), for: indexPath) as? MainCollectionViewCell else {
            return MainCollectionViewCell()
        }
        
        if let model = viewModel?.modelForCell(at: indexPath.item) {
            cell.configure(withModel: model, containerViewMirrored: indexPath.item % 2 == 0)
            cell.publisher = self.publisher
        }
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? MainCollectionViewCell)?.appearAnimated()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? MainCollectionViewCell)?.disappear()
    }
}

extension MainCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let horizontalInsets = (contentInset.left + contentInset.right)
        let size = CGSize(width: bounds.width - horizontalInsets, height: 200.0)
        return size
    }
    
    
}
