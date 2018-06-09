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
    
    
    func showAlertForCamera(viewController: UIViewController) {
        let alertController = UIAlertController(
            title: "Warning",
            message: "Retake Photo",
            preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(
            title: "Yes",
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
    
    
    func showAlertForPhoto(viewController: UIViewController) {
        let alertController = UIAlertController(
            title: "Warning",
            message: "Please take a Photo for the recipe",
            preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(
            title: "OK",
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
    
    func showAlert(viewController: UIViewController, text: String) {
        let alertController = UIAlertController(
            title: "Warning",
            message: text,
            preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(
            title: "OK",
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
    
    
    func showShareActionSheet(viewController: UIViewController, date:String, shareFunction: @escaping ()-> Void) {
        let optionMenu = UIAlertController(title: nil, message: "share my \(date) menu", preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Confirm", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            //share to the internet
            shareFunction()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(shareAction)
        optionMenu.addAction(cancelAction)
        
        viewController.present(optionMenu, animated: true, completion: nil)
    }
}
