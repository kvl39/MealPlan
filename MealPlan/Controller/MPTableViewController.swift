//
//  MPTableViewController.swift
//
//
//  Created by Liao Kevin on 2018/5/1.
//

import UIKit

enum MPTableViewCellType {
    case horizontalCollectionViewType([UIView], [String])
    case calendarCollectionViewType
    case recipeCellType(UIImage, String)
    case recipeSearchCellType(String?, UIImage?, String, Bool, Bool)
    case recipeNoteType
    case textFieldType(String, String)
    case recipeStepType
    case sliderType(Float, String, String)
    case nutrientsEditType
    case recipeIngredientType(String)
    case recipeStepTableViewCellType(String, UIImage)
    case recipeIngredientEditType
    case addIngredientType
    case monthType(String)
    case weekType(String)
    case dayType(String, String, [UIView], Date)
}

extension MPTableViewCellType {
    func configureCell() -> MPTableViewCellProtocol {
        switch (self) {
        case .horizontalCollectionViewType(let imageArray, let titleArray): return HorizontalCollectionViewItem(viewArray: imageArray, titleArray: titleArray)
        case .calendarCollectionViewType: return CalendarViewItem()
        case .recipeCellType(let image, let title):
            return RecipeCellItem(image: image, title: title)
        case .recipeSearchCellType(let imageURL, let image, let title, let selected, let isInsertImage):
            return RecipeSearchCellItem(imageURL: imageURL, image: image, title: title, selected: selected, isInsertImage: isInsertImage)
        case .recipeNoteType:
            return RecipeNoteViewItem()
        case .textFieldType(let textFieldLabel, let textFieldPlaceHolder):
            return TextFieldItem(textFieldLabel: textFieldLabel, textFieldPlaceHolder: textFieldPlaceHolder)
        case .recipeStepType:
            return RecipeStepItem()
        case .sliderType(let sliderMax, let sliderDescription, let sliderUnit):
            return SliderItem(slidermax: sliderMax,
                              sliderDescription: sliderDescription,
                              sliderUnit: sliderUnit)
        case .nutrientsEditType:
            return NutrientsEditItem()
        case .recipeIngredientType(let ingredientText):
            return RecipeIngredientItem(ingredientText: ingredientText)
        case .recipeStepTableViewCellType(let recipeDescription, let recipeStepImage):
            return RecipeStepTableViewItem(recipeStepDescription: recipeDescription, recipeStepImage: recipeStepImage)
        case .recipeIngredientEditType:
            return RecipeIngredientEditItem()
        case .addIngredientType:
            return AddIngredientItem()
        case .monthType(let labelText):
            return MonthItem(labelText: labelText)
        case .weekType(let labelText):
            return WeekItem(labelText: labelText)
        case .dayType(let dayLabelText, let weekDayLabelText, let viewArray, let today):
            return DayItem(dayLabel: dayLabelText, weekDayLabel: weekDayLabelText, viewArray: viewArray, today: today)
        }
    }
}

protocol MPTableViewCellProtocol {
    //var cell: UITableViewCell {get}
    var reuseIdentifier: String {get}
    var rowHeight: Int {get}
}

enum HorizontalCollectionViewItemType {
    case imageType
    case chartType
}

struct HorizontalCollectionViewItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "HorizontalCollectionView"
    var rowHeight: Int = 250
    var viewArray: [UIView] = []
    var titleArray: [String] = []

    init(viewArray: [UIView] = [], titleArray: [String] = []) {
        self.viewArray = viewArray
        self.titleArray = titleArray
    }
}

struct CalendarViewItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "CalendarCollectionView"
    var rowHeight: Int = 280
}

struct RecipeCellItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "RecipeTableViewCell"
    var rowHeight: Int = 80
    var image: UIImage?
    var title: String = ""

    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
}

