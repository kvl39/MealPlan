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
    func updateTableView(newHeight: CGFloat, section: Int, row: Int)
}


class InputTextViewController: UIViewController, UITextViewDelegate {

    let textView = UITextView()
    weak var delegate: InputTextViewControllerDelegate?
    var section = 0
    var row = 0
    var textViewHint = ""
    var drawLineManager = DrawCameraLineManager()
    var separationLine = CAShapeLayer()
    var showSeparationLine = true
    var hasPresetColor = false
    var useNumberKeyboard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = textViewHint
        if hasPresetColor {
            textView.textColor = UIColor.black
        } else {
            textView.textColor = UIColor.gray
        }
        
        self.view.addSubview(textView)
        textView.isScrollEnabled = false
//        NSLayoutConstraint.activate([
//            textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
//            textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
//            textView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
//            textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
//            ])
//        textView.backgroundColor = UIColor.brown
//        self.view.backgroundColor = UIColor.yellow
        resetFrame()
        //textView.layer.borderColor = UIColor.black.cgColor
        //textView.layer.borderWidth = 1
        textView.font = UIFont(name: "PingFang TC", size: 17)
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 15, bottom: 0, right: 0)
    }
    
    func resetKeyboard() {
        if self.useNumberKeyboard {
            self.textView.keyboardType = UIKeyboardType.decimalPad
        }
    }
    
    func resetFrame() {
        textView.frame = self.view.frame
        drawSeperation()
    }
    
    func drawSeperation() {
        separationLine.removeFromSuperlayer()
        if self.showSeparationLine {
            separationLine = drawLineManager.drawOneLine(on: self.view.layer,
                                                         startPoint: CGPoint(x: 0, y: self.view.frame.height),
                                                         stopPoint: CGPoint(x: self.view.frame.width, y: self.view.frame.height), color: UIColor.gray.cgColor)
        }
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        configureTextFieldEmpty()
    }
    
    func configureTextFieldEmpty() {
        if textView.text.isEmpty {
            textView.text = textViewHint
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
            self.delegate?.updateTableView(newHeight: 243 + heightDiff, section: self.section, row: self.row)
            drawSeperation()
            if let parentVC = self.parent as? AddRecipeStepsViewController {
                parentVC.setRecipeTitleTextViewHeight(newHeight: newSize.height)
            }
            if let parentVC = self.parent as? AddByClassificationViewController {
                parentVC.updateTextViewHeight(newHeight: newSize.height)
            }
        }
    }
    
    
}
