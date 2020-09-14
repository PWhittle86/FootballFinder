//
//  MainCoordinator.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import UIKit

/*
 A coordinator is overkill for a project of this size with only 2 view controller, but as it provides a solid framework to help reduce the load on view
 controllers and helps to make app growth more scalable and managable, I decided to keep it a part of the project.
 */

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    var navigationController = UINavigationController()
    var childCoordinators = [Coordinator]()
    
    init(navController: UINavigationController) {
        self.navigationController = navController
    }
    
    func start() {
        let teamSearchVC = TeamSearchViewController()
        teamSearchVC.coordinator = self
        navigationController.pushViewController(teamSearchVC, animated: false)
        navigationController.delegate = self
    }
    
    func navigateToFavouritesController() {
        let favouritesController = FavouritesTableViewController()
        self.navigationController.pushViewController(favouritesController, animated: true)
    }
    
}
