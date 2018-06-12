//
//  PhotoViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/15.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var photoImageView: UIImageView!
    var takenPhoto: UIImage?
    var selectedDate = ""
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        if let availableImage = takenPhoto {
            photoImageView.image = availableImage
        }
        configureButtons()
        photoImageView.contentMode = .scaleToFill
    }
    
    func updatePhoto() {
        if let availableImage = takenPhoto {
            photoImageView.image = availableImage
        }
    }
    
    func configureButtons() {
        cancelButton.setImage(#imageLiteral(resourceName: "iTunesArtwork-1"), for: .normal)
        cancelButton.tintColor = UIColor(red: 135/255.0, green: 76/255.0, blue: 98/255.0, alpha: 1)
        retakeButton.setImage(#imageLiteral(resourceName: "replay"), for: .normal)
        retakeButton.tintColor = UIColor(red: 135/255.0, green: 76/255.0, blue: 98/255.0, alpha: 1)
        acceptButton.setImage(#imageLiteral(resourceName: "success_black"), for: .normal)
        acceptButton.tintColor = UIColor(red: 135/255.0, green: 76/255.0, blue: 98/255.0, alpha: 1)
    }
    
    
    @IBAction func cancelPhotoShooting(_ sender: UIButton) {
        
    }
    
    
    @IBAction func takePhotoAgain(_ sender: UIButton) {
        if let parentVC = self.parent as? CreateRecipeStepsViewController {
            parentVC.reTakePicture()
        }
    }
    
    
    @IBAction func acceptPhoto(_ sender: UIButton) {
        if let parentVC = self.parent as? CreateRecipeStepsViewController {
            parentVC.scrollToRight()
        }
    }
    
    
    

}
