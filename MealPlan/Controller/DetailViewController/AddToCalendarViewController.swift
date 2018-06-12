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
        calendarVC.view.frame = CGRect(x: 0, y: 70.0, width: view.frame.width, height: view.frame.height-70-50)
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
            let newRecipeData = RecipeCalendarRealmModel()
            newRecipeData.recipeDay = addDate
            newRecipeData.recipeRealmModelWithSteps = eachRecipeData.recipeRealmModelWithSteps
            newRecipeData.recipeRealmModel = eachRecipeData.recipeRealmModel
            newRecipeData.withSteps = eachRecipeData.withSteps
            recipeArrayInCalendarFormat.append(newRecipeData)
        }
        realmManager.saveAddedRecipeInCalendarFormat(recipeArray: recipeArrayInCalendarFormat)
        
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchViewAddRecipe"), object: nil, userInfo: ["date": addDate,"recipeData":recipeData])
    }
    
    @IBAction func cancelButtonDidPressed(_ sender: UIButton) {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    

}
