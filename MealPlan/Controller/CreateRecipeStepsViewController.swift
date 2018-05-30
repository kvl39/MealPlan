//
//  CreateRecipeStepsViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/29.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class CreateRecipeStepsViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var scrollStepsView: UIScrollView!
    @IBOutlet weak var topImageView: UIImageView!
    
    
    
    var currentStep = 1
    var numberOfSteps = 4
    var stepIndicationWidth: CGFloat = 0.0
    var controllersArray: [UIViewController] = []
    var capturedPhoto: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollStepsView()
        stepIndicationWidth = 0.25 * (self.view.frame.width - 150)
        topImageView.backgroundColor = UIColor(red: 253/255.0, green: 216/255.0, blue: 53/255.0, alpha: 1)
    }

    func configureScrollStepsView() {
        scrollStepsView.delegate = self
        scrollStepsView.contentSize.width = 4 * self.view.frame.width
        scrollStepsView.isPagingEnabled = true
        
        for index in 0..<numberOfSteps {
            let view = UIView(frame: CGRect(x: self.view.frame.width * CGFloat(index), y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.scrollStepsView.addSubview(view)
        }
        
        addCameraViewController()
        addPhotoViewController()
        addStepInformationViewController()
        
    }
    
    func addCameraViewController() {
        var cameraViewController = CameraViewController()
        addChildViewController(cameraViewController)
        cameraViewController.view.frame = CGRect(x: 0, y: 0, width: self.scrollStepsView.frame.width, height: self.scrollStepsView.frame.height)
        self.scrollStepsView.addSubview(cameraViewController.view)
        didMove(toParentViewController: cameraViewController)
        self.controllersArray.append(cameraViewController)
    }
    
    func addPhotoViewController() {
        guard let photoViewController = UIStoryboard(name: "MealPlan", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as? PhotoViewController else {return}
        addChildViewController(photoViewController)
        photoViewController.view.frame = CGRect(x: self.view.frame.width, y: 0, width: self.scrollStepsView.frame.width, height: self.scrollStepsView.frame.height)
        photoViewController.view.layoutIfNeeded()
        self.scrollStepsView.addSubview(photoViewController.view)
        didMove(toParentViewController: photoViewController)
        self.controllersArray.append(photoViewController)
        print("photo view height:\(self.scrollStepsView.frame.height)")
    }
    
    func addStepInformationViewController() {
        guard let addStepInformationViewController = UIStoryboard(name: "MealPlan", bundle: nil).instantiateViewController(withIdentifier: "AddRecipeInformationViewController") as? AddRecipeInformationViewController else {return}
        addChildViewController(addStepInformationViewController)
        addStepInformationViewController.view.frame = CGRect(x: 2*self.view.frame.width, y: 0, width: self.scrollStepsView.frame.width, height: self.scrollStepsView.frame.height)
        self.scrollStepsView.addSubview(addStepInformationViewController.view)
        didMove(toParentViewController: addStepInformationViewController)
        self.controllersArray.append(addStepInformationViewController)
    }
    
    func updatePhotoView() {
        if let photoVC = self.controllersArray[1] as? PhotoViewController {
            photoVC.takenPhoto = self.capturedPhoto
            print("photo height:\(photoVC.takenPhoto?.size.height)")
            photoVC.updatePhoto()
        }
    }
    
    func reTakePicture() {
        if let cameraVC = self.controllersArray[0] as? CameraViewController {
            cameraVC.configureViewWillAppear()
        }
       scrollToLeft()
    }
    
    func scrollToLeft() {
        self.scrollStepsView.setContentOffset(CGPoint(x: self.scrollStepsView.contentOffset.x-self.view.frame.width, y: self.scrollStepsView.contentOffset.y), animated: true)
    }
    
    func scrollToRight() {
        self.scrollStepsView.setContentOffset(CGPoint(x: self.scrollStepsView.contentOffset.x+self.view.frame.width, y: self.scrollStepsView.contentOffset.y), animated: true)
    }

}

extension CreateRecipeStepsViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollStepsView {
            print("scroll view offset:\(scrollView.contentOffset)")
        }
        
        let page = Int(scrollView.contentOffset.x / self.view.frame.width)
        let newX = (0.25 - (7.5/self.view.frame.width)) * scrollView.contentOffset.x + 30
        
        for child in childViewControllers {
            if let child = child as? MPScrollNavigationViewController {
                child.updateScrollBarPosition(newX: newX, page: page)
            }
        }
        
    }
    
}
