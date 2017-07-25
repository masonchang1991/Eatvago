//
//  SignUpViewController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/7/25.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var realNameTextField: UITextField!

    @IBOutlet weak var nickNameTextField: UITextField!

    @IBOutlet weak var phoneNumberTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createAccount(_ sender: UIButton) {
    }

}
