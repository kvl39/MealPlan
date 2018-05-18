//
//  DiscoveryPageViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/17.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class DiscoveryPageViewController: UIViewController {

    
    
    var cardArray: [DiscoverCardView] = []
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInitialCardStack()
        addGestureRecognizer()
    }
    
    func configureInitialCardStack() {
        for i in 0...2 {
            let newCardView = DiscoverCardView(frame: CGRect(x: view.center.x - 150 + CGFloat(i*20), y: view.center.y - 200 + CGFloat(i*20), width: 300, height: 400))
            newCardView.cardMainImage.image = #imageLiteral(resourceName: "pig")
            newCardView.hint.text = "\(counter)"
            counter += 1
            cardArray.append(newCardView)
            self.view.insertSubview(newCardView, at: 0)
        }
    }
    
    func addGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:)))
        cardArray[0].addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        panCard(sender)
    }
    

    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        //card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        card.frame.origin.x = self.view.center.x - 150 + point.x
        card.frame.origin.y = self.view.center.y - 200 + point.y
        
        if xFromCenter > 0 {
            
        } else {
            
        }
        
        if sender.state == UIGestureRecognizerState.ended {
            
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 50)
                    card.alpha = 0
                    self.configureCardTransition()
                }
                return
            } else if card.center.x > (view.frame.width - 75) {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 50)
                     card.alpha = 0
                    self.configureCardTransition()
                }
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.frame.origin.x = self.view.center.x - 150
                card.frame.origin.y = self.view.center.y - 200
            }
        }
    }
    
    func configureCardTransition() {
        self.cardArray[0].gestureRecognizers?.removeAll()
        self.cardArray.remove(at: 0)
        addGestureRecognizer()
        
        let newCardView = DiscoverCardView(frame: CGRect(x: view.center.x - 150 + 40, y: view.center.y - 200 + 40, width: 300, height: 400))
        newCardView.cardMainImage.image = #imageLiteral(resourceName: "pork")
        newCardView.hint.text = "\(counter)"
        counter += 1
        cardArray.append(newCardView)
        newCardView.alpha = 0
        self.view.insertSubview(newCardView, at: 0)
        
        UIView.animate(withDuration: 0.2) {
            self.cardArray[0].transform = CGAffineTransform(translationX: -40, y: -40)
            self.cardArray[1].transform = CGAffineTransform(translationX: -20, y: -20)
            newCardView.alpha = 1
        }
    }
    

}