struct RecipeSearchCellItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "RecipeSearchResultCell"
    var rowHeight: Int = 300
    var image: UIImage?
    var title: String = ""
    var selected: Bool = false
    var isInsertImage: Bool = false
    var imageURL: String?

    init(imageURL: String?, image: UIImage?, title: String, selected: Bool, isInsertImage: Bool) {
        self.image = image
        self.imageURL = imageURL
        self.title = title
        self.selected = selected
        self.isInsertImage = isInsertImage
    }
}

struct RecipeNoteViewItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "RecipeNoteView"
    var rowHeight: Int = 300
}

struct TextFieldItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "AddRecipeInformationTextFieldCell"
    var rowHeight: Int = 50
    var textFieldLabel: String = ""
    var textFieldPlaceHolder: String = ""
    
    init(textFieldLabel: String, textFieldPlaceHolder: String) {
        self.textFieldLabel = textFieldLabel
        self.textFieldPlaceHolder = textFieldPlaceHolder
    }
}

struct RecipeStepItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "AddRecipeInformationTextFieldWithImageCell"
    var rowHeight: Int = 243
    var imagePickerViewController = ImagePickerViewController()
    var inputTextViewController = InputTextViewController()
}

struct RecipeStepTableViewItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "RecipeStepTableViewCell"
    var rowHeight: Int = 250
    var recipeStepDescription = ""
    var recipeStepImage = UIImage()
    
    init(recipeStepDescription: String, recipeStepImage: UIImage) {
        self.recipeStepDescription = recipeStepDescription
        self.recipeStepImage = recipeStepImage
    }
}

struct SliderItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "AddRecipeInformationSliderCell"
    var rowHeight: Int = 100
    var slidermax: Float = 100.0
    var sliderController = SliderViewController()
    var sliderDescription = ""
    var sliderUnit = ""
    
    init(slidermax: Float, sliderDescription: String, sliderUnit: String) {
        self.slidermax = slidermax
        self.sliderDescription = sliderDescription
        self.sliderUnit = sliderUnit
    }
}

struct NutrientsEditItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "NutrientsEditCell"
    var rowHeight: Int = 100
}

struct RecipeIngredientItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "RecipeDetailIngredientCell"
    var rowHeight: Int = 52
    var ingredientText: String = ""
    
    init(ingredientText: String) {
        self.ingredientText = ingredientText
    }
}


struct RecipeIngredientEditItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "IngredientEditTableViewCell"
    var rowHeight: Int = 50
}

struct AddIngredientItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "MPIngredientAddButtonTableViewCell"
    var rowHeight: Int = 50
}

struct MonthItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "MonthTableViewCell"
    var rowHeight: Int = 100
    var labelText: String = ""
    
    init(labelText: String) {
        self.labelText = labelText
    }
}

struct WeekItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "WeekTableViewCell"
    var rowHeight: Int = 35
    var labelText: String = ""
    
    init(labelText: String) {
        self.labelText = labelText
    }
}

struct DayItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "DayTableViewCell"
    var rowHeight: Int = 200
    var dayLabel: String = ""
    var weekDayLabel: String = ""
    var viewArray: [UIView] = []
    var today =  Date()
    
    init(dayLabel: String, weekDayLabel: String, viewArray: [UIView], today: Date) {
        self.dayLabel = dayLabel
        self.weekDayLabel = weekDayLabel
        self.viewArray = viewArray
        self.today = today
    }
}

class MPTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, InputTextViewControllerDelegate {
    var sectionArray: [String] = []
    var rowArray: [[MPTableViewCellType]] = []
    var rowControllerArray : [[UIViewController]] = []
    var rowControllerIndexDic : [IndexPath : Int] = [:]
    var hintLabels = HintLabels()
    //weak var delegate: MPTableViewControllerDelegateProtocol?
    func updateTableView(newHeight: CGFloat, section: Int, row: Int) {}
}

