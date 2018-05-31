//
//  AddRecipeStepViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/31.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

protocol AddRecipeStepProtocol: class {
    func reloadTableViewRow(stepImage: UIImage, stepDescription: String, row: Int)
}

class AddRecipeStepViewController: UIViewController {


    var embeddedViewControllers: [UIViewController] = [] //0:textView, 1: imagePicker
    weak var delegate: AddRecipeStepProtocol?
    var row: Int = 0
    var presetImage: UIImage?
    var presetDescription: String?
    var textViewPresetTextColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetFrame()
        configureTextViewHints()
        configurePresets()
    }
    
    
    func configurePresets() {
        if let image = presetImage, let description = presetDescription, let color = textViewPresetTextColor {
            if let vc = embeddedViewControllers[0] as? InputTextViewController {
                vc.textView.text = description
                vc.textView.textColor = color
                vc.hasPresetColor = true
            }
            if let vc = embeddedViewControllers[1] as? ImagePickerViewController{
                vc.image.image = image
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbeddedRecipeStepDescription" {
            if let vc = segue.destination as? InputTextViewController {
                embeddedViewControllers.append(vc)
                vc.showSeparationLine = false
            }
        } else if segue.identifier == "EmbeddedRecipeStepImage" {
            if let vc = segue.destination as? ImagePickerViewController {
                embeddedViewControllers.append(vc)
            }
        }
    }
    
    func configureTextViewHints() {
        if let vc = embeddedViewControllers[0] as? InputTextViewController {
            vc.textViewHint = "Add recipe step description"
            vc.configureTextFieldEmpty()
        }
    }
    
    func resetFrame() {
        if let vc = embeddedViewControllers[0] as? InputTextViewController {
            vc.resetFrame()
        }
        if let vc = embeddedViewControllers[1] as? ImagePickerViewController {
            vc.resetFrame()
        }
    }
    
    @IBAction func finishEditingRecipeStep(_ sender: UIButton) {
        var stepDescription = ""
        var stepImage = UIImage()
        if let vc = embeddedViewControllers[0] as? InputTextViewController {
            stepDescription = vc.textView.text
        }
        if let vc = embeddedViewControllers[1] as? ImagePickerViewController,
            let image = vc.image.image{
            stepImage = image
        }
        
        self.delegate?.reloadTableViewRow(stepImage: stepImage, stepDescription: stepDescription, row: self.row)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    

}
