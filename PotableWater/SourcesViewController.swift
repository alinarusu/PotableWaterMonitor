//
//  SourcesViewController.swift
//  PotableWater
//
//  Created by Voicu Narcis on 03/09/2016.
//  Copyright © 2016 Voicu Narcis. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import FirebaseDatabase

class SourcesViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView! {
        didSet{
            mapView.delegate = self
        }
    }
    var sources: [Sources]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.waterItemsReference.child("sources").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            var newSources = [Sources]()
            for item in snapshot.children {
                let source = Sources(snapshot: item as! FIRDataSnapshot)
                newSources.append(source)
            }
            self.sources = newSources
            self.setupAnnotations()
        }) { (error) -> Void in
            print(error.description)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print("viewForAnnotation")
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            //println("Pinview was nil")
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        
        let button = UIButton(type: UIButtonType.DetailDisclosure)
        
        pinView?.rightCalloutAccessoryView = button
        return pinView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("didSelectAnnotationView")
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            performSegueWithIdentifier("sourcesDetailsSegue", sender: view)
        }
    }
    
    func setupAnnotations(){
        var allAnnotations = [SourceAnnotation]()
        for i in 0 ..< sources.count{
            let annotation = SourceAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: sources[i].latitude, longitude: sources[i].longitude)
            annotation.title = sources[i].name
            annotation.subtitle = sources[i].location
            let decodedData = NSData(base64EncodedString: sources[i].image as String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            let image = UIImage(data: decodedData)
            annotation.image = image
            mapView.addAnnotation(annotation)
            allAnnotations.append(annotation)
        }
        mapView.showAnnotations(allAnnotations, animated: true)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sourcesDetailsSegue"{
            if let sourceDetails = segue.destinationViewController as? SourcesDetailsViewController{
                sourceDetails.sourceName = ((sender as? MKAnnotationView)?.annotation?.title)!
            }
        }
    }
    

}
