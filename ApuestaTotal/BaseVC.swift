import UIKit
import Combine

class BaseVC: UIViewController, Coordinating, UIViewControllerTransitioningDelegate {
    
    var cancellables = Set<AnyCancellable>()
    
    var coordinator: Coordinator?
    
    init(coordinator: Coordinator?) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBackgroundImage() {
        let bg = UIImageView(frame: view.bounds)
        bg.contentMode = .scaleToFill
        bg.image = UIImage(named: "bg-main")
        view.addSubview(bg)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController(presentedViewController: presented,
                                                            presenting: presenting)
        presentationController.coordinator = coordinator
        return presentationController
    }
}

class BaseNC: UINavigationController {
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationBar.isHidden = true
        
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            .font : UIFont(name: "Jost-Bold", size: 32) ?? .boldSystemFont(ofSize: 28),
            .foregroundColor : UIColor.white
        ]
        appearance.titleTextAttributes = [
            .foregroundColor : UIColor.white
        ]
        appearance.backgroundColor = .clay
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
    }
}
