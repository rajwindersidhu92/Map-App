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
    
    var myAnnotations = [CLLocationCoordinate2D]()
    

    @IBAction func clearPoints(_ sender: UIButton) {
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        myAnnotations.removeAll()
        
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addPin))
        self.mapView.addGestureRecognizer(tapGesture)
    }

    @objc func addPin(tapGesture:UITapGestureRecognizer)
    {
       
        let touchPin = tapGesture.location(in: mapView)
        let touchLocation = mapView.convert(touchPin, toCoordinateFrom:mapView)
        
        
        let location = CLLocation(latitude: touchLocation.latitude, longitude: touchLocation.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchLocation
        
         
            let geo = CLGeocoder()
            geo.reverseGeocodeLocation(location, completionHandler: {(placemark, error) in
            
                annotation.title = placemark![0].name!
                  
            })
            if(myAnnotations.count < 5)
            {

                myAnnotations.append(touchLocation)
                mapView.addAnnotation(annotation)
                if(myAnnotations.count==5)
                {
                    myAnnotations.append(myAnnotations[0])
                }
            }
            else
            {
                let alert = UIAlertController(title: "Error", message: "Maximum Points Limit is 5", preferredStyle:.alert)
                                                  
                             
                                                  alert.addAction(UIAlertAction(title:"OK", style:.cancel, handler: nil))
                                                  present(alert, animated: true)
            }
        
    
        
        let line = MKPolyline(coordinates: myAnnotations, count: myAnnotations.count)
        mapView.addOverlay(line)
    }
    
    func getLocationName(location:CLLocation) -> String
    
    {
        var string = ""
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(location, completionHandler: {(placemark, error) in
        
            string = placemark![0].name!
              
        })
    
        return string
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("Building Line")
        if let polyline = overlay as? MKPolyline
        {
            let linerenderer = MKPolylineRenderer(polyline: polyline)
            linerenderer.strokeColor = .blue
            linerenderer.lineWidth = 2.0
            return linerenderer
        }
        //fatalError("Something Went Wrong")
        return MKOverlayRenderer()
    }
    
}

