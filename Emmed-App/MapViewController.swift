import UIKit
import MapKit
import CoreLocation
import MqttCocoaAsyncSocket


struct DeviceData: Decodable {
    let device: String
    let time: String
    let latitude: Double
    let longitude: Double
    let dust: Int
    let temperature: Double

    enum CodingKeys: String, CodingKey { //Map ตัวแปรกับ json data
        case device = "Device"
        case time = "Time"
        case latitude = "Lat"
        case longitude = "Lng"
        case dust = "Dust"
        case temperature = "Temp"
    }
}


class MapViewController: UIViewController {
    
    @IBOutlet weak var MapView: MKMapView!
    
    private var deviceData: [DeviceData] = []
    private var loading = true
    var locationManager: CLLocationManager!
    var location : CLLocation? = nil
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        getData()
    }
    
    private func getData() {
            let url = URL(string: "https://embed-lab-api.up.railway.app/data")!
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                    self.loading = false
                    return
                }
                guard let data = data else { return }
                do {
                    self.deviceData = try JSONDecoder().decode([DeviceData].self, from: data) //แยกข้อมูล json
                    DispatchQueue.main.async {
                        self.createAnnotations() //เรียกใช้การสร้าง pin
                    }
                } catch let error {
                    print(error)
                }
                self.loading = false
            }
            task.resume()
        }
    
    private func createAnnotations() {
        MapView.removeAnnotations(MapView.annotations)
        for deviceData in deviceData {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: deviceData.latitude, longitude: deviceData.longitude)
            annotation.title = deviceData.device
            annotation.subtitle = "Dust: \(deviceData.dust), Temperature: \(deviceData.temperature)"
            MapView.addAnnotation(annotation)
        }
    }
    

}

extension MapViewController : CLLocationManagerDelegate {
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            
            MapView.setRegion(region, animated: true)
            MapView.mapType = .standard
            MapView.showsUserLocation = true
            MapView.userTrackingMode = .follow
        }
    }
}

extension MapViewController {
    
    func fetchDataAndCreateAnnotations() {
        let url = URL(string: "https://embed-lab-api.up.railway.app/data")!
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                print(error)
                self.loading = false
                return
            }
            guard let data = data else { return }
            do {
                let deviceData = try JSONDecoder().decode([DeviceData].self, from: data)
                DispatchQueue.main.async {
                    self.createAnnotations(deviceData: deviceData)
                }
            } catch let error {
                print(error)
            }
            self.loading = false
        }
        task.resume()
    }
    
    private func createAnnotations(deviceData: [DeviceData]) {
        MapView.removeAnnotations(MapView.annotations) //เคลีย annotations เดิม
        for deviceData in deviceData {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: deviceData.latitude, longitude: deviceData.longitude)
            annotation.title = deviceData.device
            annotation.subtitle = "Dust: \(deviceData.dust), Temperature: \(deviceData.temperature)"
            MapView.addAnnotation(annotation)
        }
    }
}
