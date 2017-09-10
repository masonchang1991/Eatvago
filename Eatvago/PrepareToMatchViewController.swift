//
//  PrepareToMatchViewController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/9.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import NVActivityIndicatorView
import SCLAlertView
import SkyFloatingLabelTextField
import FaveButton

class PrepareToMatchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CheckIfRoomExistDelegate, UITextViewDelegate {
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var typeTextField: UITextField!
    
    @IBOutlet weak var greetingTextView: UITextView!
    
    @IBOutlet weak var greetingTextBackgroundView: UIView!
    
    @IBOutlet weak var userPhotoShadowView: UIView!
    
    @IBOutlet weak var introductTitleLabel: UILabel!
    
    @IBOutlet weak var matchButton: FaveButton!
    
    var genderPickerView = UIPickerView()
    
    var typePickerView = UIPickerView()

    var genderPickOption = ["Man", "Woman"]
    
    var typePickOption = ["Any", "pizza", "coffee", "bar", "japan", "chinese"]

    var ref: DatabaseReference?
    
    weak var tabBarVC: MainTabBarController?
    
    var myLocation = CLLocation()
    
    var checkIfRoomExistManager = CheckIfRoomExistManager()
    
    var userPhotoURLString = ""
    
    weak var nearbyViewController: NearbyViewController?
    
    let activityData = ActivityData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        genderPickerView.delegate = self
        
        genderTextField.inputView = genderPickerView
        
        genderTextField.text = genderPickOption[0]
        
        typePickerView.delegate = self
        
        typeTextField.inputView = typePickerView
        
        typeTextField.text = typePickOption[0]
        
        greetingTextView.delegate = self
        
        ref = Database.database().reference()
        
        self.checkIfRoomExistManager.delegate = self
        
        // layout
        
        setUpLayout()
        
        //收keyboard
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        guard
            let tabBarVC = self.tabBarController as? MainTabBarController,
            let nearbyViewController = tabBarVC.nearbyViewController as? NearbyViewController else {
                    return
        }
        
        myLocation = nearbyViewController.currentLocation
        
        self.userPhotoURLString = tabBarVC.userPhotoURLString
        
        setUpUserPhoto()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
         setupLayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
            
            case genderPickerView:
                
                return genderPickOption.count
            
            case typePickerView:
                
                return typePickOption.count
            
            default: return 0
            
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
            
            case genderPickerView:
                
                return genderPickOption[row]
            
            case typePickerView:
                
                return typePickOption[row]
            
            default: return "default"
            
        }

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
            
        case genderPickerView:
            
            genderTextField.text = genderPickOption[row]
            
        case typePickerView:
            
            typeTextField.text = typePickOption[row]
            
        default: print("default")
            
        }

    }
    
    @IBAction func matchButton(_ sender: Any) {
        
        guard let type = typeTextField.text else { return }
        
        if nickNameTextField.text?.characters.count == 0 {
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "Chalkboard SE", size: 25)!,
                kTextFont: UIFont(name: "Chalkboard SE", size: 16)!,
                kButtonFont: UIFont(name: "Chalkboard SE", size: 18)!,
                showCloseButton: false,
                showCircularIcon: false
            )
            
            // Initialize SCLAlertView using custom Appearance
            let alert = SCLAlertView(appearance: appearance)
            
            alert.addButton("OK", backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6), textColor: UIColor.white, showDurationStatus: false) {
                
                alert.dismiss(animated: true, completion: nil)
            }
            
            self.matchButton.isSelected = false
            
            alert.showError("Error", subTitle: "you forgot your nick name")
            
        } else {
            
            self.checkIfRoomExistManager.checkIfRoomExist(type: type)
            
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
            
            self.matchButton.isSelected = false
            
            Analytics.logEvent("prepareTo_matchbutton", parameters: nil)
            
        }
