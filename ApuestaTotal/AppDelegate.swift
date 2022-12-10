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
        
        return true
    }
    
    @objc
    private func hideKeybard() {
        window?.endEditing(true)
    }
    
}
