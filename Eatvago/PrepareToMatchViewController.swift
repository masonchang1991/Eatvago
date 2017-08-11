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

class PrepareToMatchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CheckIfRoomExistDelegate {

    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var typeTextField: UITextField!

    @IBOutlet weak var distanceTextField: UITextField!
    
    var genderPickerView = UIPickerView()
    
    var typePickerView = UIPickerView()
    
    var distancePickerView = UIPickerView()

    var genderPickOption = ["male", "female"]
    
    var typePickOption = ["pizza", "coffee", "bar"]
    
    var distancePickOption = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]

    var ref: DatabaseReference?
    
    var tabBarVC: MainTabBarController = MainTabBarController()
    
    var myLocation = CLLocation()
    
    var checkIfRoomExistManager = CheckIfRoomExistManager()
    
    override func viewDidLoad() {
        
        tabBarVC = self.tabBarController as? MainTabBarController ?? MainTabBarController()
        
        let nearbyViewController = tabBarVC.nearbyViewController as? NearbyViewController ?? NearbyViewController()
        
        myLocation = nearbyViewController.currentLocation
        
        super.viewDidLoad()
        
        genderPickerView.delegate = self
        
        genderTextField.inputView = genderPickerView
        
        typePickerView.delegate = self
        
        typeTextField.inputView = typePickerView
        
        distancePickerView.delegate = self
        
        distanceTextField.inputView = distancePickerView
        
        ref = Database.database().reference()
        
        self.checkIfRoomExistManager.delegate = self
    
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
        case distancePickerView:
            return distancePickOption.count
            default: return 0
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
        case genderPickerView:
            return genderPickOption[row]
        case typePickerView:
            return typePickOption[row]
        case distancePickerView:
            return "\(distancePickOption[row])"
        default: return "default"
        }

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
        case genderPickerView:
            genderTextField.text = genderPickOption[row]
        case typePickerView:
            typeTextField.text = typePickOption[row]
        case distancePickerView:
            distanceTextField.text = "\(distancePickOption[row])"
            default: print("default")
        }

    }
    
    @IBAction func matchButton(_ sender: Any) {
        
        guard let type = typeTextField.text else {
            return
        }

        self.checkIfRoomExistManager.checkIfRoomExist(type: type)
        
//        self.performSegue(withIdentifier: "matchLoading", sender: matchRoomAutoId)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let loadingVC = segue.destination as? LoadingMatchViewController ?? LoadingMatchViewController()
        
        if segue.identifier == "ownerLoading" {
            
            let loadingVC = segue.destination as? LoadingMatchViewController ?? LoadingMatchViewController()
            
            loadingVC.isARoomOwner = true
            
        } else {
            
            let loadingVC = segue.destination as? LoadingMatchViewController ?? LoadingMatchViewController()
            
            loadingVC.isARoomOwner = false
            
        }
        
        guard let roomId = sender as? String else { return }
        
        loadingVC.type = self.typeTextField.text ?? ""
        
        loadingVC.matchRoomId = roomId
        
    }
    
    
    func manager(_ manager: CheckIfRoomExistManager, didGet roomId: String) {
        
        var userId = UserDefaults.standard.value(forKey: "UID") as? String ?? ""
        
        guard let type = typeTextField.text,
            let gender = genderTextField.text,
            let nickName = nickNameTextField.text,
            let matchInfoAutoId = self.ref?.childByAutoId().key,
            let myLocationLat = myLocation.coordinate.latitude as? Double,
            let myLocationLon = myLocation.coordinate.longitude as? Double else {
                return
        }
        
        var attenderMatchInfoData: [String: String] = ["nickName": nickName, "gender": gender]
        
        var attenderRoomData: [String: Any] = ["finished": true,
                                          "locked": true,
                                          "attender": userId,
                                          "attenderLocationLat": "\(myLocationLat)",
                                          "attenderLocationLon": "\(myLocationLon)",
                                          "attenderMatchInfo": matchInfoAutoId]
        
        self.ref?.child("Match Room").child(type).child(roomId).updateChildValues(attenderRoomData)
        
        self.ref?.child("Match Info").child(type).child(roomId).updateChildValues(attenderMatchInfoData)
        
        self.performSegue(withIdentifier: "attenderLoading", sender: roomId)
        
    }
    
    func manager(_ manager: CheckIfRoomExistManager, be roomOwner: String) {
        
        var userId = UserDefaults.standard.value(forKey: "UID") as? String ?? ""
        
        let today = Date().description
        
        guard let type = typeTextField.text,
            let gender = genderTextField.text,
            let nickName = nickNameTextField.text,
            let matchRoomAutoId = self.ref?.childByAutoId().key,
            let matchInfoAutoId = self.ref?.childByAutoId().key,
            let myLocationLat = myLocation.coordinate.latitude as? Double,
            let myLocationLon = myLocation.coordinate.longitude as? Double else {
                return
        }
        
        var newRoomData: [String: Any] = ["finished": false,
                                          "locked": false,
                                          "owner": userId,
                                          "ownerLocationLat": "\(myLocationLat)",
            "ownerLocationLon": "\(myLocationLon)",
            "ownerMatchInfo": matchInfoAutoId,
            "attender": "nil",
            "attenderLocationLat": "nil",
            "attenderLocationLon": "nil",
            "attenderMatchInfo": "nil",
            "createdDate": today]
        
        var ownerMatchInfoData: [String: String] = ["nickName": nickName, "gender": gender]
        
        self.ref?.child("Match Room").child(type).child(matchRoomAutoId).updateChildValues(newRoomData)
        
        self.ref?.child("Match Info").child(type).child(matchInfoAutoId).updateChildValues(ownerMatchInfoData)
        
        
        
        self.performSegue(withIdentifier: "ownerLoading", sender: matchRoomAutoId)
        
    }

}
