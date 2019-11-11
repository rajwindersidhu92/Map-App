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
import Foundation


class ViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate{
    
    var myAnnotations = [CLLocationCoordinate2D]()
    

    var kms = [CLLocationCoordinate2D]()
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
        print(myAnnotations.count)
        if(myAnnotations.count >= 2)
        {
            let dis = "\(distance(myAnnotations[myAnnotations.count-1], myAnnotations[myAnnotations.count-2])) KMS"
            let annotation = MKPointAnnotation()
            annotation.coordinate = midpoint(myAnnotations[myAnnotations.count-2], myAnnotations[myAnnotations.count-1])
            print(annotation.coordinate)
            annotation.title = dis
            mapView.addAnnotation(annotation)
            kms.append(annotation.coordinate)
            
            
            
            
        }
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
            linerenderer.accessibilityLabel = "Hello"
            linerenderer.accessibilityHint = "NEW"
            return linerenderer
        }
        //fatalError("Something Went Wrong")
        return MKOverlayRenderer()
    }
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    func rad2deg(_ rad:Double) -> Double {
        return rad * 180.0 / .pi
    }

    func distance(_ location1:CLLocationCoordinate2D, _ location2:CLLocationCoordinate2D ) -> Double {
        
        let unit = "K"
        let lat1 = location1.latitude
        let lat2 = location2.latitude
        let lon1 = location1.longitude
        let lon2 = location2.longitude
        
        
        let theta = lon1 - lon2
        var dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta))
        dist = acos(dist)
        dist = rad2deg(dist)
        dist = dist * 60 * 1.1515
        if (unit == "K") {
            dist = dist * 1.609344
        }
        else if (unit == "N") {
            dist = dist * 0.8684
        }
        return dist
    }
    func midpoint(_ location1:CLLocationCoordinate2D, _ location2:CLLocationCoordinate2D) -> CLLocationCoordinate2D
    {
        
        let dlon = deg2rad(location2.longitude - location1.longitude)
        let lat1 = deg2rad(location1.latitude)
        let lng1 = deg2rad(location1.longitude)
        let lat2 = deg2rad(location2.latitude)
        let bx = cos(lat2) * cos(dlon)
        let by = cos(lat2) * sin(dlon)
        let lat3 = atan2(sin(lat1)+sin(lat2), sqrt((cos(lat1)+bx)*(cos(lat1)+by)+by*by))
        let lon3 = lng1+atan2(by, cos(lat1)+bx)
        
        let midpoint = CLLocationCoordinate2D(latitude: lat3, longitude: lon3)
        
        return midpoint
    }
    
    
}

extension CLLocationCoordinate2D {
   func middleLocationWith(location:CLLocationCoordinate2D) -> CLLocationCoordinate2D {

    let lon1 = longitude * .pi / 180
    let lon2 = location.longitude * .pi / 180
    let lat1 = latitude * .pi / 180
    let lat2 = location.latitude * .pi / 180
    let dLon = lon2 - lon1
    let x = cos(lat2) * cos(dLon)
    let y = cos(lat2) * sin(dLon)

    let lat3 = atan2( sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y * y) )
    let lon3 = lon1 + atan2(y, cos(lat1) + x)

    let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat3 * 180 / .pi, lon3 * 180 / M_PI)
    return center
}
}
