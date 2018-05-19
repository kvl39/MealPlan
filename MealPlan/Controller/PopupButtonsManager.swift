//
//  PopupButtonsManager.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/19.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class PopupButtonManager {
    
    var popupButtonBottomConstraints: [NSLayoutConstraint?] = []
    var popupButtons: [UIButton] = []
    var mainButtonSelected = false
    
    
    
    func addButton(with imageArray: [UIImage], on view: UIView)->[UIButton] {
        for image in imageArray {
            generateButtonWithConstraint(with: image, on: view)
        }
        for index in 1...popupButtons.count-1 {
            popupButtons[index].alpha = 0
        }
        return self.popupButtons
    }
    
    
    
    func showButtons(on view: UIView) {
        let duration = 0.25 * Double(popupButtons.count)
        for index in 1...popupButtons.count-1 {
            UIView.animate(withDuration: duration - Double(index)*0.1, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                self.popupButtons[index].alpha = 1
                self.popupButtonBottomConstraints[index]?.constant = CGFloat(-40 - index*60)
                view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    
    
    func hideButtons(on view: UIView) {
        let duration = 0.2 * Double(popupButtons.count)
        for index in 1...popupButtons.count-1 {
            UIView.animate(withDuration: duration - Double(index)*0.1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                self.popupButtons[index].alpha = 0
                self.popupButtonBottomConstraints[index]?.constant = CGFloat(-40)
                view.layoutIfNeeded()
            })
        }
    }
    
    
    
    func generateButtonWithConstraint(with image: UIImage, on view: UIView) {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 201/255.0, green: 132/255.0, blue: 116/255.0, alpha: 1.0)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        view.addSubview(button)
        self.popupButtons.append(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            ])
        let bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: -40)
        view.addConstraints([bottomConstraint])
        self.popupButtonBottomConstraints.append(bottomConstraint)
    }
    
}
