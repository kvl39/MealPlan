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
    case sliderType(Float)
    case nutrientsEditType
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
        case .sliderType(let sliderMax):
            return SliderItem(slidermax: sliderMax)
        case .nutrientsEditType:
            return NutrientsEditItem()
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
    var rowHeight: Int = 200
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
    
    init(slidermax: Float) {
        self.slidermax = slidermax
    }
}

struct NutrientsEditItem: MPTableViewCellProtocol {
    var reuseIdentifier: String = "NutrientsEditCell"
    var rowHeight: Int = 100
}

class MPTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, InputTextViewControllerDelegate {
    var rowArray: [MPTableViewCellType] = []
    //weak var delegate: MPTableViewControllerDelegateProtocol?
    func updateTableView(newHeight: CGFloat, serialNumber: Int) {}
}

extension MPTableViewController {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = rowArray[indexPath.row]
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
            let imagePickerViewController = itemStruct.imagePickerViewController
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
            let inputTextViewController = itemStruct.inputTextViewController
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
            inputTextViewController.serialNumber = indexPath.row
            inputTextViewController.delegate = self
            return cell
        case .sliderType:
            guard let cell = cell as? AddRecipeInformationSliderCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            guard let itemStruct = item.configureCell() as? SliderItem else {return cell}
            //let sliderController = itemStruct.sliderController
            let sliderController = SliderViewController()
            addChildViewController(sliderController)
            sliderController.view.frame = cell.contentView.frame
            print(sliderController.view.frame)
            sliderController.sliderMax = Int(itemStruct.slidermax)
            sliderController.resetSliderMax()
            cell.contentView.addSubview(sliderController.view)
            sliderController.didMove(toParentViewController: self)
            return cell
        case .nutrientsEditType:
            guard let cell = cell as? NutrientsEditCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            let nutrientsEditController = NutrientsEditViewController()
            addChildViewController(nutrientsEditController)
            nutrientsEditController.view.frame = cell.contentView.frame
            cell.contentView.addSubview(nutrientsEditController.view)
            nutrientsEditController.didMove(toParentViewController: self)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return CGFloat(rowArray[indexPath.row].configureCell().rowHeight)

    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowArray[indexPath.row].configureCell().rowHeight)
    }

}


extension MPTableViewController {
    @objc func selectRecipeAction(_ sender: UIButton) {

    }
}
