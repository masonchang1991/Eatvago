//
//  NearbyViewController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/7/26.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

class NearbyViewController: UIViewController {
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logout(_ sender: UIButton) {
        // 消去 UserDefaults內使用者的帳號資訊
        UserDefaults.standard.setValue(nil, forKey: "UserLoginEmail")
        UserDefaults.standard.setValue(nil, forKey: "UserLoginPassword")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
        self.window?.rootViewController = nextVC
    }


}
