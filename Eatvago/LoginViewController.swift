//
//  LoginViewController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/7/25.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import NVActivityIndicatorView

class LoginViewController: UIViewController {

    @IBOutlet weak var adjustHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var adjustButtonHeightView: UIView!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
 
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phonenumberTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var loginAndRegisterButton: UIButton!
    var ref: DatabaseReference!
    var changSegmentCount = 0
    var changButtonPosition: NSLayoutConstraint?
    let activityData = ActivityData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        emailTextField.placeholder = "Email"
        
        passwordTextField.placeholder = "Password"
        
        nameTextField.placeholder = "Your Name"
        
        phonenumberTextField.placeholder = "Your Phone Number"

        segmentedHandler()

    }
    @IBAction func forgetPassword(_ sender: UIButton) {
        
        if self.emailTextField.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailTextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func segmented(_ sender: UISegmentedControl) {
        
        segmentedHandler()

    }

    @IBAction func loginOrRegister(_ sender: UIButton) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            loginHandler()
            
        } else {
            registerHandler()
        }
        
    }
    
    func loginHandler() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
                print("Form is not valid")
                return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                print("Success Login")
                
                UserDefaults.standard.setValue(user?.uid, forKey: "UID")
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "TabBarController")
                self.present(nextVC, animated: true, completion: nil)
                
            } else {
                // 提示用戶從 firebase 返回了一個錯誤。
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func registerHandler() {
        guard let email = emailTextField.text,
                let password = passwordTextField.text,
                let name = nameTextField.text,
                let phone = phonenumberTextField.text else {
                print("Form is not valid")
                return
        }
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error == nil {
                // 計算認證信, 細部過程待補 note
                user?.sendEmailVerification { error in
                    
                    if error == nil {
                        
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                        
                        self.ref?.child("UserAccount").child((user?.uid)!).child("Email").setValue(email)
                        self.ref?.child("UserAccount").child((user?.uid)!).child("Name").setValue(name)
                        self.ref?.child("UserAccount").child((user?.uid)!).child("phone").setValue(phone)
                    }
                    
                    if let error = error {
                        print(error)
                    }
                }
                
                print("Successfully register")
                
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }

        }
    }
    
    func segmentedHandler() {
        let title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        loginAndRegisterButton.setTitle(title, for: .normal)
        
        //如果selectedSegment有變更則用動畫的方式調整name 跟 phone的ishidden狀態
        if segmentedControl.selectedSegmentIndex == 0 {
            //開啟APP時不要有動畫延遲
            adjustHeightConstrain.constant = 0
            var durationTime = 0.0
            if changSegmentCount == 0 {
                durationTime = 0.0
            } else {
                durationTime = 1.0
            }
            
            UIView.animate(withDuration: durationTime, animations: {
                //每次切換segment時洗掉文字
                self.emailTextField.text = ""
                self.passwordTextField.text = ""

                self.nameTextField.alpha = 0.0
                self.phonenumberTextField.alpha = 0.0
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                self.nameTextField.isHidden = true
                self.phonenumberTextField.isHidden = true
                self.changSegmentCount += 1
            })

        } else {

            adjustHeightConstrain.constant = 80
            self.nameTextField.isHidden = false
            self.phonenumberTextField.isHidden = false
            UIView.animate(withDuration: 1.0, animations: {
                //每次切換segment時洗掉文字
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.nameTextField.text = ""
                self.phonenumberTextField.text = ""
  
                self.nameTextField.alpha = 1.0
                self.phonenumberTextField.alpha = 1.0
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                
            })

        }

    }

}
