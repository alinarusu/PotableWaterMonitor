//
//  PotableAppUtils.swift
//  PotableWater
//
//  Created by Voicu Narcis on 03/09/2016.
//  Copyright © 2016 Voicu Narcis. All rights reserved.
//

import Foundation
import UIKit

class PotableWaterUtils {
    
    static let orangeColor = UIColor(red: 241/255, green: 115/255, blue: 0/255, alpha: 1.0)
    static let shadowBlue = UIColor(red: 5/255, green: 74/255, blue: 145/255, alpha: 1.0)
    static let loginBlue = UIColor(red: 10/255, green: 153/255, blue: 255/255, alpha: 1.0)
    static let createAccountRed = UIColor(red: 237/255, green: 73/255, blue: 52/255, alpha: 1.0)
    static let strangeYellow = UIColor(red: 249/255, green: 231/255, blue: 132/255, alpha: 1.0)
    
    
    static func customizeTextFields(textfield: UITextField, placeholder: String, backgroundColor: UIColor, textColor: UIColor, borderColor: UIColor){
        textfield.layer.cornerRadius = 20
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName : textColor])
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = borderColor.CGColor
        textfield.backgroundColor = backgroundColor
        textfield.textColor = textColor
        textfield.textAlignment = NSTextAlignment.Center
    }
    
    static func customizeButton(button: UIButton, backgroundColor: UIColor, textColor: UIColor, borderColor: UIColor){
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = borderColor.CGColor
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, forState: UIControlState.Normal)
    }
    
    static func createOKAlertController(viewController: UIViewController, title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(ac, animated: true, completion: nil)
    }
    
    
}
