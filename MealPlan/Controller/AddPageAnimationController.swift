//
//  AddPageAnimationController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/8.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

protocol AnimationControllerProtocol: class {
    func selectAnimationDidFinish(animationImage: UIImage)
}

class AddPageAnimationController: UIViewController, CAAnimationDelegate{
    
    var imageView = UIImageView()
    weak var delegate: AnimationControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func selectRecipeAnimation(cell: RecipeSearchResultCell, view: UIView, cellRect: CGRect) {
        
        self.imageView = UIImageView(image: cell.recipeImage.image)
        imageView.frame = CGRect(origin: cellRect.origin, size: CGSize(width: 40, height: 40))
        print("y:\(cellRect.origin.y)")
        view.addSubview(imageView)
        
        let path = UIBezierPath()
        path.move(to: cellRect.origin)
        path.addQuadCurve(to: CGPoint(x: 51, y: 60),
                          controlPoint: CGPoint(x: view.frame.width/20, y: -cellRect.origin.y/10))
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = 2.0
        animation.isRemovedOnCompletion=true
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.delegate = self
        imageView.layer.add(animation, forKey: "animation")
    }
    
    func animationDidStart(_ anim: CAAnimation) {
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        imageView.removeFromSuperview()
        guard let animationImage = imageView.image else {return}
        delegate?.selectAnimationDidFinish(animationImage: animationImage)
    }
    
}

