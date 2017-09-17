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
import SCLAlertView

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
        
        //收keyboard
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        UIApplication.shared.statusBarStyle = .default
        
        Analytics.logEvent("Login_viewDidLoad", parameters: nil)

    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        
         NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        Analytics.logEvent("Login_forgetPassword", parameters: nil)
        
        if self.emailTextField.text == "" {

            let appearance = SCLAlertView.SCLAppearance(
                
                kTitleFont: UIFont(name: "Chalkboard SE", size: 25)!,
                kTextFont: UIFont(name: "Chalkboard SE", size: 14)!,
                kButtonFont: UIFont(name: "Chalkboard SE", size: 18)!,
                showCloseButton: false,
                showCircularIcon: false
                
            )
            
            // Initialize SCLAlertView using custom Appearance
            let alert = SCLAlertView(appearance: appearance)
            
            alert.addButton("ok", backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6),
                            textColor: UIColor.white,
                            showDurationStatus: false) {
                
                alert.dismiss(animated: true, completion: nil)
                                
            }
            
            alert.showWarning("Oops!", subTitle: "Please enter your email.")
            
             NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
        } else {
            
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!,
                                          completion: { (error) in
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
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
                
                let appearance = SCLAlertView.SCLAppearance(
                    
                    kTitleFont: UIFont(name: "Chalkboard SE", size: 25)!,
                    kTextFont: UIFont(name: "Chalkboard SE", size: 14)!,
                    kButtonFont: UIFont(name: "Chalkboard SE", size: 18)!,
                    showCloseButton: false,
                    showCircularIcon: false
                    
                )
                
                // Initialize SCLAlertView using custom Appearance
                let alert = SCLAlertView(appearance: appearance)
                
                alert.addButton("ok",
                                backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6),
                                textColor: UIColor.white,
                                showDurationStatus: false) {
                    
                    alert.dismiss(animated: true, completion: nil)
                                    
                }
                
                alert.showSuccess(title, subTitle: message)

            })
        }
    }
    
    @IBAction func segmented(_ sender: UISegmentedControl) {
        
        segmentedHandler()

    }

    @IBAction func loginOrRegister(_ sender: UIButton) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            Analytics.logEvent("Login_login", parameters: nil)
            
            loginHandler()
            
        } else {
            
            Analytics.logEvent("Login_register", parameters: nil)
            
            registerHandler()
        }
        
    }
    
    func loginHandler() {
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text else {
                
                print("Form is not valid")
                
                return
        }
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error == nil {
                
                print("Success Login")
                
                UserDefaults.standard.setValue(user?.uid, forKey: "UID")
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                let window = UIApplication.shared.windows[0] as UIWindow
                
                window.makeKeyAndVisible()
                
                let storyBoard = UIStoryboard(name: "Main",
                                              bundle: nil)
                
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "TabBarController")
                
                window.rootViewController = nextVC
                
            } else {
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                let appearance = SCLAlertView.SCLAppearance(
                    
                    kTitleFont: UIFont(name: "Chalkboard SE", size: 25)!,
                    kTextFont: UIFont(name: "Chalkboard SE", size: 14)!,
                    kButtonFont: UIFont(name: "Chalkboard SE", size: 18)!,
                    showCloseButton: false,
                    showCircularIcon: false
                    
                )

                let alert = SCLAlertView(appearance: appearance)
                
                alert.addButton("ok",
                                backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6),
                                textColor: UIColor.white,
                                showDurationStatus: false) {
                    
                    alert.dismiss(animated: true, completion: nil)
                                    
                }
                
                alert.showWarning("Error", subTitle: error?.localizedDescription ?? "")
                
            }
        }
    }
    
    func registerHandler() {
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text,
            let phone = phonenumberTextField.text else {
                
                print("Form is not valid")
                
                return
        }
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error == nil {
//                // 計算認證信, 細部過程待補 note
//                user?.sendEmailVerification { error in
//                    
//                    if error == nil {
            
                        self.ref?.child("UserAccount").child((user?.uid)!).child("Email").setValue(email)
                
                        self.ref?.child("UserAccount").child((user?.uid)!).child("Name").setValue(name)
                
                        self.ref?.child("UserAccount").child((user?.uid)!).child("phone").setValue(phone)

                        let appearance = SCLAlertView.SCLAppearance(
                            
                            kTitleFont: UIFont(name: "Chalkboard SE", size: 25)!,
                            kTextFont: UIFont(name: "Chalkboard SE", size: 14)!,
                            kButtonFont: UIFont(name: "Chalkboard SE", size: 18)!,
                            showCloseButton: false,
                            showCircularIcon: false
                            
                        )
                        
                        // Initialize SCLAlertView using custom Appearance
                        let alert = SCLAlertView(appearance: appearance)
                        
                        alert.addButton("Sure",
                                        backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6),
                                        textColor: UIColor.white,
                                        showDurationStatus: false) {
                        
                            self.ref?.child("UserAccount").child((user?.uid)!).child("Email").setValue(email)
                            
                            self.ref?.child("UserAccount").child((user?.uid)!).child("Name").setValue(name)
                            
                            self.ref?.child("UserAccount").child((user?.uid)!).child("phone").setValue(phone)
                            
                            alert.dismiss(animated: true, completion: nil)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                
                                UserDefaults.standard.setValue(user?.uid, forKey: "UID")
                            
                                let window = UIApplication.shared.windows[0] as UIWindow
                                
                                window.makeKeyAndVisible()
                                
                                let storyBoard = UIStoryboard(name: "Main",
                                                              bundle: nil)
                                
                                let nextVC = storyBoard.instantiateViewController(withIdentifier: "TabBarController")
                                
                                window.rootViewController = nextVC

                            }
                            
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {

                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {

                            alert.showNotice("Done",
                                            subTitle: "Welcome to Eatvago!",
                                            circleIconImage: nil)
                                
                            }
                            
                        }
                
//                        alert.showNotice("Verification",
//                                         subTitle: "Your have to check your email",
//                                         circleIconImage: nil)

//                    }

//                }
            
                print("Successfully register")
                
            } else {
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

                let appearance = SCLAlertView.SCLAppearance(
                    
                    kTitleFont: UIFont(name: "Chalkboard SE", size: 25)!,
                    kTextFont: UIFont(name: "Chalkboard SE", size: 14)!,
                    kButtonFont: UIFont(name: "Chalkboard SE", size: 18)!,
                    showCloseButton: false,
                    showCircularIcon: false
                    
                )

                let alert = SCLAlertView(appearance: appearance)
                
                alert.addButton("ok",
                                backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6),
                                textColor: UIColor.white,
                                showDurationStatus: false) {
                    
                    alert.dismiss(animated: true, completion: nil)
                                    
                }
                
                alert.showNotice("Error",
                                 subTitle: error?.localizedDescription ?? "",
                                 circleIconImage: nil)
                
            }

        }
    }
    
    func segmentedHandler() {
        
        let title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        
        guard let titleString = title else { return }
        
        loginAndRegisterButton.setTitle("   \(titleString)   ", for: .normal)
        
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
