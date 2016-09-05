//
//  ViewController.swift
//  PotableWater
//
//  Created by Voicu Narcis on 03/09/2016.
//  Copyright © 2016 Voicu Narcis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class WelcomeViewController: UIViewController {

    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var blurEffect: UIBlurEffect!
    var blurEffectView: UIVisualEffectView!
    var popup: UIView!
    var chooseWhatToOpen: UILabel!
    var openBottles: UIButton!
    var openSources: UIButton!
    
    var activityIndicator: UIActivityIndicatorView!
    
    var userName = String()
    
    @IBAction func loginAction(sender: UIButton) {
        let email = emailTf.text
        let password = passwordTf.text
        
        addActivityIndicator()
        
        FIRAuth.auth()?.signInWithEmail(email!, password: password!) { (user, error) in
            if let error = error {
                print("Eroare la logare: \(error.localizedDescription)")
                PotableWaterUtils.createOKAlertController(self, title: "Eroare", message: error.description)
                self.removeActivityIndicator()
                return
            }
            print("Email-ul userului logat: \(user?.email)")
            
            print("Nume: \(user?.displayName)")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            self.removeActivityIndicator()
            //self.signedIn(user!)
        }
    }
    
    
    @IBAction func continuaNelogatAction(sender: UIButton) {
        popup = UIView(frame: CGRect(x: view.center.x - 130, y: view.center.y - 110, width: 260, height: 220))
        createPopup()
        
        chooseWhatToOpen = UILabel(frame: CGRect(x: 10, y: 20, width: 230, height: 45))
        chooseWhatToOpen.text = "Ce vrei sa vezi in continuare?"
        chooseWhatToOpen.textColor = UIColor.blackColor()
        chooseWhatToOpen.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 18)
        chooseWhatToOpen.lineBreakMode = NSLineBreakMode.ByWordWrapping
        chooseWhatToOpen.numberOfLines = 0
        chooseWhatToOpen.textAlignment = NSTextAlignment.Center
        
        openBottles = UIButton(frame: CGRect(x: 10, y: 100, width: 230, height: 45))
        openBottles.setTitle("Lista companiilor", forState: UIControlState.Normal)
        openBottles.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        PotableWaterUtils.customizeButton(openBottles, backgroundColor: PotableWaterUtils.orangeColor, textColor: UIColor.whiteColor(), borderColor: PotableWaterUtils.orangeColor)
        openBottles.addTarget(self, action: #selector(self.goToBottlesDetails), forControlEvents: UIControlEvents.TouchUpInside)
        
        openSources = UIButton(frame: CGRect(x: 10, y: 155, width: 230, height: 45))
        openSources.setTitle("Harta surselor", forState: UIControlState.Normal)
        openSources.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        PotableWaterUtils.customizeButton(openSources, backgroundColor: PotableWaterUtils.loginBlue, textColor: UIColor.whiteColor(), borderColor: PotableWaterUtils.loginBlue)
        openSources.addTarget(self, action: #selector(self.goToSourceDetails), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        showPopup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navigationBar.shadowImage = UIImage()
            navigationBar.translucent = true
            navigationController?.view.backgroundColor = .clearColor()
        }
        
      //  navigationController?.navigationBar.hidden = true
        
        PotableWaterUtils.customizeButton(loginBtn, backgroundColor: PotableWaterUtils.loginBlue, textColor: UIColor.whiteColor(), borderColor: PotableWaterUtils.loginBlue)
        PotableWaterUtils.customizeTextFields(emailTf, placeholder: "Adresa de email", backgroundColor: UIColor.clearColor(), textColor: UIColor.whiteColor(), borderColor: UIColor.whiteColor())
        PotableWaterUtils.customizeTextFields(passwordTf, placeholder: "*********", backgroundColor: UIColor.clearColor(), textColor: UIColor.whiteColor(), borderColor: UIColor.whiteColor())
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Popup Methods
    
    func createPopup(){
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        
        popup.backgroundColor = UIColor.whiteColor()
        popup.layer.cornerRadius = 10
        popup.layer.borderWidth = 2
        popup.layer.borderColor = PotableWaterUtils.orangeColor.CGColor
        popup.layer.shadowColor = PotableWaterUtils.shadowBlue.CGColor
        popup.layer.shadowOpacity = 5
        popup.layer.shadowOffset = CGSizeZero
        popup.layer.shadowRadius = 10
        
    }
    
    func uiElementsAlphaZero(){
        blurEffectView.alpha = 0
        popup.alpha = 0
        chooseWhatToOpen.alpha = 0
        openBottles.alpha = 0
        openSources.alpha = 0
    }
    
    func uiElementsAlphaOne(){
        blurEffectView.alpha = 1
        popup.alpha = 1
        chooseWhatToOpen.alpha = 1
        openBottles.alpha = 1
        openSources.alpha = 1
    }
    
    func uiElementsRemoveFromSuperview(){
        blurEffectView.removeFromSuperview()
        popup.removeFromSuperview()
        chooseWhatToOpen.removeFromSuperview()
        openBottles.removeFromSuperview()
        openSources.removeFromSuperview()
    }
    
    func uiElementsAddSubview(){
        view.addSubview(blurEffectView)
        view.addSubview(popup)
        popup.addSubview(chooseWhatToOpen)
        popup.addSubview(openBottles)
        popup.addSubview(openSources)
    }
    
    func showPopup(){
        uiElementsAlphaZero()
        uiElementsAddSubview()
        UIView.animateWithDuration(0.5) { () -> Void in
            self.uiElementsAlphaOne()
        }
    }
    
    func dismissPopup(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.uiElementsAlphaZero()
        }) { (Bool) -> Void in
            self.uiElementsRemoveFromSuperview()
        }
    }
    
    // MARK: - Touch outside popup
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let bottlePop = popup{
            if event?.touchesForView(bottlePop) == nil{
                UIView.animateWithDuration(0.5, animations: {
                    self.dismissPopup()
                })
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Activity indicator
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "loginSegue"{
//            if let userProfile = segue.destinationViewController as? UsersFirstViewController{
//               userProfile.userNameString =
//            }
//        }
    }
    
    func goToBottlesDetails(){
        self.performSegueWithIdentifier("showBottlesSegue", sender: nil)
    }

    func goToSourceDetails(){
        self.performSegueWithIdentifier("showSourcesSegue", sender: nil)
    }

}