extension MPTableViewController {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sectionArray.count > 0 {
            return sectionArray[section]
        } else {
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(red: 57/255.0, green: 101/255.0, blue: 246/255.0, alpha: 1.0)
        header.textLabel?.font = UIFont(name: "PingFang TC", size: 17.0)
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return max(sectionArray.count, 1)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return max(rowArray[section].count, 1)
        if rowArray.count > 0 {
            return rowArray[section].count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = rowArray[indexPath.section][indexPath.row]
        switch (item) {
        case .horizontalCollectionViewType:
            guard let cell = cell as? HorizontalCollectionView else {return }
            guard let itemStruct = item.configureCell() as? HorizontalCollectionViewItem else {return}
            cell.viewArray = itemStruct.viewArray
            cell.titleArray = itemStruct.titleArray
            cell.selectionStyle = .none
            if itemStruct.viewArray.count == 0 {
                cell.hintView.alpha = 1
                let randomIndex = Int(arc4random_uniform(UInt32(hintLabels.hintLabels.count)))
                cell.hintViewLabel.text = hintLabels.hintLabels[randomIndex]
                print(randomIndex)
            } else {
                cell.hintView.alpha = 0
            }
        case .calendarCollectionViewType:
            guard let cell = cell as? CalendarCollectionView else {return}
            cell.selectionStyle = .none
        case .recipeCellType:
            guard let cell = cell as? RecipeTableViewCell else {return}
            guard let itemStruct = item.configureCell() as? RecipeCellItem else {return }
            cell.recipeImage.image = itemStruct.image
            cell.recipeName.text = itemStruct.title
            cell.backgroundColor = UIColor.clear
        case .recipeSearchCellType:
            guard let cell = cell as? RecipeSearchResultCell else {return}
            guard let itemStruct = item.configureCell() as? RecipeSearchCellItem else {return}
            cell.recipeTitle.text = itemStruct.title
            cell.selectRecipe.addTarget(self, action: #selector(selectRecipeAction(_:)), for: .touchUpInside)
            cell.selectRecipe.tag = indexPath.row
            if itemStruct.selected {
                cell.selectRecipe.setImage(#imageLiteral(resourceName: "success_green"), for: .normal)
            } else {
                cell.selectRecipe.setImage(#imageLiteral(resourceName: "success_black"), for: .normal)
            }
            if itemStruct.isInsertImage {
                cell.recipeImage.image = itemStruct.image
            } else {
                cell.loadImage(imageURL: itemStruct.imageURL)
            }
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
        case .recipeNoteType:
            guard let cell = cell as? RecipeNoteView else {return}
        case .textFieldType:
            guard let cell = cell as? AddRecipeInformationTextFieldCell else {return}
            guard let itemStruct = item.configureCell() as? TextFieldItem else {return}
            cell.textFieldLabel.text = itemStruct.textFieldLabel
            cell.textField.placeholder = itemStruct.textFieldPlaceHolder
        case .recipeStepType:
            guard let cell = cell as? AddRecipeInformationTextFieldWithImageCell else {return}
            cell.selectionStyle = .none
            guard let itemStruct = item.configureCell() as? RecipeStepItem else {return}
            var imagePickerViewController = itemStruct.imagePickerViewController
            var inputTextViewController = itemStruct.inputTextViewController
            if let index = self.rowControllerIndexDic[indexPath],
                let storedimagePickerViewController = self.rowControllerArray[index][0] as? ImagePickerViewController,
                let storedinputTextViewController = self.rowControllerArray[index][1] as? InputTextViewController {
                imagePickerViewController = storedimagePickerViewController
                inputTextViewController = storedinputTextViewController
            } else {
                let controllerArray = [imagePickerViewController, inputTextViewController]
                self.rowControllerArray.append(controllerArray)
                self.rowControllerIndexDic[indexPath] = self.rowControllerArray.count-1
            }
            addChildViewController(imagePickerViewController)
            imagePickerViewController.view.frame = cell.viewForImagePicker.frame
            imagePickerViewController.view.frame.origin.x = 0
            imagePickerViewController.view.frame.origin.y = 0
            imagePickerViewController.resetFrame()
            cell.viewForImagePicker.addSubview(imagePickerViewController.view)
            imagePickerViewController.didMove(toParentViewController: self)
            addChildViewController(inputTextViewController)
            inputTextViewController.view.frame = cell.viewForTextField.frame
            inputTextViewController.view.frame.origin.x = 0
            inputTextViewController.view.frame.origin.y = 0
            //inputTextViewController.resetFrame()
            cell.viewForTextField.addSubview(inputTextViewController.view)
            NSLayoutConstraint.activate([
                inputTextViewController.view.trailingAnchor.constraint(equalTo: cell.viewForTextField.trailingAnchor, constant: 0),
                inputTextViewController.view.leadingAnchor.constraint(equalTo: cell.viewForTextField.leadingAnchor, constant: 0),
                inputTextViewController.view.topAnchor.constraint(equalTo: cell.viewForTextField.topAnchor, constant: 0),
                inputTextViewController.view.bottomAnchor.constraint(equalTo: cell.viewForTextField.bottomAnchor, constant: 0)
                ])
            cell.layoutIfNeeded()
            inputTextViewController.resetFrame()
            inputTextViewController.didMove(toParentViewController: self)
            inputTextViewController.section = indexPath.section
            inputTextViewController.row = indexPath.row
            inputTextViewController.delegate = self
        case .sliderType:
            print("section:\(indexPath.section), row:\(indexPath.row), step-------")
            guard let cell = cell as? AddRecipeInformationSliderCell else {return}
            cell.selectionStyle = .none
            guard let itemStruct = item.configureCell() as? SliderItem else {return}
            //let sliderController = itemStruct.sliderController
            var sliderController = SliderViewController()
            if let index = self.rowControllerIndexDic[indexPath],
                let storedSliderViewController = self.rowControllerArray[index][0] as? SliderViewController {
                sliderController = storedSliderViewController
            } else {
                let controllerArray = [sliderController]
                self.rowControllerArray.append(controllerArray)
                self.rowControllerIndexDic[indexPath] = rowControllerArray.count-1
            }
            addChildViewController(sliderController)
            sliderController.view.frame = cell.contentView.frame
            sliderController.sliderMax = Int(itemStruct.slidermax)
            sliderController.sliderView.sliderUnit.text = itemStruct.sliderUnit
            sliderController.sliderView.sliderDescription.text = itemStruct.sliderDescription
            sliderController.resetSliderMax()
            cell.contentView.addSubview(sliderController.view)
            sliderController.didMove(toParentViewController: self)
        case .nutrientsEditType:
            guard let cell = cell as? NutrientsEditCell else {return}
            cell.selectionStyle = .none
            var nutrientsEditController = NutrientsEditViewController()
            if let index = self.rowControllerIndexDic[indexPath],
                let storedNutrientsEditController = self.rowControllerArray[index][0] as? NutrientsEditViewController {
                nutrientsEditController = storedNutrientsEditController
            } else {
                let controllerArray = [nutrientsEditController]
                self.rowControllerArray.append(controllerArray)
                self.rowControllerIndexDic[indexPath] = self.rowControllerArray.count-1
            }
            addChildViewController(nutrientsEditController)
            nutrientsEditController.view.frame = cell.contentView.frame
            cell.contentView.addSubview(nutrientsEditController.view)
            nutrientsEditController.didMove(toParentViewController: self)
        case .recipeIngredientType:
            guard let cell = cell as? RecipeDetailIngredientCell else {return}
            cell.selectionStyle = .none
            guard let itemStruct = item.configureCell() as? RecipeIngredientItem else {return}
            cell.ingredientLabel.text = itemStruct.ingredientText
            if (indexPath.row%2 == 0) {
                cell.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
            }
        case .recipeStepTableViewCellType:
            guard let cell = cell as? RecipeStepTableViewCell else {return}
            cell.selectionStyle = .none
            guard let itemStruct = item.configureCell() as? RecipeStepTableViewItem else {return}
            cell.recipeStepDescription.text = itemStruct.recipeStepDescription
            cell.recipeStepImage.image = itemStruct.recipeStepImage
        case .recipeIngredientEditType:
            guard let cell = cell as? IngredientEditTableViewCell else {return}
            cell.selectionStyle = .none
            var ingredientTitleTextViewController = InputTextViewController()
            var ingredientWeightTextViewController = InputTextViewController()
            if let index = self.rowControllerIndexDic[indexPath],
                let storedIngredientTitleTextViewController = self.rowControllerArray[index][0] as? InputTextViewController,
                let storedIngredientWeightTextViewController = self.rowControllerArray[index][1] as? InputTextViewController {
                ingredientTitleTextViewController = storedIngredientTitleTextViewController
                ingredientWeightTextViewController = storedIngredientWeightTextViewController
            } else {
                let controllerArray = [ingredientTitleTextViewController, ingredientWeightTextViewController]
                self.rowControllerArray.append(controllerArray)
                self.rowControllerIndexDic[indexPath] = self.rowControllerArray.count-1
            }
            
            addChildViewController(ingredientWeightTextViewController)
            ingredientWeightTextViewController.view.frame = cell.ingredientWeightView.frame
            ingredientWeightTextViewController.view.frame.origin.x = 0
            ingredientWeightTextViewController.view.frame.origin.y = 0
            //ingredientWeightTextViewController.view.frame = CGRect(x: 0, y: 0, width: cell.ingredientWeightView.frame.width, height: 40.0)
            ingredientWeightTextViewController.showSeparationLine = false
            ingredientWeightTextViewController.resetFrame()
            cell.ingredientWeightView.addSubview(ingredientWeightTextViewController.view)
            ingredientWeightTextViewController.didMove(toParentViewController: self)
            ingredientWeightTextViewController.textViewHint = "gram"
            ingredientWeightTextViewController.configureTextFieldEmpty()
            ingredientWeightTextViewController.useNumberKeyboard = true
            ingredientWeightTextViewController.resetKeyboard()
            
            addChildViewController(ingredientTitleTextViewController)
            ingredientTitleTextViewController.view.frame = cell.ingredientTitleView.frame
            ingredientTitleTextViewController.view.frame.origin.x = 0
            ingredientTitleTextViewController.view.frame.origin.y = 0
            //ingredientTitleTextViewController.view.frame = CGRect(x: 0, y: 0, width: cell.ingredientTitleView.frame.width, height: 50.0)
            ingredientTitleTextViewController.showSeparationLine = false
            ingredientTitleTextViewController.resetFrame()
            cell.ingredientTitleView.addSubview(ingredientTitleTextViewController.view)
            ingredientTitleTextViewController.didMove(toParentViewController: self)
            ingredientTitleTextViewController.textViewHint = "Enter ingredient"
            ingredientTitleTextViewController.configureTextFieldEmpty()
            
            ingredientTitleTextViewController.delegate = self
            ingredientWeightTextViewController.delegate = self
        case .addIngredientType:
            guard let cell = cell as? MPIngredientAddButtonTableViewCell else {return}
            cell.selectionStyle = .none
            var ingredientAddButtonViewController = IngredientAddButtonViewController()
            if let index = self.rowControllerIndexDic[indexPath],
                let storedAddButtonViewController = self.rowControllerArray[index][0] as? IngredientAddButtonViewController {
                ingredientAddButtonViewController = storedAddButtonViewController
            } else {
                let controllerArray = [ingredientAddButtonViewController]
                self.rowControllerArray.append(controllerArray)
                self.rowControllerIndexDic[indexPath] = self.rowControllerArray.count-1
            }
            
            addChildViewController(ingredientAddButtonViewController)
            ingredientAddButtonViewController.view.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 50.0)
            //ingredientAddButtonViewController.resetFrame()
            cell.addSubview(ingredientAddButtonViewController.view)
            ingredientAddButtonViewController.didMove(toParentViewController: self)
        case .monthType:
            guard let cell = cell as? MonthTableViewCell else {return}
            guard let itemStruct = item.configureCell() as? MonthItem else {return}
            cell.yearMonthLabel.text = itemStruct.labelText
            print("month label text:\(itemStruct.labelText)")
            cell.selectionStyle = .none
        case .weekType:
            guard let cell = cell as? WeekTableViewCell else {return}
            guard let itemStruct = item.configureCell() as? WeekItem else {return}
            print("week lable text:\(itemStruct.labelText)")
            cell.weekLabel.text = itemStruct.labelText
            cell.selectionStyle = .none
        case .dayType:
            guard let cell = cell as? DayTableViewCell else {return}
            guard let itemStruct = item.configureCell() as? DayItem else {return}
            cell.dayLabel.text = itemStruct.dayLabel
            cell.weekDayLabel.text = itemStruct.weekDayLabel
            cell.viewArray = itemStruct.viewArray
            cell.today = itemStruct.today
            cell.horizontalCollectionView.reloadData()
            cell.selectionStyle = .none
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = rowArray[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.configureCell().reuseIdentifier, for: indexPath)
        switch (item) {
        case .horizontalCollectionViewType:
            guard let cell = cell as? HorizontalCollectionView else {return UITableViewCell()}
            return cell
        case .calendarCollectionViewType:
            guard let cell = cell as? CalendarCollectionView else {return UITableViewCell()}
            return cell
        case .recipeCellType:
            guard let cell = cell as? RecipeTableViewCell else {return UITableViewCell()}
            return cell
        case .recipeSearchCellType:
            guard let cell = cell as? RecipeSearchResultCell else {return UITableViewCell()}
            return cell
        case .recipeNoteType:
            guard let cell = cell as? RecipeNoteView else {return UITableViewCell()}
            return cell
        case .textFieldType:
            guard let cell = cell as? AddRecipeInformationTextFieldCell else {return UITableViewCell()}
            return cell
        case .recipeStepType:
            guard let cell = cell as? AddRecipeInformationTextFieldWithImageCell else {return UITableViewCell()}
            return cell
        case .sliderType:
            guard let cell = cell as? AddRecipeInformationSliderCell else {return UITableViewCell()}
            return cell
        case .nutrientsEditType:
            guard let cell = cell as? NutrientsEditCell else {return UITableViewCell()}
            return cell
        case .recipeIngredientType:
            guard let cell = cell as? RecipeDetailIngredientCell else {return UITableViewCell()}
            return cell
        case .recipeStepTableViewCellType:
            guard let cell = cell as? RecipeStepTableViewCell else {return UITableViewCell()}
            return cell
        case .recipeIngredientEditType:
            guard let cell = cell as? IngredientEditTableViewCell else {return UITableViewCell()}
            return cell
        case .addIngredientType:
            guard let cell = cell as? MPIngredientAddButtonTableViewCell else {return UITableViewCell()}
            return cell
        case .monthType:
            guard let cell = cell as? MonthTableViewCell else {return UITableViewCell()}
            return cell
        case .weekType:
            guard let cell = cell as? WeekTableViewCell else {return UITableViewCell()}
            print("============")
            print("index Path Row\(indexPath.row)")
            return cell
        case .dayType:
            guard let cell = cell as? DayTableViewCell else {return UITableViewCell()}
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return CGFloat(rowArray[indexPath.section][indexPath.row].configureCell().rowHeight)

    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(rowArray[indexPath.section][indexPath.row].configureCell().rowHeight)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let index = self.rowControllerIndexDic[indexPath] {
            for controller in self.rowControllerArray[index] {
                controller.willMove(toParentViewController: nil)
                controller.view.removeFromSuperview()
                controller.removeFromParentViewController()
            }
        }
    }

}


extension MPTableViewController {
    @objc func selectRecipeAction(_ sender: UIButton) {

    }
}
