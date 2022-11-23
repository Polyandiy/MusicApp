//
//  MainTabBarController.swift
//  MusicApp
//
//  Created by Поляндий on 23.11.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        
        viewControllers = [
            generateVC(rootVC: SearchMusicViewController(), image: UIImage(systemName: "magnifyingglass")!, title: "Search"),
            generateVC(rootVC: ViewController(), image: UIImage(systemName: "music.note.list")!, title: "Library")]
    }
    
    private func generateVC(rootVC: UIViewController, image: UIImage, title: String) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootVC.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }
}
