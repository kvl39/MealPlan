//
//  CalendarCell.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/4/30.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {

    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