//      self.performSegue(withIdentifier: "matchLoading", sender: matchRoomAutoId)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let loadingVC = segue.destination as? LoadingMatchViewController ?? LoadingMatchViewController()
        
        if segue.identifier == "ownerLoading" {
            
            loadingVC.isARoomOwner = true
            
        } else {
            
            loadingVC.isARoomOwner = false
            
        }
        
        guard let roomId = sender as? String else { return }
        
        loadingVC.type = self.typeTextField.text ?? ""
        
        loadingVC.myName = nickNameTextField.text ?? ""
       
        loadingVC.myGender = genderTextField.text ?? ""
        
        loadingVC.myGeetingText = greetingTextView.text ?? ""
        
        loadingVC.myPhotoImage = userPhotoImageView.image ?? UIImage()
        
        loadingVC.matchRoomId = roomId
        
    }
    
    func manager(_ manager: CheckIfRoomExistManager, didGet roomId: String) {
        
        let userId = UserDefaults.standard.value(forKey: "UID") as? String ?? ""
        
        guard let type = typeTextField.text,
            let gender = genderTextField.text,
            let nickName = nickNameTextField.text,
            let greetingText = greetingTextView.text,
            let matchInfoAutoId = self.ref?.childByAutoId().key,
            let myLocationLat = myLocation.coordinate.latitude as? Double,
            let myLocationLon = myLocation.coordinate.longitude as? Double else {
                return
        }
        
        let attenderMatchInfoData: [String: String] = ["nickName": nickName,
                                                       "gender": gender,
                                                       "greetingText": greetingText,
                                                       "UserPhotoURL": self.userPhotoURLString]
        
        let attenderRoomData: [String: Any] = [
                                          "isLocked": true,
                                          "attender": userId,
                                          "attenderLocationLat": "\(myLocationLat)",
                                          "attenderLocationLon": "\(myLocationLon)",
                                          "attenderMatchInfo": matchInfoAutoId]
        
        self.ref?.child("Match Room").child(type).child(roomId).updateChildValues(attenderRoomData)
        
        self.ref?.child("Match Info").child(type).child(matchInfoAutoId).updateChildValues(attenderMatchInfoData)
        
        self.performSegue(withIdentifier: "attenderLoading", sender: roomId)
        
    }
    
    func manager(_ manager: CheckIfRoomExistManager, be roomOwner: String) {
        
        guard let userId = UserDefaults.standard.value(forKey: "UID") as? String else {
            
            fatalError("userId didn't get")

        }
        
        let todayUnformate = Date()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm:ss"
        
        let today = dateFormatter.string(from: todayUnformate)
        
        guard
            let type = typeTextField.text,
            let gender = genderTextField.text,
            let nickName = nickNameTextField.text,
            let greetingText = greetingTextView.text,
            let matchRoomAutoId = self.ref?.childByAutoId().key,
            let matchInfoAutoId = self.ref?.childByAutoId().key,
            let myLocationLat = myLocation.coordinate.latitude as? Double,
            let myLocationLon = myLocation.coordinate.longitude as? Double else {
                
                return
        }
        
        let newRoomData: [String: Any] = ["isClosed": false,
                                          "isLocked": false,
                                          "owner": userId,
                                          "ownerLocationLat": "\(myLocationLat)",
                                          "ownerLocationLon": "\(myLocationLon)",
                                          "ownerMatchInfo": matchInfoAutoId,
                                          "attender": "nil",
                                          "attenderLocationLat": "nil",
                                          "attenderLocationLon": "nil",
                                          "attenderMatchInfo": "nil",
                                          "createdDate": today,
                                          "Connection": "nil"
                                         ]
        
        let ownerMatchInfoData: [String: String] = ["nickName": nickName,
                                                    "gender": gender,
                                                    "greetingText": greetingText,
                                                    "UserPhotoURL": self.userPhotoURLString]
        
        self.ref?.child("Match Room").child(type).child(matchRoomAutoId).updateChildValues(newRoomData)
        
        self.ref?.child("Match Info").child(type).child(matchInfoAutoId).updateChildValues(ownerMatchInfoData)
        
        self.performSegue(withIdentifier: "ownerLoading", sender: matchRoomAutoId)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Say something" {
            
            textView.text = ""
            
        }
        
    }

}
