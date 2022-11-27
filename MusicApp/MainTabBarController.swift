//
//  MainTabBarController.swift
//  MusicApp
//
//  Created by Поляндий on 23.11.2022.
//

import UIKit
import SwiftUI

protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailController()
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    private var minTopAncorConstraint: NSLayoutConstraint!
    private var maxTopAncorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    let trackDetailView: TrackDetailView = TrackDetailView.loadNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        tabBar.backgroundColor = .white
        
        var library = Library()
        library.tabBarDelegate = self
        let hostVC = UIHostingController(rootView: library)
        hostVC.tabBarItem.image = UIImage(systemName: "music.note.list")
        hostVC.tabBarItem.title = "Library"
        
        viewControllers = [
            generateVC(rootVC: searchVC, image: UIImage(systemName: "magnifyingglass")!, title: "Search"),
            hostVC]
        setupTrackDetailView()
        
        searchVC.tabBarDelegate = self
    }
    
    private func generateVC(rootVC: UIViewController, image: UIImage, title: String) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootVC.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }
    
    private func setupTrackDetailView() {
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maxTopAncorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minTopAncorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        //trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        maxTopAncorConstraint.isActive = true
        bottomAnchorConstraint.isActive = true
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {
    
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
        minTopAncorConstraint.isActive = false
        maxTopAncorConstraint.isActive = true
        maxTopAncorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
            self.trackDetailView.miniTrackView.alpha = 0
            self.trackDetailView.maximizedStackView.alpha = 1
        },
                       completion: nil)
        guard let viewModel = viewModel else { return }
        self.trackDetailView.set(viewModel: viewModel)
    }
    
    func minimizeTrackDetailController() {
        maxTopAncorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minTopAncorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
            self.trackDetailView.miniTrackView.alpha = 1
            self.trackDetailView.maximizedStackView.alpha = 0
        },
                       completion: nil)
    }
}
