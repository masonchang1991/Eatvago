//
//  LoadingViewController.swift
//  
//
//  Created by Ｍason Chang on 2017/7/26.
//
//

import UIKit
import FirebaseAuth
import Firebase

class LoadingViewController: UIViewController {

    @IBOutlet weak var landingBackgroundImageView: UIImageView!
    
    @IBOutlet weak var loadingViewWidthConstrain: NSLayoutConstraint!

    @IBOutlet weak var landingImage: UIImageView!
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var loadingFirstView: UIView!
    
    @IBOutlet weak var loadingSecondView: UIView!
    
    @IBOutlet weak var loadingThirdView: UIView!
    
    var loginSuccess: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingFirstView.alpha = 0
        
        loadingSecondView.alpha = 0
        
        loadingThirdView.alpha = 0
        
        loadingFirstView.isHidden = true
        
        loadingSecondView.isHidden = true
        
        loadingThirdView.isHidden = true
        
        loadingFirstView.backgroundColor = UIColor.asiTealish85.withAlphaComponent(0.2)
        
        loadingSecondView.backgroundColor = UIColor.asiTealish85.withAlphaComponent(0.2)
        
        loadingThirdView.backgroundColor = UIColor.asiTealish85.withAlphaComponent(0.2)
        
        UIApplication.shared.statusBarStyle = .default

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        landingImage.tintColor = UIColor.white
        
        landingImage.alpha = 0.0
        
        loading()
    }
    
    func loading() {
        
        landingImage.tintColor = UIColor.red
        
        UIView.animate(withDuration: 2.0, animations: {
            
            self.loadingViewWidthConstrain.constant = 200
            
            self.landingImage.alpha = 1.0
            
            if UserDefaults.standard.value(forKey: "UID") != nil {
                
                self.loginSuccess = true
                
            } else {
                
                self.loginSuccess = false
            }
            
            self.view.layoutIfNeeded()
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.loadingFirstView.isHidden = false
                
                self.loadingFirstView.alpha = 1.0
                
            }, completion: { (_) in
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.loadingFirstView.alpha = 0.0
                    
                    self.loadingSecondView.isHidden = false
                    
                    self.loadingSecondView.alpha = 1.0
                    
                }, completion: { (_) in
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        
                        self.loadingSecondView.alpha = 0
                        
                        self.loadingThirdView.isHidden = false
                        
                        self.loadingThirdView.alpha = 1.0
                        
                    }, completion: { (_) in
                        
                        UIView.animate(withDuration: 0.3, animations: {
                            
                            self.loadingThirdView.alpha = 0
                            
                        }, completion: { (_) in
                            
                            self.loadingThirdView.alpha = 0
                            
                            if self.loginSuccess {

                                let window = UIApplication.shared.windows[0] as UIWindow
                                
                                window.makeKeyAndVisible()
                                
                                let storyBoard = UIStoryboard(name: "Main",
                                                              bundle: nil)
                                
                                let nextVC = storyBoard.instantiateViewController(withIdentifier: "TabBarController")
                                
                                window.rootViewController = nextVC
                                
                            } else {
                                
                                let window = UIApplication.shared.windows[0] as UIWindow
                                
                                window.makeKeyAndVisible()
                                
                                let storyBoard = UIStoryboard(name: "Main",
                                                              bundle: nil)
                                
                                let nextVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
                                
                                window.rootViewController = nextVC
                                
                            }
                        })
                    })
                })
            })
        }
    }
}
