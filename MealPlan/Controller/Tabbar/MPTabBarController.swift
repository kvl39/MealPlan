//
//  MPTabBarController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/19.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

enum TabBar {
    case plan
    case search
    case discovery
    //case shoppingList
    
    func controller()->UIViewController {
        switch self {
        case .plan: return UIStoryboard(name: "MealPlan", bundle: nil).instantiateInitialViewController()!
        case .search: return UIStoryboard(name: "Search", bundle: nil).instantiateInitialViewController()!
        case .discovery: return UIStoryboard(name: "Discovery", bundle: nil).instantiateInitialViewController()!
        }
    }
    
    func image() -> UIImage {
        switch self {
        case .plan: return #imageLiteral(resourceName: "Calendar2")
        case .search: return #imageLiteral(resourceName: "Icon-App-29x29-2")
        case .discovery: return #imageLiteral(resourceName: "Icon-App-29x29-1")
        }
    }
    
    func selectedImage() -> UIImage {
        switch self {
        case .plan: return #imageLiteral(resourceName: "Calendar2").withRenderingMode(.alwaysTemplate)
        case .search: return #imageLiteral(resourceName: "Icon-App-29x29-2").withRenderingMode(.alwaysTemplate)
        case .discovery: return #imageLiteral(resourceName: "Icon-App-29x29-1").withRenderingMode(.alwaysTemplate)
        }
    }
}


class MPTabBarController: UITabBarController {
    
    let tabs: [TabBar] = [.plan, .search, .discovery]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    func setupTabs() {
        var controllers: [UIViewController] = []
        tabBar.tintColor = UIColor(red: 249/255.0, green: 168/255.0, blue: 37/255.0, alpha: 1)
        for tab in tabs {
            let controller = tab.controller()
            let item = UITabBarItem(
                title: nil, image: tab.image(), selectedImage: tab.selectedImage())
            item.imageInsets = UIEdgeInsetsMake(2, 0, -10, 0)
            controller.tabBarItem = item
            controllers.append(controller)
        }
        setViewControllers(controllers, animated: false)
    }


}
