//
//  TabbarController.swift
//  Emmed-App
//
//  Created by vorawit chenthulee on 7/4/2566 BE.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import MqttCocoaAsyncSocket
import CocoaMQTT

class TabbarController: UIViewController {
    
    var locationManager: CLLocationManager!
    var mqtt: CocoaMQTT? = nil
    var location : CLLocation? = nil
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSwitch.addTarget(self, action: #selector(handleSwitch), for: UIControl.Event.valueChanged)
        initMqtt()
    }

    func resetMapView() {
        mapView.showsUserLocation = false
        mapView.userTrackingMode = .none
        mapView.removeAnnotations(mapView.annotations)
        locationManager.stopUpdatingLocation()
    }
    
    @objc func handleSwitch(mySwitch: UISwitch) {
        let value = locationSwitch.isOn
        if value {
            print("check location on")
            statusLabel.text = "Online..."
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }else{
            print("check location off")
            statusLabel.text = "Offline..."
            resetMapView()
            latitudeLabel.text = "0"
            longtitudeLabel.text = "0"
        }
    }

    
}
