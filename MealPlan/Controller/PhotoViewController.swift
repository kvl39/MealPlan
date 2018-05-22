//
//  PhotoViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/15.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    
    @IBOutlet weak var photoImageView: UIImageView!
    var takenPhoto: UIImage?
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        if let availableImage = takenPhoto {
            photoImageView.image = availableImage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelPhotoShooting(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func takePhotoAgain(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func acceptPhoto(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushToAddRecipeInformationView" {
            let destination = segue.destination as? AddRecipeInformationViewController
            destination?.recipeImage = takenPhoto
        }
    }
    

}
