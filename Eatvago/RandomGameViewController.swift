//
//  RandomGameViewController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/2.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

class RandomGameViewController: UIViewController {

    @IBOutlet weak var mealRoulette: UIView!
    
    @IBOutlet weak var generateRestaurantsButton: UIButton!
    
    @IBOutlet weak var firstRestaurantButton: UIButton!
    @IBOutlet weak var firstXConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstYConstraint: NSLayoutConstraint!

    @IBOutlet weak var secondRestaurantButton: UIButton!
    @IBOutlet weak var secondXConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var thirdRestaurantButton: UIButton!
    @IBOutlet weak var thirdXConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdYConstraint: NSLayoutConstraint!

    @IBOutlet weak var fourthRestaurantButton: UIButton!
    @IBOutlet weak var fourthXConstraint: NSLayoutConstraint!
    @IBOutlet weak var fourthYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var fifthRestaurantButton: UIButton!
    @IBOutlet weak var fifthXConstraint: NSLayoutConstraint!
    @IBOutlet weak var fifthYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sixthRestaurantButton: UIButton!
    @IBOutlet weak var sixthXConstraint: NSLayoutConstraint!
    @IBOutlet weak var sixthYConstraint: NSLayoutConstraint!
    
    var randomRestaurant = [Location]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //先隱藏起來
        firstXConstraint.constant = 110
        firstYConstraint.constant = 110
        secondXConstraint.constant = 110
        secondYConstraint.constant = 110
        thirdXConstraint.constant = 110
        thirdYConstraint.constant = 110
        fourthXConstraint.constant = 110
        fourthYConstraint.constant = 110
        fifthXConstraint.constant = 110
        fifthYConstraint.constant = 110
        sixthXConstraint.constant = 110
        sixthYConstraint.constant = 110
        
        firstRestaurantButton.isHidden = true
        secondRestaurantButton.isHidden = true
        thirdRestaurantButton.isHidden = true
        fourthRestaurantButton.isHidden = true
        fifthRestaurantButton.isHidden = true
        sixthRestaurantButton.isHidden = true
        
        
     
        
        
    }
    
    
    @IBAction func generateRestaurant(_ sender: UIButton) {
        
        randomRestaurant = []
        
        
        
        if firstRestaurantButton.isHidden == false {
            
        UIView.animate(withDuration: 1.5, delay: 0.1, options: .curveEaseIn, animations: {
            self.firstXConstraint.constant = 95
            self.firstYConstraint.constant = 110
            self.secondXConstraint.constant = 95
            self.secondYConstraint.constant = 110
            self.thirdXConstraint.constant = 95
            self.thirdYConstraint.constant = 110
            self.fourthXConstraint.constant = 95
            self.fourthYConstraint.constant = 110
            self.fifthXConstraint.constant = 95
            self.fifthYConstraint.constant = 110
            self.sixthXConstraint.constant = 95
            self.sixthYConstraint.constant = 110
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            
            UIView.animate(withDuration: 0.1, animations: {
                self.firstRestaurantButton.isHidden = true
                self.secondRestaurantButton.isHidden = true
                self.thirdRestaurantButton.isHidden = true
                self.fourthRestaurantButton.isHidden = true
                self.fifthRestaurantButton.isHidden = true
                self.sixthRestaurantButton.isHidden = true
            })
        })

            
            
        } else {
            
            for _ in 0...5{
                
                let randomNumber = Int(arc4random_uniform(UInt32(fetchedLocations.count - 1)))
                
                randomRestaurant.append(fetchedLocations[randomNumber])
                
            }
            
            
            firstRestaurantButton.setTitle(randomRestaurant[0].name, for: .normal)
            secondRestaurantButton.setTitle(randomRestaurant[1].name, for: .normal)
            thirdRestaurantButton.setTitle(randomRestaurant[2].name, for: .normal)
            fourthRestaurantButton.setTitle(randomRestaurant[3].name, for: .normal)
            fifthRestaurantButton.setTitle(randomRestaurant[4].name, for: .normal)
            sixthRestaurantButton.setTitle(randomRestaurant[5].name, for: .normal)
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 1.5, delay: 0.1, options: .curveEaseOut, animations: {
                self.firstXConstraint.constant = 31
                self.firstYConstraint.constant = 46
                self.secondXConstraint.constant = 95
                self.secondYConstraint.constant = 20
                self.thirdXConstraint.constant = 159
                self.thirdYConstraint.constant = 46
                self.fourthXConstraint.constant = 31
                self.fourthYConstraint.constant = 174
                self.fifthXConstraint.constant = 95
                self.fifthYConstraint.constant = 200
                self.sixthXConstraint.constant = 159
                self.sixthYConstraint.constant = 174
                
                self.firstRestaurantButton.isHidden = false
                self.secondRestaurantButton.isHidden = false
                self.thirdRestaurantButton.isHidden = false
                self.fourthRestaurantButton.isHidden = false
                self.fifthRestaurantButton.isHidden = false
                self.sixthRestaurantButton.isHidden = false
                
                
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
    }

    @IBAction func spin(_ sender: UIButton) {
        
        
        let randomNumber = Int(arc4random_uniform(UInt32(30)))
        let randomNumberAdd = randomNumber + 20
        var number = 1
        
        
        

        
        
          
        for _ in 0...randomNumberAdd {

            UIView.animate(withDuration: 3.0, delay: 0.2, options: .curveEaseOut, animations: {
                if number == 1 {
                    
                    self.fourthRestaurantButton.backgroundColor = UIColor.white
                    self.firstRestaurantButton.backgroundColor = UIColor.red
                    self.view.layoutIfNeeded()
                } else if number == 2 {
                    
                    self.firstRestaurantButton.backgroundColor = UIColor.white
                    self.secondRestaurantButton.backgroundColor = UIColor.red
                    self.view.layoutIfNeeded()
                    
                } else if number == 3 {
                    
                   self.secondRestaurantButton.backgroundColor = UIColor.white
                    self.thirdRestaurantButton.backgroundColor = UIColor.red
                    self.view.layoutIfNeeded()
                } else if number == 4 {
                    
                    self.thirdRestaurantButton.backgroundColor = UIColor.white
                    self.sixthRestaurantButton.backgroundColor = UIColor.red
                    self.view.layoutIfNeeded()
                } else if number == 5 {
                    
                    self.sixthRestaurantButton.backgroundColor = UIColor.white
                    self.fifthRestaurantButton.backgroundColor = UIColor.red
                    self.view.layoutIfNeeded()
                } else {
                    
                    self.fifthRestaurantButton.backgroundColor = UIColor.white
                    self.fourthRestaurantButton.backgroundColor = UIColor.red
                    self.view.layoutIfNeeded()
                    number = 0
                }
                number += 1
                UIView.commitAnimations()
            }, completion: { _ in
                
            })
            
            
        }
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
                    


}
