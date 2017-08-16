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

class PrepareToMatchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CheckIfRoomExistDelegate {
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var typeTextField: UITextField!
    
    @IBOutlet weak var greetingTextView: UITextView!
    
    @IBOutlet weak var greetingTextBackgroundView: UIView!
    
    @IBOutlet weak var userPhotoShadowView: UIView!
    
    @IBOutlet weak var introductTitleLabel: UILabel!

    var genderPickerView = UIPickerView()
    
    var typePickerView = UIPickerView()

    var genderPickOption = ["male", "female"]
    
    var typePickOption = ["Any", "pizza", "coffee", "bar"]

    var ref: DatabaseReference?
    
    weak var tabBarVC: MainTabBarController?
    
    var myLocation = CLLocation()
    
    var checkIfRoomExistManager = CheckIfRoomExistManager()
    
    var userPhotoURLString = ""
    
    weak var nearbyViewController: NearbyViewController?
    
    let activityData = ActivityData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //swiftlint:disable force_cast
        
        tabBarVC = self.tabBarController as! MainTabBarController
        nearbyViewController = tabBarVC?.nearbyViewController as! NearbyViewController
        myLocation = nearbyViewController!.currentLocation
        
        //swiftlint:enable force_cast
        
        self.userPhotoURLString = (tabBarVC?.userPhotoURLString) ?? ""
        
        myLocation = nearbyViewController!.currentLocation
        
        genderPickerView.delegate = self
        
        genderTextField.inputView = genderPickerView
        
        genderTextField.text = genderPickOption[0]
        
        typePickerView.delegate = self
        
        typeTextField.inputView = typePickerView
        
        typeTextField.text = typePickOption[0]
        
        ref = Database.database().reference()
        
        self.checkIfRoomExistManager.delegate = self
        
        // layout
        
        setUpLayout()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setUpUserPhoto()
        
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
        
        guard let type = typeTextField.text else {
            return
        }

        self.checkIfRoomExistManager.checkIfRoomExist(type: type)
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
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
    
    deinit {
        print("LoadingViewController")
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
        
        var userId = UserDefaults.standard.value(forKey: "UID") as? String ?? ""
        
        let todayUnformate = Date()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm:ss"
        
        let today = dateFormatter.string(from: todayUnformate)
        
        guard let type = typeTextField.text,
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
            "Connection": "nil"]
        
        let ownerMatchInfoData: [String: String] = ["nickName": nickName,
                                                    "gender": gender,
                                                    "greetingText": greetingText,
                                                    "UserPhotoURL": self.userPhotoURLString]
        
        self.ref?.child("Match Room").child(type).child(matchRoomAutoId).updateChildValues(newRoomData)
        
        self.ref?.child("Match Info").child(type).child(matchInfoAutoId).updateChildValues(ownerMatchInfoData)
        
        self.performSegue(withIdentifier: "ownerLoading", sender: matchRoomAutoId)
        
    }

}
