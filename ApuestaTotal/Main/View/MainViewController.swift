import UIKit
import Combine

class MainViewController: BaseVC {
    
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel, coordinator: Coordinator?) {
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
        
        viewModel.fetchData()
        
        viewModel.$mainCollectionViewModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewModel in
                self?.collectionView.viewModel = viewModel
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let collectionView: MainCollectionView = {
        let collectionView = MainCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    private let myBetsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "my-bets-button"), for: .normal)
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackgroundImage()
        
        collectionView.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (sport, eventModels) in
                self?.coordinator?.eventOccured(.events(sport, eventModels))
            }
            .store(in: &cancellables)
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        myBetsButton.addTarget(self, action: #selector(myBetsTapped), for: .touchUpInside)
        view.addSubview(myBetsButton)
        NSLayoutConstraint.activate([
            myBetsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                constant: 0),
            myBetsButton.heightAnchor.constraint(equalToConstant: 110),
            myBetsButton.widthAnchor.constraint(equalToConstant: 270),
            myBetsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let searchBar = UISearchBar()
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = .darkGray
        searchBar.autocorrectionType = .no
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.tintColor = .white
        navigationItem.titleView = searchBar
        
        let barButtonItem = UIBarButtonItem(
            image: .person,
            style: .plain,
            target: self,
            action: #selector(profileButtonTapped)
        )
        barButtonItem.tintColor = .white
        
        navigationItem.rightBarButtonItem = barButtonItem
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.title = "Sports"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc
    private func profileButtonTapped() {
        coordinator?.eventOccured(.settings)
    }
    
    @objc
    private func myBetsTapped() {
        coordinator?.eventOccured(.myBets)
    }
    
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        collectionView.viewModel?.filterModels(by: searchText)
    }
}
