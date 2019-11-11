//
//  CustomBubble.swift
//  Map App
//
//  Created by Kishore Narang on 2019-11-11.
//  Copyright © 2019 Zero. All rights reserved.
//

import UIKit
import MapKit
class CustomBubble: MKAnnotationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override var annotation:MKAnnotation?{
        willSet{
            self.image = UIImage
        }
    }

}
