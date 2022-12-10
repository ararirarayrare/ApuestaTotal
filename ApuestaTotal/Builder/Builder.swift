import UIKit

protocol Builder {
    func createMain(coordinator: Coordinator) -> MainViewController
    func createSettings(coordinator: Coordinator) -> SettingsViewController
    func createWeb(url: URL, coordinator: Coordinator) -> WebViewController
    func createActivityViewController(url: URL) -> UIActivityViewController
    func createEvents(sport: String, models: [EventModel], coordinator: Coordinator) -> EventsViewController
    func createSuccessAlert(completion: @escaping () -> Void) -> SuccessAlertView
    func createMyBets(coordinator: Coordinator) -> MyBetsViewController
    func createAlert(title: String, completion: @escaping () -> Void) -> UIAlertController
    func createOnboarding(coordinator: Coordinator) -> OnboardingPageViewController
}

class MainBuilder: Builder {
    
    private let userDefaultsManager: UserDefaultsManager
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager, userDefaultsManager: UserDefaultsManager) {
        self.userDefaultsManager = userDefaultsManager
        self.networkManager = networkManager
    }
        
    func createMain(coordinator: Coordinator) -> MainViewController {
        let viewModel = MainViewModel(networkManager: self.networkManager)
        let vc = MainViewController(viewModel: viewModel,
                                    coordinator: coordinator)

        return vc
    }
    
    func createSettings(coordinator: Coordinator) -> SettingsViewController {
        let viewModel = SettingsViewModel(userDefaultsManager: self.userDefaultsManager)
        let vc = SettingsViewController(viewModel: viewModel,
                                        coordinator: coordinator)
        
        return vc
    }
    
    func createWeb(url: URL, coordinator: Coordinator) -> WebViewController {
        let vc = WebViewController(url: url, coordinator: coordinator)
        vc.modalPresentationStyle = .formSheet
        return vc
    }
    
    func createActivityViewController(url: URL) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [url],
                                        applicationActivities: nil)
    }
    
    func createEvents(sport: String, models: [EventModel], coordinator: Coordinator) -> EventsViewController {
        let viewModel = EventsViewModel(userDefaultsManager: self.userDefaultsManager,
                                        eventModels: models)
        
        let vc = EventsViewController(title: sport,
                                      viewModel: viewModel,
                                      coordinator: coordinator)
        
        return vc
    }
    
    func createMyBets(coordinator: Coordinator) -> MyBetsViewController {
        let viewModel = MyBetsViewModel(userDefaultsManager: self.userDefaultsManager)
        
        let vc = MyBetsViewController(viewModel: viewModel,
                                      coordinator: coordinator)
        
        return vc
    }
    
    func createSuccessAlert(completion: @escaping () -> Void) -> SuccessAlertView {
        return SuccessAlertView(completion: completion)
    }
    
    func createAlert(title: String, completion: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: nil,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default) { _ in
            alertController.dismiss(animated: true)
        }
        
        let okAction = UIAlertAction(title: "Yes",
                                     style: .destructive) { _ in
            completion()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        return alertController
    }
    
    func createOnboarding(coordinator: Coordinator) -> OnboardingPageViewController {
        let viewModel = SignUpViewModel(userDefaultsManager: userDefaultsManager)
        let vc = OnboardingPageViewController(signUpViewModel: viewModel)
        vc.coordinator = coordinator
        return vc
    }
}
