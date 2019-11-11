//
//  ViewController.swift
//  Map App
//
//  Created by Kishore Narang on 2019-11-11.
//  Copyright © 2019 Zero. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate{
    
    

    @IBAction func clearPoints(_ sender: UIButton) {
        
    }
    @IBOutlet weak var mapView: MKMapView!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last
        {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            let region = MKCoordinateRegion(center:center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            self.mapView.setRegion(region, animated: true)
        }
    }
    let locationmanager:CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationmanager.requestAlwaysAuthorization()
                        locationmanager.requestWhenInUseAuthorization()
                        if CLLocationManager.locationServicesEnabled()
                        {
                            locationmanager.delegate = self
                            locationmanager.desiredAccuracy = kCLLocationAccuracyBest
                            locationmanager.startUpdatingLocation()
                        }
    }


}

