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
    //case shoppingList
    
    func controller()->UIViewController {
        switch self {
        case .plan: return UIStoryboard(name: "MealPlan", bundle: nil).instantiateInitialViewController()!
        case .search: return UIStoryboard(name: "Search", bundle: nil).instantiateInitialViewController()!
        }
    }
    
    func image() -> UIImage {
        switch self {
        case .plan: return #imageLiteral(resourceName: "Icon-App-40x40")
        case .search: return #imageLiteral(resourceName: "binoculars")
        }
    }
    
    func selectedImage() -> UIImage {
        switch self {
        case .plan: return #imageLiteral(resourceName: "Icon-App-40x40").withRenderingMode(.alwaysTemplate)
        case .search: return #imageLiteral(resourceName: "binoculars").withRenderingMode(.alwaysTemplate)
        }
    }
}


class MPTabBarController: UITabBarController {
    
    let tabs: [TabBar] = [.plan, .search]
    
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
