//
//  MPSliderViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/22.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class MPSliderViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
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
    
    
    
    
//    //var slider = MPSliderView(frame: CGRect(x: 0, y: 0, width: 375, height: 150))
//    lazy var slider = UITextField()
//    var sliderMax: Int = 100
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        slider.slider.addTarget(self, action: #selector(onSliderChange), for: .valueChanged)
////        slider.slider.maximumValue = Float(sliderMax)
//        self.view.addSubview(slider)
//        slider.backgroundColor = UIColor.green
//    }
//
//
//
////    @objc func onSliderChange() {
////        slider.sliderNumber.text = String(slider.slider.value)
////    }


}
