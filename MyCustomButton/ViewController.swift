//
//  ViewController.swift
//  MyCustomButton
//
//  Created by Benjamin Pisano on 07/11/2017.
//  Copyright © 2017 Benjamin Pisano. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MyCustomButtonDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var myCustomButton: MyCustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCustomButton.set(.inactive)
        myCustomButton.delegate = self
    }
    
    
    
    
    ////////////////////////////
    // MyCustomButtonDelegate //
    ////////////////////////////
    
    func didChangeState(_ button: MyCustomButton, state: MyCustomButtonState) {
        print(state)
    }
    
    
    
    
    ///////////////
    // TextField //
    ///////////////
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
        textField2.resignFirstResponder()
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        if textField.text == "" || textField2.text == "" {
            myCustomButton.set(.inactive)
        }
        else {
            myCustomButton.set(.normal)
        }
    }
}
