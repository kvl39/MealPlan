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
    var rowHeight: Int = 80
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

class MPTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, InputTextViewControllerDelegate {
    var sectionArray: [String] = []
    var rowArray: [[MPTableViewCellType]] = []
    var rowControllerArray : [[UIViewController]] = []
    var rowControllerIndexDic : [Int: Int] = [:]
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
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let item = rowArray[indexPath.section][indexPath.row]
//        
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = rowArray[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.configureCell().reuseIdentifier, for: indexPath)
        switch (item) {
        case .horizontalCollectionViewType:
            guard let cell = cell as? HorizontalCollectionView else {return UITableViewCell()}
            guard let itemStruct = item.configureCell() as? HorizontalCollectionViewItem else {return cell}
            cell.viewArray = itemStruct.viewArray
            cell.titleArray = itemStruct.titleArray
            //cell.frame = tableView.bounds
            //cell.layoutIfNeeded()
            //cell
            cell.selectionStyle = .none
            return cell
        case .calendarCollectionViewType:
            guard let cell = cell as? CalendarCollectionView else {return UITableViewCell()}
            //cell.frame = tableView.bounds
            //cell.layoutIfNeeded()
            //cell.delegate = self
            return cell
        case .recipeCellType:
            guard let cell = cell as? RecipeTableViewCell else {return UITableViewCell()}
            guard let itemStruct = item.configureCell() as? RecipeCellItem else {return cell}
            cell.recipeImage.image = itemStruct.image
            cell.recipeName.text = itemStruct.title
            cell.backgroundColor = UIColor.clear
            return cell
        case .recipeSearchCellType:
            guard let cell = cell as? RecipeSearchResultCell else {return UITableViewCell()}
            guard let itemStruct = item.configureCell() as? RecipeSearchCellItem else {return cell}
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
            return cell
        case .recipeNoteType:
            guard let cell = cell as? RecipeNoteView else {return UITableViewCell()}
            return cell
        case .textFieldType:
            guard let cell = cell as? AddRecipeInformationTextFieldCell else {return UITableViewCell()}
            guard let itemStruct = item.configureCell() as? TextFieldItem else {return cell}
            cell.textFieldLabel.text = itemStruct.textFieldLabel
            cell.textField.placeholder = itemStruct.textFieldPlaceHolder
            return cell
        case .recipeStepType:
            guard let cell = cell as? AddRecipeInformationTextFieldWithImageCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            guard let itemStruct = item.configureCell() as? RecipeStepItem else {return cell}
            var imagePickerViewController = itemStruct.imagePickerViewController
            var inputTextViewController = itemStruct.inputTextViewController
            if let index = self.rowControllerIndexDic[indexPath.row],
                let storedimagePickerViewController = self.rowControllerArray[index][0] as? ImagePickerViewController,
                let storedinputTextViewController = self.rowControllerArray[index][1] as? InputTextViewController {
                imagePickerViewController = storedimagePickerViewController
                inputTextViewController = storedinputTextViewController
            } else {
                let controllerArray = [imagePickerViewController, inputTextViewController]
                self.rowControllerArray.append(controllerArray)
                self.rowControllerIndexDic[indexPath.row] = self.rowControllerArray.count-1
            }
            addChildViewController(imagePickerViewController)
            imagePickerViewController.view.frame = cell.viewForImagePicker.frame
            imagePickerViewController.view.frame.origin.x = 0
            imagePickerViewController.view.frame.origin.y = 0
            imagePickerViewController.resetFrame()
            cell.viewForImagePicker.addSubview(imagePickerViewController.view)
            imagePickerViewController.didMove(toParentViewController: self)
            //            NSLayoutConstraint.activate([
            //                imagePickerViewController.view.trailingAnchor.constraint(equalTo: cell.viewForImagePicker.trailingAnchor, constant: 0),
            //                imagePickerViewController.view.leadingAnchor.constraint(equalTo: cell.viewForImagePicker.leadingAnchor, constant: 0),
            //                imagePickerViewController.view.topAnchor.constraint(equalTo: cell.viewForImagePicker.topAnchor, constant: 0),
            //                imagePickerViewController.view.bottomAnchor.constraint(equalTo: cell.viewForImagePicker.bottomAnchor, constant: 0)
            //                ])
            
            addChildViewController(inputTextViewController)
            inputTextViewController.view.frame = cell.viewForTextField.frame
            inputTextViewController.view.frame.origin.x = 0
            inputTextViewController.view.frame.origin.y = 0
            inputTextViewController.resetFrame()
            cell.viewForTextField.addSubview(inputTextViewController.view)
            NSLayoutConstraint.activate([
                inputTextViewController.view.trailingAnchor.constraint(equalTo: cell.viewForTextField.trailingAnchor, constant: 0),
                inputTextViewController.view.leadingAnchor.constraint(equalTo: cell.viewForTextField.leadingAnchor, constant: 0),
                inputTextViewController.view.topAnchor.constraint(equalTo: cell.viewForTextField.topAnchor, constant: 0),
                inputTextViewController.view.bottomAnchor.constraint(equalTo: cell.viewForTextField.bottomAnchor, constant: 0)
                ])
            inputTextViewController.didMove(toParentViewController: self)
            inputTextViewController.section = indexPath.section
            inputTextViewController.row = indexPath.row
            inputTextViewController.delegate = self
            return cell
        case .sliderType:
            guard let cell = cell as? AddRecipeInformationSliderCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            guard let itemStruct = item.configureCell() as? SliderItem else {return cell}
            //let sliderController = itemStruct.sliderController
            var sliderController = SliderViewController()
            if let index = self.rowControllerIndexDic[indexPath.row],
                let storedSliderViewController = self.rowControllerArray[index][0] as? SliderViewController {
                sliderController = storedSliderViewController
            } else {
                let controllerArray = [sliderController]
                self.rowControllerArray.append(controllerArray)
                self.rowControllerIndexDic[indexPath.row] = rowControllerArray.count-1
            }
            addChildViewController(sliderController)
            sliderController.view.frame = cell.contentView.frame
            print(sliderController.view.frame)
            sliderController.sliderMax = Int(itemStruct.slidermax)
            sliderController.sliderView.sliderUnit.text = itemStruct.sliderUnit
            sliderController.sliderView.sliderDescription.text = itemStruct.sliderDescription
            sliderController.resetSliderMax()
            cell.contentView.addSubview(sliderController.view)
            sliderController.didMove(toParentViewController: self)
            return cell
        case .nutrientsEditType:
            guard let cell = cell as? NutrientsEditCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            var nutrientsEditController = NutrientsEditViewController()
            if let index = self.rowControllerIndexDic[indexPath.row],
                let storedNutrientsEditController = self.rowControllerArray[index][0] as? NutrientsEditViewController {
                nutrientsEditController = storedNutrientsEditController
            } else {
                let controllerArray = [nutrientsEditController]
                self.rowControllerArray.append(controllerArray)
                self.rowControllerIndexDic[indexPath.row] = self.rowControllerArray.count-1
            }
            addChildViewController(nutrientsEditController)
            nutrientsEditController.view.frame = cell.contentView.frame
            cell.contentView.addSubview(nutrientsEditController.view)
            nutrientsEditController.didMove(toParentViewController: self)
            return cell
        case .recipeIngredientType:
            guard let cell = cell as? RecipeDetailIngredientCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            guard let itemStruct = item.configureCell() as? RecipeIngredientItem else {return cell}
            cell.ingredientLabel.text = itemStruct.ingredientText
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
        if let index = self.rowControllerIndexDic[indexPath.row] {
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
