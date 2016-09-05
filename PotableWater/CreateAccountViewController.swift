//
//  CreateAccountViewController.swift
//  PotableWater
//
//  Created by Voicu Narcis on 03/09/2016.
//  Copyright © 2016 Voicu Narcis. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MobileCoreServices


class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userNameTf: UITextField!
    @IBOutlet weak var userEmailTf: UITextField!
    @IBOutlet weak var userPasswordTf: UITextField!
    @IBOutlet weak var addProfilePicBtn: UIButton!
    @IBOutlet weak var createAccountBtn: UIButton!
    
    @IBOutlet weak var checkLbl: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    var imageData: NSData!
    var base64String: NSString!
    
    @IBAction func addProfilePicAction(sender: UIButton) {
        let ac = UIAlertController(title: "Alege poza de profil", message: "De unde alegi poza?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        ac.addAction(UIAlertAction(title: "Deschide galeria", style: UIAlertActionStyle.Default, handler: { (alert) in
            self.addImages()
        }))
        ac.addAction(UIAlertAction(title: "Porneste camera", style: UIAlertActionStyle.Default, handler: { (alert) in
            self.openCamera()
        }))
        presentViewController(ac, animated: true, completion: nil)
    }
   
    
    @IBAction func createAccountAction(sender: UIButton) {
        
        let name = userNameTf.text
        let email = userEmailTf.text
        let pass = userPasswordTf.text
        
        guard (name != "" || email != "") else {
            PotableWaterUtils.createOKAlertController(self, title: "Eroare", message: "Te rugam sa completezi toate campurile")
            return
        }
        
        guard (checkImage.hidden == false && checkLbl.hidden == false) else {
            PotableWaterUtils.createOKAlertController(self, title: "Eroare", message: "Te rugam sa introduci o imagine")
            return
        }
        
        imageToBase64()
       
        FIRAuth.auth()?.createUserWithEmail(email!, password: pass!, completion: { (user, error) in
            if let error = error {
                PotableWaterUtils.createOKAlertController(self, title: "A aparut o eroare", message: error.localizedDescription)
                return
            }
            let userDictionary = ["email": email!, "name": name!, "image": self.base64String!]
            DataService.createUser(user!.uid, user: userDictionary)
            PotableWaterUtils.createOKAlertController(self, title:"Succes", message: "User-ul tau a fost creat")
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.hidden = false
        
        hideCheck()
        
        PotableWaterUtils.customizeTextFields(userNameTf, placeholder: "Introdu-ti numele", backgroundColor: UIColor.clearColor(), textColor: UIColor.whiteColor(), borderColor: UIColor.whiteColor())
        PotableWaterUtils.customizeTextFields(userEmailTf, placeholder: "Introdu-ti emailul", backgroundColor: UIColor.clearColor(), textColor: UIColor.whiteColor(), borderColor: UIColor.whiteColor())
        PotableWaterUtils.customizeTextFields(userPasswordTf, placeholder: "********", backgroundColor: UIColor.clearColor(), textColor: UIColor.whiteColor(), borderColor: UIColor.whiteColor())
        PotableWaterUtils.customizeButton(addProfilePicBtn, backgroundColor: UIColor.clearColor(), textColor: UIColor.whiteColor(), borderColor: UIColor.whiteColor())
        PotableWaterUtils.customizeButton(createAccountBtn, backgroundColor: PotableWaterUtils.createAccountRed, textColor: UIColor.whiteColor(), borderColor: PotableWaterUtils.createAccountRed)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Add image
    
    func addImages(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType =
                UIImagePickerControllerSourceType.Camera
            picker.mediaTypes = [kUTTypeImage  as String]
            picker.allowsEditing = true
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        
        if let possibleImage = info[UIImagePickerControllerEditedImage]{
            newImage = possibleImage as! UIImage
        } else if let possibleImage = info[UIImagePickerControllerOriginalImage]{
            newImage = possibleImage as! UIImage
        } else {
            return
        }
        
        if let jpegData = UIImagePNGRepresentation(newImage){
            imageData = jpegData
        }
        
        unhideCheck()
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageToBase64(){
        base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    }
    
    // MARK: - Hide / Unhide elements
    
    func hideCheck(){
        checkLbl.hidden = true
        checkImage.hidden = true
    }
    
    func unhideCheck(){
        checkLbl.hidden = false
        checkImage.hidden = false
    }
    
    // MARK: - Dismiss keyboard
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
