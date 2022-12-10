import UIKit

enum Event {
    case dismiss, pop, toRoot, successAlert(() -> Void), alert(String, () -> Void )
    case settings, myBets, web(URL), share(URL), events(String, [EventModel])
}

protocol Coordinator {
    var navigationController: UINavigationController { get }
    var builder: Builder { get }
    var window: UIWindow? { get }
    init(window: UIWindow?, navigationController: UINavigationController, builder: Builder)
//    var children: [Coordinator] { get set }
    
    func eventOccured(_ event: Event)
    func start()
    func onboard()
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var builder: Builder
    
    var window: UIWindow?
    
    private(set) var viewControllers: [UIViewController]?
    
    required init(window: UIWindow?, navigationController: UINavigationController, builder: Builder) {
        self.navigationController = navigationController
        self.builder = builder
        self.window = window
    }
    
    func eventOccured(_ event: Event) {
        switch event {
        case .settings:
            let profileViewController = builder.createSettings(coordinator: self)
            navigationControllerPush(profileViewController, animated: true)
            
        case .myBets:
            let myBetsViewController = builder.createMyBets(coordinator: self)
            myBetsViewController.modalPresentationStyle = .custom
            myBetsViewController.transitioningDelegate = (viewControllers?.last as? BaseVC)
            present(myBetsViewController, animated: true)
//            navigationControllerPush(myBetsViewController, animated: true)
            
        case .events(let sport, let eventModels):
            let eventsViewController = builder.createEvents(sport: sport,
                                                            models: eventModels,
                                                            coordinator: self)
            navigationControllerPush(eventsViewController, animated: true)
            
        case .web(let url):
            let webViewController = builder.createWeb(url: url, coordinator: self)
            viewControllers?.last?.present(webViewController, animated: true)
            
        case .share(let url):
            let activityVC = builder.createActivityViewController(url: url)
            viewControllers?.last?.present(activityVC, animated: true)
            
        case .dismiss:
            dismissLast(animated: true)
        case .pop:
            navigationControllerPopLast(animated: true)
        case .toRoot:
            popToRoot(animated: true)
        case .successAlert(let completion):
            let successView = builder.createSuccessAlert(completion: completion)
            navigationController.view.window?.addSubview(successView)
            
        case .alert(let title, let completion):
            let alertController = builder.createAlert(title: title, completion: completion)
            viewControllers?.last?.present(alertController, animated: true)
        }
    }
    
    func onboard() {
        let vc = builder.createOnboarding(coordinator: self)
        window?.rootViewController = vc
    }
    
    func start() {
        let vc = builder.createMain(coordinator: self)
        navigationController.viewControllers = [vc]
        viewControllers = [vc]
        
        window?.rootViewController = navigationController
    }
    
    private func navigationControllerPush(_ vc: UIViewController, animated: Bool) {
        navigationController.pushViewController(vc, animated: animated)
    }
    
    private func present(_ vc: BaseVC, animated: Bool) {
        viewControllers?.last?.present(vc, animated: animated)
        viewControllers?.append(vc)
    }
    
    private func dismissLast(animated: Bool) {
        viewControllers?.removeLast().dismiss(animated: animated)
    }
    
    private func navigationControllerPopLast(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    private func popToRoot(animated: Bool) {
        guard let first = viewControllers?.first else {
            return
        }
        
        viewControllers = [first]
        navigationController.dismiss(animated: animated)
        navigationController.popToRootViewController(animated: animated)
    }
}
