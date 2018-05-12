//
//  AddPageAnimationController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/8.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

protocol AnimationControllerProtocol: class {
    func selectAnimationDidFinish(animationImage: UIImage, title: String)
}

class AddPageAnimationController: UIViewController, CAAnimationDelegate {

    var imageView = UIImageView()
    var animatingImageView = [UIImageView]()
    var animatingTitle = [String]()
    var titleText: String = ""
    weak var delegate: AnimationControllerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func selectRecipeAnimation(cell: RecipeSearchResultCell, view: UIView, cellRect: CGRect) {

        self.imageView = UIImageView(image: cell.recipeImage.image)
        guard let text = cell.recipeTitle.text else {
            return
        }
        self.titleText = text
        imageView.frame = CGRect(origin: cellRect.origin, size: CGSize(width: 40, height: 40))
        print("y:\(cellRect.origin.y)")
        view.addSubview(imageView)

        let path = UIBezierPath()
        path.move(to: CGPoint(x: cellRect.origin.x + 20, y: cellRect.origin.y))
        path.addQuadCurve(to: CGPoint(x: 51, y: 100),
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
        self.animatingImageView.append(imageView)
        self.animatingTitle.append(titleText)
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.animatingImageView[0].removeFromSuperview()
        guard let animationImage = self.animatingImageView[0].image else {return}
        delegate?.selectAnimationDidFinish(animationImage: animationImage, title: animatingTitle[0])
        self.animatingImageView.remove(at: 0)
        self.animatingTitle.remove(at: 0)
    }

}
