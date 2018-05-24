//
//  TextViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/21.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol InputTextViewControllerDelegate: class {
    func updateTableView(newHeight: CGFloat, serialNumber: Int)
}


class InputTextViewController: UIViewController, UITextViewDelegate {

    let textView = UITextView()
    weak var delegate: InputTextViewControllerDelegate?
    var serialNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = "填入步驟說明"
        //textView.textColor = UIColor.gray
        self.view.addSubview(textView)
        textView.isScrollEnabled = false
//        NSLayoutConstraint.activate([
//            textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
//            textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
//            textView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
//            textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
//            ])
        textView.backgroundColor = UIColor.brown
        self.view.backgroundColor = UIColor.yellow
        resetFrame()
    }
    
    
    
    func resetFrame() {
        textView.frame = self.view.frame
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "填入步驟說明"
            textView.textColor = UIColor.gray
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        //textView.translatesAutoresizingMaskIntoConstraints = true
        //textView.sizeToFit()
        //self.view.frame = textView.frame
        //print("textView height:\(textView.frame.size.height)")
        UIView.performWithoutAnimation {
            let newSize = textView.sizeThatFits(
                CGSize(width: textView.bounds.size.width,
                       height: .greatestFiniteMagnitude))
            let heightDiff = max(newSize.height - 88.5, 0)
            textView.frame.size = CGSize(width: textView.bounds.width, height: newSize.height)
            self.view.frame.size = textView.frame.size
            self.view.layoutIfNeeded()
            IQKeyboardManager.shared.reloadLayoutIfNeeded()
            self.delegate?.updateTableView(newHeight: 243 + heightDiff, serialNumber: self.serialNumber)
        }
    }
    
    
}
