//
//  DiscoveryPageViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/17.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class DiscoveryPageViewController: UIViewController {

    @IBOutlet weak var cardView: DiscoverCardView!
    override func viewDidLoad() {
        super.viewDidLoad()

        cardView.cardMainImage.image = #imageLiteral(resourceName: "world")
    }

    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        if xFromCenter > 0 {
            
        } else {
            
        }
        
        if sender.state == UIGestureRecognizerState.ended {
            
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 50)
                    card.alpha = 0
                }
                return
            } else if card.center.x > (view.frame.width - 75) {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 50)
                     card.alpha = 0
                }
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.center = self.view.center
            }
        }
    }
    

}
