//
//  BottlesDetailsViewController.swift
//  PotableWater
//
//  Created by Voicu Narcis on 05/09/2016.
//  Copyright © 2016 Voicu Narcis. All rights reserved.
//

import UIKit

class BottlesDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nume: UILabel!
    @IBOutlet weak var adaugatDe: UILabel!
    
    var bottleName: String!
    var imageBase64String: String!
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nume.text = bottleName

        addActivityIndicator()
        DataService.waterItemsReference.child("bottles").child(bottleName.lowercaseString).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user values from Firebase
            let addedBy = snapshot.value!["addedBy"] as! String
            self.imageBase64String = snapshot.value!["image"] as! String
            
            // Set to local labels; decodeImage function set the image to imageView
            self.decodeImage()
            self.adaugatDe.text = addedBy
            
            self.removeActivityIndicator()
        }) { (error) in
            print(error.localizedDescription)
            self.removeActivityIndicator()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decodeImage(){
        let decodedData = NSData(base64EncodedString: imageBase64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData!)
        imageView.image = decodedImage
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

}
