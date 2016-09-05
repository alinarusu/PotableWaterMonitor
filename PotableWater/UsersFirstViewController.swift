//
//  UsersFirstViewController.swift
//  PotableWater
//
//  Created by Voicu Narcis on 03/09/2016.
//  Copyright © 2016 Voicu Narcis. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MobileCoreServices
import CoreLocation
import MapKit


class UsersFirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var addBottleBtn: UIButton!
    @IBOutlet weak var addSourceBtn: UIButton!
    @IBOutlet weak var userHistoryView: UIView!
    @IBOutlet weak var numberOfSourcesAdded: UILabel!
    @IBOutlet weak var numberOfBottlesAdded: UILabel!
    
    var blurEffect: UIBlurEffect!
    var blurEffectView: UIVisualEffectView!
    var popupBottle: UIView!
    var popupSource: UIView!
    var bottleTf: UITextField!
    var sourceTf: UITextField!
    var addImageBtnPopup: UIButton!
    var addBottleBtnPopup: UIButton!
    var addSourceBtnPopup: UIButton!
    
    var activityIndicator: UIActivityIndicatorView!
    
    var barButton = UIBarButtonItem()
    
    var checkLbl = UILabel()
    var checkImage = UIImageView()
    
    // used for coverting string to image
    var imageBase64String = String()
    
    // used for converting image to string
    var imageData: NSData!
    var base64String: NSString!
    
    var currentUser: String!
    
    // useful for getting location
    let locationManager = CLLocationManager()
    var latitude: Double!
    var longitude: Double!
    var locationName: String!
    
    @IBAction func addBottleAction(sender: UIButton) {
        popupBottle = UIView(frame: CGRect(x: view.center.x - 130, y: view.center.y - 125, width: 260, height: 250))
        createPopup(popupBottle)
        
        createCheckElements(popupBottle)
        hideCheck()
        
        bottleTf = UITextField(frame: CGRect(x: 10, y: 20, width: 230, height: 45))
        PotableWaterUtils.customizeTextFields(bottleTf, placeholder: "Numele sticlei", backgroundColor: UIColor.whiteColor(), textColor: PotableWaterUtils.orangeColor, borderColor: PotableWaterUtils.orangeColor)
        
        addImageBtnPopup = UIButton(frame: CGRect(x: 10, y: 75, width: 230, height: 45))
        addImageBtnPopup.setTitle("Fa o poza sticlei", forState: UIControlState.Normal)
        PotableWaterUtils.customizeButton(addImageBtnPopup, backgroundColor: PotableWaterUtils.orangeColor, textColor: UIColor.whiteColor(), borderColor: PotableWaterUtils.orangeColor)
        addImageBtnPopup.addTarget(self, action: #selector(UsersFirstViewController.openCamera), forControlEvents: UIControlEvents.TouchUpInside)
        
        addBottleBtnPopup = UIButton(frame: CGRect(x: 10, y: 190, width: 230, height: 45))
        addBottleBtnPopup.setTitle("Adauga sticla", forState: UIControlState.Normal)
        PotableWaterUtils.customizeButton(addBottleBtnPopup, backgroundColor: PotableWaterUtils.loginBlue, textColor: UIColor.whiteColor(), borderColor: PotableWaterUtils.loginBlue)
        addBottleBtnPopup.addTarget(self, action: #selector(self.createBottle), forControlEvents: UIControlEvents.TouchUpInside)
        
        showPopup(popupBottle, button: addBottleBtnPopup, textField: bottleTf)
    }
    
    @IBAction func addSourceAction(sender: UIButton) {
        popupSource = UIView(frame: CGRect(x: view.center.x - 130, y: view.center.y - 125, width: 260, height: 250))
        createPopup(popupSource)
        
        createCheckElements(popupSource)
        hideCheck()
        
        sourceTf = UITextField(frame: CGRect(x: 10, y: 20, width: 230, height: 45))
        PotableWaterUtils.customizeTextFields(sourceTf, placeholder: "Numele sursei", backgroundColor: UIColor.whiteColor(), textColor: PotableWaterUtils.orangeColor, borderColor: PotableWaterUtils.orangeColor)
        
        addImageBtnPopup = UIButton(frame: CGRect(x: 10, y: 75, width: 230, height: 45))
        addImageBtnPopup.setTitle("Fa o poza sursei", forState: UIControlState.Normal)
        PotableWaterUtils.customizeButton(addImageBtnPopup, backgroundColor: PotableWaterUtils.orangeColor, textColor: UIColor.whiteColor(), borderColor: PotableWaterUtils.orangeColor)
        addImageBtnPopup.addTarget(self, action: #selector(UsersFirstViewController.openCamera), forControlEvents: UIControlEvents.TouchUpInside)
        
        addSourceBtnPopup = UIButton(frame: CGRect(x: 10, y: 190, width: 230, height: 45))
        addSourceBtnPopup.setTitle("Adauga sursa", forState: UIControlState.Normal)
        PotableWaterUtils.customizeButton(addSourceBtnPopup, backgroundColor: PotableWaterUtils.loginBlue, textColor: UIColor.whiteColor(), borderColor: PotableWaterUtils.loginBlue)
        addSourceBtnPopup.addTarget(self, action: #selector(self.createSource), forControlEvents: UIControlEvents.TouchUpInside)
        
        showPopup(popupSource, button: addSourceBtnPopup, textField: sourceTf)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSetup()
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "Water.png"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: #selector(self.createActionSheet), forControlEvents: .TouchUpInside)
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        addActivityIndicator()
        // get current user
        let userID = FIRAuth.auth()?.currentUser?.uid
        DataService.userReference.child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user values from Firebase
            let name = snapshot.value!["name"] as! String
            let email = snapshot.value!["email"] as! String
            self.imageBase64String = snapshot.value!["image"] as! String
            
            // Set to local labels; decodeImage function set the image to imageView
            self.decodeImage()
            self.userName.text = name
            self.userInfo.text = email
            
            // Store current user email
            self.currentUser = email
            
            self.removeActivityIndicator()
            
            }) { (error) in
            print(error.localizedDescription)
                
            self.removeActivityIndicator()
        }
        
        makeCircleImageView()
        addShadowAndCircularCornersToView()
        PotableWaterUtils.customizeButton(addBottleBtn, backgroundColor: UIColor.whiteColor(), textColor: PotableWaterUtils.orangeColor, borderColor: PotableWaterUtils.orangeColor)
        PotableWaterUtils.customizeButton(addSourceBtn, backgroundColor: PotableWaterUtils.orangeColor, textColor: UIColor.whiteColor(), borderColor: PotableWaterUtils.orangeColor)
        userName.textColor = PotableWaterUtils.orangeColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // MARK: - Design current elements
    
    func makeCircleImageView(){
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.clearColor().CGColor
        profilePic.layer.cornerRadius = profilePic.frame.height / 2
        profilePic.clipsToBounds = true
    }
    
    func addShadowAndCircularCornersToView(){
        userHistoryView.layer.borderWidth = 1
        userHistoryView.layer.borderColor = PotableWaterUtils.orangeColor.CGColor
        userHistoryView.layer.cornerRadius = 5
        userHistoryView.layer.shadowColor = PotableWaterUtils.shadowBlue.CGColor
        userHistoryView.layer.shadowOpacity = 5
        userHistoryView.layer.shadowOffset = CGSizeZero
        userHistoryView.layer.shadowRadius = 5
    }
    
// MARK: - Popup Methods
    
    func createPopup(popup: UIView){
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
    
    func uiElementsAlphaZero(popup: UIView, button: UIButton, textField: UITextField){
        blurEffectView.alpha = 0
        popup.alpha = 0
        button.alpha = 0
        textField.alpha = 0
        addImageBtnPopup.alpha = 0
    }
 
    func uiElementsAlphaOne(popup: UIView, button: UIButton, textField: UITextField){
        blurEffectView.alpha = 1
        popup.alpha = 1
        button.alpha = 1
        textField.alpha = 1
        addImageBtnPopup.alpha = 1
    }
    
    func uiElementsRemoveFromSuperview(popup: UIView, button: UIButton, textField: UITextField){
        blurEffectView.removeFromSuperview()
        popup.removeFromSuperview()
        button.removeFromSuperview()
        textField.removeFromSuperview()
        addImageBtnPopup.removeFromSuperview()
    }
    
    func uiElementsAddSubview(popup: UIView, button: UIButton, textField: UITextField){
        view.addSubview(blurEffectView)
        view.addSubview(popup)
        popup.addSubview(button)
        popup.addSubview(textField)
        popup.addSubview(addImageBtnPopup)
    }
    
    func showPopup(popup: UIView, button: UIButton, textField: UITextField){
        uiElementsAlphaZero(popup, button: button, textField: textField)
        uiElementsAddSubview(popup, button: button, textField: textField)
        UIView.animateWithDuration(0.5) { () -> Void in
            self.uiElementsAlphaOne(popup, button: button, textField: textField)
        }
    }
    
    func dismissPopup(popup: UIView, button: UIButton, textField: UITextField){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.uiElementsAlphaZero(popup, button: button, textField: textField)
        }) { (Bool) -> Void in
            self.uiElementsRemoveFromSuperview(popup, button: button, textField: textField)
        }
    }

    // MARK: - Touch outside popup
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let bottlePop = popupBottle{
            if event?.touchesForView(bottlePop) == nil{
                UIView.animateWithDuration(0.5, animations: {
                   self.dismissPopup(bottlePop, button: self.addBottleBtnPopup, textField: self.bottleTf)
                })
            }
        }
        
        if let sourcePop = popupSource{
            if event?.touchesForView(sourcePop) == nil{
                UIView.animateWithDuration(0.5, animations: {
                    self.dismissPopup(sourcePop, button: self.addSourceBtnPopup, textField: self.sourceTf)
                })
            }
        }
    }
    
    // MARK: - Decode image
    
    func decodeImage(){
        let decodedData = NSData(base64EncodedString: imageBase64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData!)
        profilePic.image = decodedImage
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
    
    // MARK: - Work with check elements
    
    func createCheckElements(popup: UIView){
        checkLbl = UILabel(frame: CGRect(x: 40, y: 150, width: 220, height: 25))
        checkLbl.text = "Ai incarcat poza cu succes"
        checkLbl.textColor = UIColor.blackColor()
        checkLbl.font = UIFont(name: "HelveticaNeue", size: 13)
        popup.addSubview(checkLbl)
        
        checkImage = UIImageView(frame: CGRect(x: 10, y: 150, width: 25, height: 25))
        checkImage.image = UIImage(named: "Ok-2.png")
        popup.addSubview(checkImage)
    }
    
    func hideCheck(){
        checkLbl.hidden = true
        checkImage.hidden = true
    }
    
    func unhideCheck(){
        checkLbl.hidden = false
        checkImage.hidden = false
    }
    
    // MARK: - Location Delegate Methods
    
    func locationSetup(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        latitude = location?.coordinate.latitude
        longitude = location?.coordinate.longitude
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location!) { (placemarks, error) in
            var placeMark: CLPlacemark!
            placeMark = placemarks?.last
            
            // Location name
            if let name = placeMark.addressDictionary!["Name"] as? NSString {
                self.locationName = "\(name)"
            }
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                self.locationName = "\(self.locationName), \(street)"
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                self.locationName = "\(self.locationName), \(city)"
            }
            print("Location name: \(self.locationName)")
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("An error has occured: \(error.localizedDescription)")
    }
    
    // MARK: - Create new bottles and sources
    
    func createBottle(){
        let bottleName = bottleTf.text
        
        guard (bottleName != "") else {
            PotableWaterUtils.createOKAlertController(self, title: "Eroare", message: "Te rugam sa completezi numele sticlei")
            return
        }
        
        guard (checkImage.hidden == false && checkLbl.hidden == false) else {
            PotableWaterUtils.createOKAlertController(self, title: "Eroare", message: "Te rugam sa introduci o imagine")
            return
        }
        
        imageToBase64()
        
        let bottle = Bottles(name: bottleName!, image: base64String, addedBy: currentUser)
        let bottleRef = DataService.waterItemsReference.child("bottles")
        let bottleNameRef = bottleRef.child(bottleName!.lowercaseString)
        
        bottleNameRef.setValue(bottle.toAnyObject())
        
        PotableWaterUtils.createOKAlertController(self, title: "Succes", message: "Ai adaugat cu succes o noua companie")
        
    }
    
    func createSource(){
        let sourceName = sourceTf.text
        
        guard (sourceName != "") else {
            PotableWaterUtils.createOKAlertController(self, title: "Eroare", message: "Te rugam sa completezi numele sticlei")
            return
        }
        
        guard (checkImage.hidden == false && checkLbl.hidden == false) else {
            PotableWaterUtils.createOKAlertController(self, title: "Eroare", message: "Te rugam sa introduci o imagine")
            return
        }
        
        guard (longitude != nil && latitude != nil) else {
            PotableWaterUtils.createOKAlertController(self, title: "Eroare", message: "Nu s-a putut gasi locatia. Te rugam sa incerci mai tarziu")
            return
        }
        
        imageToBase64()
        
        let source = Sources(name: sourceName!, image: base64String, latitude: latitude, longitude: longitude, location: locationName, addedBy: currentUser)
        let sourceRef = DataService.waterItemsReference.child("sources")
        let sourceNameRef = sourceRef.child(sourceName!.lowercaseString)
        
        sourceNameRef.setValue(source.toAnyObject())
        
        PotableWaterUtils.createOKAlertController(self, title: "Succes", message: "Ai adaugat cu succes o sursa de apa")
        
    }
    
    // MARK: - Create Action Sheet
    
    func createActionSheet(){
        let ac = UIAlertController(title: "Spre ce vrei sa navighezi?", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        ac.addAction(UIAlertAction(title: "Companiile producatoare", style: UIAlertActionStyle.Default, handler: { (alert) in
            self.goToBottlesDetails()
        }))
        ac.addAction(UIAlertAction(title: "Sursele de apa", style: UIAlertActionStyle.Default, handler: { (alert) in
            self.goToSourceDetails()
        }))
        
        presentViewController(ac, animated: true, completion: nil)
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func goToBottlesDetails(){
        self.performSegueWithIdentifier("goToBottlesSegue", sender: nil)
    }
    
    func goToSourceDetails(){
        self.performSegueWithIdentifier("goToSourcesSegue", sender: nil)
    }

}
