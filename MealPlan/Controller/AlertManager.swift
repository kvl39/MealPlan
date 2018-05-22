//
//  AlertManager.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/22.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AlertManager {
    
    func showAlert(viewController: UIViewController) {
        let alertController = UIAlertController(
            title: "Warning",
            message: "有地方空白",
            preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(
            title: "確認",
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                print("按下確認後，閉包裡的動作")
        })
        alertController.addAction(okAction)
        
        viewController.present(
            alertController,
            animated: true,
            completion: nil)
    }
}
