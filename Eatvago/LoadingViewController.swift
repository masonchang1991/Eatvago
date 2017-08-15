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

    @IBOutlet weak var loadingViewWidthConstrain: NSLayoutConstraint!

    @IBOutlet weak var appleImage: UIImageView!
    
    @IBOutlet weak var loadingView: UIView!

    var window: UIWindow?
    var loginSuccess: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appleImage.tintColor = UIColor.white
        appleImage.alpha = 0.0
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        loading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("LoadingViewController")
    }
    
    func loading() {
        
        appleImage.tintColor = UIColor.red
        
        UIView.animate(withDuration: 2.0, animations: {
            
            self.loadingViewWidthConstrain.constant = 200
            self.appleImage.alpha = 1.0
            
            if UserDefaults.standard.value(forKey: "UID") != nil {
                
                self.loginSuccess = true
                
            } else {
                
                self.loginSuccess = false
            }
            
            self.view.layoutIfNeeded()
            
        }) { (_) in
            if self.loginSuccess {
                
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.makeKeyAndVisible()
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "TabBarController")
                self.window?.rootViewController = nextVC
                self.removeFromParentViewController()
                self.dismiss(animated: false, completion: nil)

                
            } else {
                
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.makeKeyAndVisible()
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
                self.window?.rootViewController = nextVC
                self.dismiss(animated: false, completion: nil)
                
            }
        }
    }
}
