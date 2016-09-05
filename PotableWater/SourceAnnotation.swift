//
//  SourceAnnotation.swift
//  PotableWater
//
//  Created by Voicu Narcis on 05/09/2016.
//  Copyright © 2016 Voicu Narcis. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SourceAnnotation: MKPointAnnotation {
    var image: UIImage?
    var infoButton: UIButton!
    
    func getImageFromBase64String(base64String: NSString) -> UIImage? {
        if let decodedData = NSData(base64EncodedString: base64String as String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters){
            if let image = UIImage(data: decodedData){
                return image
            }
        }
        return nil
    }
}