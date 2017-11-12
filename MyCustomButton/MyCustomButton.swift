//
//  MyCustomButton.swift
//  MyCustomButton
//
//  Created by Benjamin Pisano on 09/11/2017.
//  Copyright © 2017 Benjamin Pisano. All rights reserved.
//

import UIKit

enum MyCustomButtonState {
    case normal
    case inactive
}

protocol MyCustomButtonDelegate {
    func didChangeState(_ button: MyCustomButton, state: MyCustomButtonState)
}

class MyCustomButton: UIButton {

    private var bottomConstraint: NSLayoutConstraint?       // Keyboard
    private var defaultBottomConstraint: CGFloat? = 16      // Keyboard
    var currentState: MyCustomButtonState = .normal
    var fixedToKeyboard: Bool = true
    var delegate: MyCustomButtonDelegate?
    
    override func awakeFromNib() {
        initUi()
        initNotifications()
    }
    
    func initUi() {
        // Background color
        self.backgroundColor = UIColor.myCustomBlue
        self.setTitleColor(UIColor.white, for: .normal)
        
        // Rounded corner
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        // Bottom constraint
        if let bottom = self.superview!.constraints.filter({ $0.identifier == "bottom" }).first {
            bottomConstraint = bottom
        }
    }
    
    func initNotifications() {
        // Handle keyboard event
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    
    
    
    //////////////
    // Keyboard //
    //////////////
    
    @objc private func keyboardUp(notification: NSNotification) {
        // Execute only if fixedToKeyoboard is true
        guard fixedToKeyboard else {
            return
        }
        
        // Notifications infos
        let info = notification.userInfo!
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = info[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        // Bottom constraint animation
        bottomConstraint?.constant = defaultBottomConstraint! + keyboardSize.height
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
            self.superview?.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func keyboardDown(notification: NSNotification) {
        // Execute only if fixedToKeyoboard is true
        guard fixedToKeyboard else {
            return
        }
        
        // Notifications infos
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        
        // Bottom constraint animation
        bottomConstraint?.constant = defaultBottomConstraint!
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
            self.superview?.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    
    
    ////////////
    // States //
    ////////////
    
    func set(_ state: MyCustomButtonState) {
        // Execute only if currentState is different of new state
        guard state != currentState else {
            return
        }
        
        // Setting the currentState to the new state
        // then animate the change
        currentState = state
        switch state {
        case .normal:
            normalState()
        default:
            inactiveState()
        }
    }
    
    private func normalState() {
        // Setting user interaction to true
        // and animate background color to blue
        delegate?.didChangeState(self, state: .normal)
        isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
            self.backgroundColor = UIColor.myCustomBlue
        }
    }
    
    private func inactiveState() {
        // Setting user interaction to false
        // and animate background color to gray
        delegate?.didChangeState(self, state: .inactive)
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.5
            self.backgroundColor = UIColor.lightGray
        }
    }
}
