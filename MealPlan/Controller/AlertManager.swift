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
    
    
    func showHint(on view: UIView, with hintContent: String, completion: @escaping ()-> Void) {
        let hintView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        hintView.backgroundColor = UIColor(red: 26/255.0, green: 33/255.0, blue: 42/255.0, alpha: 1)
        hintView.layer.cornerRadius = 20
        hintView.clipsToBounds = true
        view.addSubview(hintView)
        hintView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hintView.heightAnchor.constraint(equalToConstant: 40),
            hintView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            hintView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
            ])
        let bottomConstraint = NSLayoutConstraint(item: hintView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: 40)
        view.addConstraints([bottomConstraint])
        view.layoutIfNeeded()
        let hintLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        hintLabel.frame = hintView.bounds
        hintLabel.text = hintContent
        hintLabel.textColor = UIColor.white
        hintLabel.font = UIFont(name: "PingFang TC", size: 13.0)
        hintLabel.textAlignment = .center
        hintView.addSubview(hintLabel)
        
        UIView.animate(withDuration: 0.5, animations: {
            bottomConstraint.constant = -50
            view.layoutIfNeeded()
        }) { (bool) in
            UIView.animate(withDuration: 0.5, delay: 2, options: [], animations: {
                bottomConstraint.constant = 40
                view.layoutIfNeeded()
            }, completion: { (bool1) in
                hintView.removeFromSuperview()
                completion()
            })
        }
        
//        UIView.animate(withDuration: 0.5, animations: {
//            bottomConstraint.constant = -80
//        }) { (bool) in
//            UIView.animate(withDuration: 0.5, delay: 10, options: [], animations: {
//                bottomConstraint.constant = 40
//            }, completion: { (bool1) in
//                hintView.removeFromSuperview()
//                completion()
//            })
//        }
    }
}
