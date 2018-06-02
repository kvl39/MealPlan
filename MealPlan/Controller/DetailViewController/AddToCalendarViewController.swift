//
//  AddToCalendarViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/6/2.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddToCalendarViewController: UIViewController {

    
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
        cancelButton.tintColor = UIColor.gray
        configureCalendarView()
    }
    
    func configureCalendarView() {
        guard let calendarViewController = UIStoryboard(name: "MealPlan", bundle: nil).instantiateViewController(withIdentifier: "MealPlanViewController") as? MealPlanViewController else {return}
        calendarViewController.view.frame = CGRect(x: 0, y: 52.0, width: view.frame.width, height: view.frame.height-52-50)
        self.addChildViewController(calendarViewController)
        self.view.addSubview(calendarViewController.view)
        calendarViewController.isSegueFromDetaiView = true
        calendarViewController.didMove(toParentViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    @IBAction func addToCalendarButtonDidPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func cancelButtonDidPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
