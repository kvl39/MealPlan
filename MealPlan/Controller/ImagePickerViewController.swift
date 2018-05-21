//
//  ImagePickerViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/20.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    lazy var image = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = #imageLiteral(resourceName: "tap")
        self.view.backgroundColor = UIColor.blue
        self.view.addSubview(image)
    }
    
    func resetFrame() {
        image.frame = self.view.frame
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        image.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
    
    

}
