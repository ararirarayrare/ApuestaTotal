//
//  PageViewController.swift
//  BetFair
//
//  Created by mac on 07.12.2022.
//

import UIKit

class OnboardingPageViewController: UIPageViewController, Coordinating {
    
    var coordinator: Coordinator?
    
    private var pages = [UIViewController]()
    
    private let skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "skip-button"), for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "next-button"), for: .normal)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.currentPage = 0
        return pageControl
    }()
    
    private var pageControlBottomConstraint: NSLayoutConstraint?
    private var skipButtonTopConstraint: NSLayoutConstraint?
    private var nextButtonTopConstraint: NSLayoutConstraint?
    
    private let signUpViewModel: SignUpViewModel
    
    init(signUpViewModel: SignUpViewModel) {
        self.signUpViewModel = signUpViewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        setup()
        layout()
    }
    
    @objc
    private func pageControlTapped(_ sender: UIPageControl) {
        goToSpecificpage(index: sender.currentPage, ofViewControllers: pages)
        animateControlsIfNeeded()
    }
    
    private func setup() {
        delegate = self
        dataSource = self
        
        let firstPage = OnboardingViewController(image: UIImage(named: "events"),
                                                 title: "Upcoming events!",
                                                 subtitle: "AP Tracker provides actual information about upcoming sports events!")
        
        let secondPage = OnboardingViewController(image: UIImage(named: "track"),
                                                 title: "Track your success!",
                                                 subtitle: "Track your bets history in a simple way!")
        
        let thirdPage = OnboardingViewController(image: UIImage(named: "explore"),
                                                 title: "Explore -> Have Fun!",
                                                 subtitle: "No real money betting, just information and analysis!")

                
        let signUpPage = SignUpViewController(coordinator: coordinator,
                                              viewModel: signUpViewModel)
        
        pages.append(firstPage)
        pages.append(secondPage)
        pages.append(thirdPage)
        pages.append(signUpPage)
        
        setViewControllers([firstPage], direction: .forward, animated: true)
        
        pageControl.numberOfPages = pages.count
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
    }
    
    private func layout() {
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: 20),
            skipButton.heightAnchor.constraint(equalToConstant: 45),
            skipButton.widthAnchor.constraint(equalToConstant: 120),
            
            
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -20),
            nextButton.heightAnchor.constraint(equalTo: skipButton.heightAnchor),
            nextButton.widthAnchor.constraint(equalTo: skipButton.widthAnchor),
            
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        skipButtonTopConstraint = skipButton.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor
        )
        nextButtonTopConstraint = nextButton.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor
        )
        pageControlBottomConstraint = pageControl.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor
        )
        
        skipButtonTopConstraint?.isActive = true
        nextButtonTopConstraint?.isActive = true
        pageControlBottomConstraint?.isActive = true
        
        hideControls()
        animateControlsIfNeeded()
    }
    
    private func animateControlsIfNeeded() {
        let lastPage = (pageControl.currentPage == pages.count - 1)

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3,
                                                       delay: 0,
                                                       options: .curveEaseOut) { [weak self] in
            lastPage ? self?.hideControls() : self?.showControls()
        }
    }
    
    private func hideControls() {
        skipButtonTopConstraint?.constant = -100
        nextButtonTopConstraint?.constant = -100
        pageControlBottomConstraint?.constant = 100
        view.layoutIfNeeded()
    }
    
    private func showControls() {
        skipButtonTopConstraint?.constant = 8
        nextButtonTopConstraint?.constant = 8
        pageControlBottomConstraint?.constant = -8
        view.layoutIfNeeded()
    }
    
    @objc
    private func nextTapped() {
        pageControl.currentPage += 1
        goToNextPage()
        animateControlsIfNeeded()
    }
    
    @objc
    private func skipTapped() {
        let lastPageIndex = pages.count - 1
        pageControl.currentPage = lastPageIndex
        
        goToSpecificpage(index: lastPageIndex, ofViewControllers: pages)
        animateControlsIfNeeded()
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let currentViewController = pageViewController.viewControllers?.first,
              let currentIndex = pages.firstIndex(of: currentViewController) else {
            return
        }
        
        pageControl.currentPage = currentIndex
        animateControlsIfNeeded()
    }
}

extension UIPageViewController {
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0],
              let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else {
            return
        }
        
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0],
              let previousPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else {
            return
        }
        
        setViewControllers([previousPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToSpecificpage(index: Int, ofViewControllers pages: [UIViewController]) {
        setViewControllers([pages[index]], direction: .forward, animated: true)
    }
}
