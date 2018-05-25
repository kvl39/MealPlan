//
//  DiscoveryPageViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/17.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit
import SDWebImage

class DiscoveryPageViewController: UIViewController {
    
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    
    var cardArray: [DiscoverCardView] = []
    var counter = 0
    lazy var leftDestinationButton = UIButton(frame: CGRect(x: 20, y: 100.0, width: 100.0, height: 100.0))
    lazy var rightDestinationButton = UIButton(frame: CGRect(x: view.frame.width - 120, y: 100, width: 100, height: 100))
    lazy var leftDestinationButtonOriginalX = CGFloat(-100)
    lazy var rightDistinationButtonOriginalX = view.frame.width + 100.0
    var firebaseManager = MPFirebaseManager()
    var realmManager = RealmManager()
    var menuRecipeNameArray = [[String]]()
    var menuRecipeArray = [[MPFirebaseRecipeModel]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topImageView.backgroundColor = UIColor(red: 167/255.0, green: 210/255.0, blue: 203/255.0, alpha: 1.0)
        mainBackgroundImageView.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.cardArray.count == 0 {
            counter = 0
            retrieveAllMenu {
                self.configureInitialCardStack()
            }
        }
        configureCardDestination()
    }
    
    func retrieveAllMenu(completion: @escaping ()->Void) {
        firebaseManager.retrieveAllMenu { (menuRecipeNameArray) in
            self.menuRecipeNameArray = menuRecipeNameArray
            completion()
        }
    }
    
    func configureCardDestination() {
        leftDestinationButton.setImage(#imageLiteral(resourceName: "btn_like_normal"), for: .normal)
        rightDestinationButton.setImage(#imageLiteral(resourceName: "btn_like_selected"), for: .normal)
        self.view.addSubview(leftDestinationButton)
        self.view.addSubview(rightDestinationButton)
        leftDestinationButton.alpha = 0
        rightDestinationButton.alpha = 0
    }
    
    func configureInitialCardStack() {
        for i in 0...2 {
            let newCardView = DiscoverCardView(frame: CGRect(x: view.center.x - 150 + CGFloat(i*5), y: view.center.y - 200 + CGFloat(i*20) - 40, width: 300, height: 400))
            newCardView.transform = CGAffineTransform(scaleX: 1 - CGFloat(Double(i)*0.2), y: 1).translatedBy(x: 0, y: CGFloat(-10*i))
            
//            let newCardView = DiscoverCardView(frame: CGRect(x: view.center.x - 150 + 10, y: view.center.y - 200 + 40 - 40, width: 300, height: 400))
//            newCardView.transform = CGAffineTransform(scaleX: 0.6, y: 1).translatedBy(x: 0, y: -20)
            
            attachCardInformation(newCardView: newCardView)
            newCardView.title.text = self.menuRecipeNameArray[counter][0]
            newCardView.hint.text = "\(counter)"
            counter += 1
            cardArray.append(newCardView)
            //self.view.insertSubview(newCardView, at: 0)
            mainBackgroundImageView.insertSubview(newCardView, at: 0)
        }
        addGestureRecognizer()
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
        card.frame.origin.y = self.view.center.y - 200 + point.y - 40
        
        if xFromCenter > 0 {
            let factor = 2 * xFromCenter / view.frame.width
            rightDestinationButton.alpha = factor
            rightDestinationButton.transform = CGAffineTransform(scaleX: 5*factor, y: 5*factor)
        } else {
            let factor = 2 * abs(xFromCenter) / view.frame.width
            leftDestinationButton.alpha = factor
            leftDestinationButton.transform = CGAffineTransform(scaleX: 5*factor, y: 5*factor)
        }
        
        if sender.state == UIGestureRecognizerState.ended {
            
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 50)
                    card.alpha = 0
                    self.rightDestinationButton.alpha = 0
                    self.leftDestinationButton.alpha = 0
                    self.configureCardTransition()
                }
                return
            } else if card.center.x > (view.frame.width - 75) {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 50)
                     card.alpha = 0
                    self.rightDestinationButton.alpha = 0
                    self.leftDestinationButton.alpha = 0
                    self.realmManager.saveLikedMenu(menuRecipes: self.menuRecipeArray[0])
                    self.configureCardTransition()
                }
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.frame.origin.x = self.view.center.x - 150
                card.frame.origin.y = self.view.center.y - 200 - 40
                print("y:\(self.view.center.y)")
                self.rightDestinationButton.alpha = 0
                self.leftDestinationButton.alpha = 0
            }
        }
    }
    
    
    func attachCardInformation(newCardView: DiscoverCardView) {
        self.firebaseManager.findRecipesInMenu(menu: self.menuRecipeNameArray[counter]) { (recipeArray) in
            self.menuRecipeArray.append(recipeArray)
            for j in 0...2{
                if j < recipeArray.count {
                    newCardView.imageArray[j].sd_setImage(with: URL(string: recipeArray[j].image), placeholderImage: #imageLiteral(resourceName: "pork"), options: [], completed: nil)
                }
            }
        }
    }
    
    
    
    func configureCardTransition() {
        self.cardArray[0].gestureRecognizers?.removeAll()
        self.cardArray.remove(at: 0)
        self.menuRecipeArray.remove(at: 0)
        if self.cardArray.count > 0 {
            addGestureRecognizer()
        }
        
        if counter < self.menuRecipeNameArray.count {
            let newCardView = DiscoverCardView(frame: CGRect(x: view.center.x - 150 + 10, y: view.center.y - 200 + 40 - 40, width: 300, height: 400))
            newCardView.transform = CGAffineTransform(scaleX: 0.6, y: 1).translatedBy(x: 0, y: -20)
            attachCardInformation(newCardView: newCardView)
            newCardView.title.text = self.menuRecipeNameArray[counter][0]
            newCardView.hint.text = "\(counter)"
            counter += 1
            cardArray.append(newCardView)
            newCardView.alpha = 0
            //self.view.insertSubview(newCardView, at: 0)
            mainBackgroundImageView.insertSubview(newCardView, at: 0)
            
            UIView.animate(withDuration: 0.2) {
                if self.counter == 4 {
                    self.cardArray[0].transform = CGAffineTransform(translationX: 0, y: -20).scaledBy(x: 1.0, y: 1.0)
                } else {
                    self.cardArray[0].transform = CGAffineTransform(translationX: 0, y: -40).scaledBy(x: 1.0, y: 1.0)
                }
                
                self.cardArray[1].transform = CGAffineTransform(translationX: 0, y: -30).scaledBy(x: 0.8, y: 1)
                newCardView.alpha = 1
            }
            
        }
    }
    
    

}
