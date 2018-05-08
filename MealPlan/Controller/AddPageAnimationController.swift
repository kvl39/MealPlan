//
//  AddPageAnimationController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/8.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class AddPageAnimationController {
    
    func selectRecipeAnimation(cell: RecipeSearchResultCell, view: UIView, cellRect: CGRect) {
        
        let imageView = UIImageView(image: cell.recipeImage.image)
        imageView.frame = CGRect(origin: cellRect.origin, size: CGSize(width: 40, height: 40))
        print("y:\(cellRect.origin.y)")
        view.addSubview(imageView)
        
        let path = UIBezierPath()
        path.move(to: cellRect.origin)
        path.addQuadCurve(to: CGPoint(x: view.frame.width/2, y: 20),
                          controlPoint: CGPoint(x: view.frame.width/20, y: -cellRect.origin.y/10))
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = 2.0
        animation.isRemovedOnCompletion = true
        imageView.layer.add(animation, forKey: "animation")
        
        
        
        

//
//        // set some more parameters for the animation
//        // this rotation mode means that our object will rotate so that it's parallel to whatever point it is currently on the curve
//        anim.rotationMode = kCAAnimationRotateAuto
//        anim.repeatCount = Float.infinity
//        anim.duration = 5.0
//
//        // we add the animation to the squares 'layer' property
//        square.layer.addAnimation(anim, forKey: "animate position along path")
    }
}

