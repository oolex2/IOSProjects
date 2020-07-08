import UIKit
import MapKit

final class Location: UIViewController {
    
    @IBOutlet private weak var mapKit: MKMapView!
    
    public var adress = String()
    
    private var locationManager = CLLocationManager()
    
    private let regionRadius: CLLocationDistance = 500
    
    override func viewWillAppear(_ animated: Bool) {
        
        mapKit.delegate = self
        
        coordinates(forAddress: adress) {
            
            (location) in
            guard let location = location else { return }
            
            let initialLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
            self.centerMapOnLocation(location: initialLocation)
            
            let annotation = LocationAnnotation(title: self.navigationItem.title ?? "", locationName: self.navigationItem.title ?? "", discipline: "Банк", coordinate: location)
            
            self.mapKit.addAnnotation(annotation)
        }
        
    }
    
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapKit.setRegion(coordinateRegion, animated: true)
    }
    
    private func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            
            (placemarks, error) in
            guard error == nil else {
                
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
}

extension Location: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        if let title = annotation.title, title == navigationItem.title {
            
            if  let image = UIImage(named: "locationImage") {
            
            annotationView?.image = image
            annotationView?.tintColor = .cyan
            annotationView?.tintColorDidChange()
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        let location = view.annotation as! LocationAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
   
