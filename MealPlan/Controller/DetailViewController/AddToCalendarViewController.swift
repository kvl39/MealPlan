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
    var calendarViewController: UIViewController?
    var realmManager = RealmManager()
    var recipeData: [RecipeCalendarRealmModel]!
    var dateManager = DataFormatManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
        cancelButton.tintColor = UIColor.gray
        configureCalendarView()
    }
    
    func configureCalendarView() {
        calendarViewController = UIStoryboard(name: "MealPlan", bundle: nil).instantiateViewController(withIdentifier: "MealPlanViewController") as? MealPlanViewController
        guard let calendarVC = calendarViewController as? MealPlanViewController else {return}
        calendarVC.view.frame = CGRect(x: 0, y: 52.0, width: view.frame.width, height: view.frame.height-52-50)
        self.addChildViewController(calendarVC)
        self.view.addSubview(calendarVC.view)
        calendarVC.isSegueFromDetaiView = true
        calendarVC.didMove(toParentViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    @IBAction func addToCalendarButtonDidPressed(_ sender: UIButton) {
        guard let calendarVC = calendarViewController as? MealPlanViewController else {return}
        var recipeArrayInCalendarFormat = [RecipeCalendarRealmModel]()
        guard let addDate = self.dateManager.stringToDate(dateString: calendarVC.selectedDate, to: "yyyy MM dd") else {return}
        for eachRecipeData in recipeData {
            eachRecipeData.recipeDay = addDate
            recipeArrayInCalendarFormat.append(eachRecipeData)
        }
        realmManager.saveAddedRecipeInCalendarFormat(recipeArray: recipeArrayInCalendarFormat)
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchViewAddRecipe"), object: nil, userInfo: [:])
    }
    
    @IBAction func cancelButtonDidPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
