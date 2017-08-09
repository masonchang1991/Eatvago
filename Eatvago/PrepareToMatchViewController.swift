//
//  PrepareToMatchViewController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/9.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

class PrepareToMatchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var typeTextField: UITextField!

    @IBOutlet weak var distanceTextField: UITextField!
    
    
    var pickOption = ["one", "two", "three", "seven", "fifteen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        nickNameTextField.inputView = pickerView
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }


    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nickNameTextField.text = pickOption[row]
    }

}
