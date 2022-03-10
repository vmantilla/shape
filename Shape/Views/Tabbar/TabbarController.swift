//
//  TabbarController.swift
//  Shape
//
//  Created by Raul Mantilla on 6/03/22.
//

import Foundation
import UIKit

class TabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupTabbarViewControllers()
    }
    
    func setupTabbarViewControllers() {
        viewControllers = [
            addNavigationController(for: BreedsListViewController(), barTitle: L10n.breeds, barImage: UIImage(systemName: "house")),
            addNavigationController(for: BreedFavoritesViewController(), barTitle: L10n.favorites, barImage: UIImage(systemName: "heart.fill"))
        ]
    }
    
    func addNavigationController(for rootViewController: UIViewController,
                                 barTitle: String,
                                 barImage: UIImage?) -> UIViewController {
        let navigationController = UINavigationController(rootViewController:  rootViewController)
        navigationController.tabBarItem.title = barTitle
        navigationController.tabBarItem.image = barImage
        navigationController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = barTitle
        return navigationController
    }
}
