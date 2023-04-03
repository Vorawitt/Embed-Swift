//
//  ViewController.swift
//  Emmed-App
//
//  Created by vorawit chenthulee on 2/4/2566 BE.
//

import UIKit
import MapKit
import CoreLocation
import MqttCocoaAsyncSocket
import CocoaMQTT

class HomeViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
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

extension HomeViewController : CLLocationManagerDelegate {
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        //print("locations.last: \(locations.last)")
        timer?.invalidate()
        
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            mapView.mapType = .standard
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
            self.location = locations.first
            print("location value: \(self.location)")
            latitudeLabel.text = "latitude = \(String(format: "%.4f", location.coordinate.latitude))"
            longtitudeLabel.text = "longtitude = \(String(format: "%.4f",location.coordinate.longitude))"
            //print("\(latitudeLabel.text) , \(longtitudeLabel.text)")
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
                        self?.publish()
                    }
        }
    }
}

extension HomeViewController: CocoaMQTTDelegate {
    
    func initMqtt() {
        var clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: "test.mosquitto.org", port: 1883)
        mqtt?.username = ""
        mqtt?.password = ""
        mqtt?.willMessage = CocoaMQTTMessage(topic: "/testMQTT", string: "voravit")
        mqtt?.keepAlive = 5
        mqtt?.delegate = self
        mqtt?.connect()
    }
    
    
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck){
        if ack == .accept {
              print("MQTT connection successful!")
              mqtt.subscribe("your_topic")
        }
    }
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16){
        print("Message published: \(message.string ?? "")")
    }
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16){
        
    }
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ){
        
    }
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]){
        
    }
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]){
        
    }
    
    ///
    func mqttDidPing(_ mqtt: CocoaMQTT){
        
    }
    
    ///
    func mqttDidReceivePong(_ mqtt: CocoaMQTT){
        
    }
    
    ///
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?){
        
    }
    
    func publish(){
        if let local = self.location {
            let latitude = String(format: "%.4f", local.coordinate.latitude)
            let longitude = String(format: "%.4f", local.coordinate.longitude)
            
            let message = "{Latitude:\(latitude), Longitude:\(longitude)}" // The message to be published
            //print("check message \(message)")
            let topic = "testMQTT" // The MQTT topic to which the message will be published
            mqtt?.publish(topic, withString: message)
        }
    }
    
}
