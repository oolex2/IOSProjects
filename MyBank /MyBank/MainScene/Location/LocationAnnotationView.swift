import MapKit

final class ArtworkView: MKAnnotationView {
    
  override var annotation: MKAnnotation? {
    
    willSet {
        
      guard let artwork = newValue as? LocationAnnotation else {return}
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

        image = artwork.image
    }
  }
}
