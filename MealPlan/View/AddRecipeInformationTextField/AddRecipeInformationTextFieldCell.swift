//
//  AddRecipeInformationTextFieldCell.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/20.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddRecipeInformationTextFieldCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textFieldLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddRecipeInformationTextFieldDidEndEditing"), object: nil, userInfo: ["text": text])
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
