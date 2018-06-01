//
//  TestViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/1.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit
import SDWebImage
import Crashlytics
import Firebase


class MealPlanViewController: MPTableViewController, AddByClassificationDelegateProtocol {

    @IBOutlet weak var testTable: UITableView!
    
    let pieChartManager = MPPieChart()
    var addButtonSelected = true
    var addButton: UIButton?
    var takePictureButton: UIButton?
    var typeButton: UIButton?
    var shareButton: UIButton?
    var addButtonRightConstraint: NSLayoutConstraint?
    var takePictureButtonRightConstraint: NSLayoutConstraint?
    var typeButtonRightConstraint: NSLayoutConstraint?
    var shareButtonRightConstraint: NSLayoutConstraint?
    let realmManager = RealmManager()
    var selectedDate = ""
    var dateManager = DataFormatManager()
    var recipeImageArray = [UIImageView]()
    var recipeTitleArray = [String]()
    var recipeToday: [RecipeCalendarRealmModel] = []
    var selectedCollectViewImageView = UIImageView()
    var firebaseManager = MPFirebaseManager()
    var saveImageManager = SaveImageManager()
    var selectedRow = 0
    lazy var addedButtonSubView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    override func viewDidLoad() {
        super.viewDidLoad()

        testTable.delegate = self
        testTable.dataSource = self

        configureTableView()
        self.view.addSubview(addedButtonSubView)
        addedButtonSubView.alpha = 0
        self.view.bringSubview(toFront: addedButtonSubView)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func editButtonDidPressed(_ sender: UIButton) {
        startPlanning(notification: nil)
        Analytics.logEvent("EditButtonDidPressed", parameters: nil)
    }
    
    
    @IBAction func createRecipeButtonDidPressed(_ sender: Any) {
        performSegue(withIdentifier: "PushToCreateRecipe", sender: self)
    }
    
    
    
    @objc func createRecipe(notification: Notification) {
        //guard let userInfo = notification.userInfo,
//            let date = userInfo["date"] as? String else {return}
        guard let userInfo = notification.userInfo,
              let image = userInfo["createdRecipeImage"] as? UIImage,
              let title = userInfo["createdRecipeTitle"] as? String else {return}
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        reloadData(addedRecipeImageView: [imageView], addedRecipeTitle: [title])
    }
    
    
    func reloadData(addedRecipeImageView: [UIImageView], addedRecipeTitle: [String]) {
        self.recipeImageArray = self.recipeImageArray + addedRecipeImageView
        self.recipeTitleArray = self.recipeTitleArray + addedRecipeTitle
        //self.recipeImageArray = addedRecipeImageView
        //self.recipeTitleArray = addedRecipeTitle
        updateDataInTableView()
        
//        let result = self.realmManager.fetchRecipe(in: self.selectedDate)
//        guard let fetchResult = result else {return}
//        self.recipeToday = fetchResult
    }

    func configureAddButton() {

        addButton = generateButtonWithConstraint(image: #imageLiteral(resourceName: "plus"), bottomConstraintConstant: -20.0)
        takePictureButton = generateButtonWithConstraint(image: #imageLiteral(resourceName: "camera"), bottomConstraintConstant: -80.0)
        typeButton = generateButtonWithConstraint(image: #imageLiteral(resourceName: "select"), bottomConstraintConstant: -140.0)
        shareButton = generateButtonWithConstraint(image: #imageLiteral(resourceName: "share"), bottomConstraintConstant: -200.0)
        addButtonRightConstraint = NSLayoutConstraint(item: addButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.rightMargin, multiplier: 1.0, constant: -20)
        takePictureButtonRightConstraint = NSLayoutConstraint(item: takePictureButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.rightMargin, multiplier: 1.0, constant: 100)
        typeButtonRightConstraint = NSLayoutConstraint(item: typeButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.rightMargin, multiplier: 1.0, constant: 100)
        shareButtonRightConstraint = NSLayoutConstraint(item: shareButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.rightMargin, multiplier: 1.0, constant: 100)

        if let addButtonRightConstraint = addButtonRightConstraint,
           let takePictureButtonRightConstraint = takePictureButtonRightConstraint,
           let typeButtonRightConstraint = typeButtonRightConstraint,
           let shareButtonRightConstraint = shareButtonRightConstraint {
            view.addConstraints([addButtonRightConstraint, takePictureButtonRightConstraint, typeButtonRightConstraint, shareButtonRightConstraint])
        }

        if let addButton = addButton {
            addButton.addTarget(self, action: #selector(addButtonInteraction), for: .touchUpInside)
        }

        typeButton?.addTarget(self, action: #selector(typeButtonInteraction(_:)), for: .touchUpInside)
        takePictureButton?.addTarget(self, action: #selector(cameraButtonInteraction(_:)), for: .touchUpInside)
        shareButton?.addTarget(self, action: #selector(shareButtonInteraction(_:)), for: .touchUpInside)

    }
    
    @objc func shareButtonInteraction(_ sender: UIButton) {
        hideButton()
        self.addButtonSelected = !self.addButtonSelected
        guard let result = self.realmManager.fetchRecipe(in: selectedDate) else {return}
        self.firebaseManager.uploadNewMenu(date: selectedDate, recipeInformation: result)
    }

    @objc func typeButtonInteraction(_ sender: UIButton) {
        hideButton()
        self.addButtonSelected = !self.addButtonSelected
        performSegue(withIdentifier: "PushToAddPage", sender: self)
    }
    
    @objc func cameraButtonInteraction(_ sender: UIButton) {
        hideButton()
        self.addButtonSelected = !self.addButtonSelected
        performSegue(withIdentifier: "PushToCameraPage", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //PushToAddPage
        if (segue.identifier == "PushToAddPage") {
            guard let vc = segue.destination as? AddPageViewController else {return}
            vc.recipeDate = selectedDate
            //vc.delegate = self
            vc.historyImageArray = self.recipeImageArray
            vc.historyTitleArray = self.recipeTitleArray
        } else if (segue.identifier == "PushToDetailPage") {
            guard let vc = segue.destination as? MPRecipeDetailViewController else {return}
            vc.displayImage = self.selectedCollectViewImageView.image
            vc.recipeData = self.recipeToday[self.selectedRow]
        } else if (segue.identifier == "PushToCameraPage") {
            guard let vc = segue.destination as? CameraViewController else {return}
            vc.selectedDate = self.selectedDate
        } else if (segue.identifier == "PushToAddByClassificationPage") {
            guard let vc = segue.destination as? AddByClassificationViewController else {return}
            vc.selectedRecipes = self.recipeToday
            vc.selectedRecipesName = self.recipeTitleArray
            vc.recipeDate = selectedDate
            vc.selectedRecipeImage = self.recipeImageArray
            vc.delegate = self
        } else if (segue.identifier == "PushToCreateRecipe") {
            guard let vc = segue.destination as? CreateRecipeStepsViewController else {return}
            vc.selectedDate = self.selectedDate
        }
    }

    @objc func addButtonInteraction(_ sender: UIButton) {
        if self.addButtonSelected {
            showButton()
        } else {
            hideButton()
        }
        self.addButtonSelected = !self.addButtonSelected
    }

    func showButton() {
        addedButtonSubView.alpha = 1
        self.view.bringSubview(toFront: addButton!)
        self.view.bringSubview(toFront: typeButton!)
        self.view.bringSubview(toFront: shareButton!)
        self.view.bringSubview(toFront: takePictureButton!)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.takePictureButton?.alpha = 1
            self.takePictureButtonRightConstraint?.constant = -20
            self.view.layoutIfNeeded()
        }, completion: nil)

        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.typeButton?.alpha = 1
            self.typeButtonRightConstraint?.constant = -20
            self.view.layoutIfNeeded()
        }, completion: nil)

        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.shareButton?.alpha = 1
            self.shareButtonRightConstraint?.constant = -20
            self.view.layoutIfNeeded()
        }, completion: nil)

    }

    func hideButton() {
        addedButtonSubView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.takePictureButton?.alpha = 0
            self.typeButton?.alpha = 0
            self.shareButton?.alpha = 0

            self.takePictureButtonRightConstraint?.constant = 100
            self.typeButtonRightConstraint?.constant = 100
            self.shareButtonRightConstraint?.constant = 100
            self.view.layoutIfNeeded()
        }
    }

    func generateButtonWithConstraint(image: UIImage, bottomConstraintConstant: CGFloat) -> UIButton {

        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 201/255.0, green: 132/255.0, blue: 116/255.0, alpha: 1.0)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = button.frame.size.width / 2
        button.layer.masksToBounds = true

        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        self.view.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        let widthConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        let bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: bottomConstraintConstant)
        view.addConstraints([heightConstraint, widthConstraint, bottomConstraint])
        return button
    }

    func configureTableView() {
        self.testTable.separatorStyle = .none
        
        testTable.register(UINib(nibName: "CalendarCollectionView", bundle: nil), forCellReuseIdentifier: "CalendarCollectionView")
        testTable.register(UINib(nibName: "HorizontalCollectionView",
                                 bundle: nil), forCellReuseIdentifier: "HorizontalCollectionView")
        testTable.register(UINib(nibName: "RecipeNoteView", bundle: nil), forCellReuseIdentifier: "RecipeNoteView")
        self.rowArray.append([])
        self.rowArray[0].append(.calendarCollectionViewType)
       
       self.rowArray[0].append(.horizontalCollectionViewType([], []))

        NotificationCenter.default.addObserver(self, selector: #selector(onSelectDate(notification:)), name: NSNotification.Name(rawValue: "SelectDate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSelectCollectionViewItem(notification:)), name: NSNotification.Name(rawValue: "collectionViewItemDidSelect"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createRecipe(notification:)), name: NSNotification.Name(rawValue: "CreatedRecipe"), object: nil)
        //collectionViewHintButtonDidPressed
        NotificationCenter.default.addObserver(self, selector: #selector(startPlanning(notification:)), name: NSNotification.Name(rawValue: "collectionViewHintButtonDidPressed"), object: nil)
    }
    
    @objc func startPlanning(notification: Notification?) {
        performSegue(withIdentifier: "PushToAddByClassificationPage", sender: self)
    }
    
    @objc func onSelectCollectionViewItem(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let imageView = userInfo["imageView"] as? UIImageView,
            let selectedRow = userInfo["row"] as? Int else {return}
        self.selectedCollectViewImageView = imageView
        self.selectedRow = selectedRow
        let result = self.realmManager.fetchRecipe(in: self.selectedDate)
        guard let fetchResult = result else {return}
        self.recipeToday = fetchResult
        print("selected:\(self.selectedRow)")
        self.performSegue(withIdentifier: "PushToDetailPage", sender: self)
    }

    func generateViewWithImage(image: UIImage) -> UIView {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49.5))
        imageView.image = image
        return imageView
    }

    @objc func onSelectDate(notification: Notification) {
        self.recipeTitleArray = []
        self.recipeImageArray = []
        guard let userInfo = notification.userInfo,
              let date = userInfo["date"] as? String else {return}
        print(date)
        self.selectedDate = date
        fetchDataInDate(in: date)
        updateDataInTableView()
    }
    
    
    func fetchDataInDate(in date: String) {
        let result = self.realmManager.fetchRecipe(in: date)
        //print(result)
        //select date -> show data in card
        guard let fetchResult = result else {return}
        self.recipeToday = fetchResult
        for recipe in fetchResult {
            if recipe.withSteps == false {
                guard let recipeLabel = recipe.recipeRealmModel?.label,
                    let recipeImageURL = recipe.recipeRealmModel?.image else {return}
                
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49.5))
                imageView.contentMode = .scaleAspectFill
                imageView.sd_setImage(with: URL(string: recipeImageURL), placeholderImage: #imageLiteral(resourceName: "dish"), options: .retryFailed) { (_, error, _, _) in
                    guard let error = error else {return}
                    print(error)
                }
                
                self.recipeTitleArray.append(recipeLabel)
                self.recipeImageArray.append(imageView)
            } else {
                guard let recipeLabel = recipe.recipeRealmModelWithSteps?.label,
                      let recipeImageName = recipe.recipeRealmModelWithSteps?.image else {return}
                let recipeImage = self.saveImageManager.getSavedImage(imageFileName: recipeImageName)
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49.5))
                imageView.image = recipeImage
                imageView.contentMode = .scaleAspectFill
                self.recipeTitleArray.append(recipeLabel)
                self.recipeImageArray.append(imageView)
            }
            
        }
        
    }

    func updateDataInTableView() {
        self.rowArray[0][1] = .horizontalCollectionViewType(recipeImageArray, recipeTitleArray)

        var indexPath = IndexPath(row: 1, section: 0)
        guard let cell = self.testTable.cellForRow(at: indexPath) as? HorizontalCollectionView else {return}
        cell.horizontalCollectionView.reloadData()
        self.testTable.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch: UITouch? = touches.first
        if touch?.view == addedButtonSubView {
            hideButton()
            self.addButtonSelected = !self.addButtonSelected
        }
    }
    
    
}


extension MealPlanViewController: ZoomingViewController {
    
    func zoomingImageView() -> UIImageView? {
        return self.selectedCollectViewImageView
    }
}
