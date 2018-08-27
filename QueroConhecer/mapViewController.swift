//
//  mapViewController.swift
//  QueroConhecer
//
//  Created by Luis Ferreira on 8/25/18.
//  Copyright © 2018 Luis Ferreira. All rights reserved.
//

import UIKit
import MapKit

class mapViewController: UIViewController {

    enum MapMessageType {
        case routeError
        case authorizationWarning
    }
    
    // MARK: - Outltes
    @IBOutlet weak var seacrBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viInfo: UIView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    //MARK: - Properties
    var places: [Place]!
    var poi: [MKAnnotation] = []
    lazy var locationManager = CLLocationManager()
    var btUserLocation: MKUserTrackingButton!
    var selectedAnnotaion: PlaceAnnotaion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seacrBar.isHidden = true
        viInfo.isHidden = true
        mapView.mapType = .mutedStandard
        mapView.delegate = self
        locationManager.delegate = self
        
        if places.count == 1 {
            title = places[0].name
        } else {
            title = "Meu lugares"
        }

        for place in places {
            addToMap(place)
        }
        
        configureLocationButton()
        
        showPlaces()
        requestUserLocationAuthorization()
    }
    
    // MARK:- Methods
    func configureLocationButton() {
        btUserLocation = MKUserTrackingButton(mapView: mapView)
        btUserLocation.backgroundColor = .white
        btUserLocation.frame.origin.x = 10
        btUserLocation.frame.origin.y = 10
        btUserLocation.layer.cornerRadius = 5
        btUserLocation.layer.borderWidth = 1
        btUserLocation.layer.borderColor = UIColor(named: "main")?.cgColor
    }
    
    func addToMap(_ place: Place) {
        let annotation = PlaceAnnotaion(coordinate: place.coordinate, type: .place)
        annotation.coordinate = place.coordinate
        annotation.title = place.name
        annotation.address = place.address
        mapView.addAnnotation(annotation)
    }
    
    func showPlaces() {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func requestUserLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways, .authorizedWhenInUse:
                    mapView.addSubview(btUserLocation)
                case .denied:
                    showMessage(type: .authorizationWarning)
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                case .restricted:
                    break
            }
        } else {
            
        }
    }
    
    func showMessage(type: MapMessageType) {
        let title = type == .authorizationWarning ? "Aviso" : "Error"
        let message = type == .authorizationWarning ? "Para usar os recursos de localização do App, você precisa permitir o uso na tela de ajustes" : "Não foi possível encontrar esta rota"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if type == .authorizationWarning {
            let confirmAction = UIAlertAction(title: "Ir para ajustes", style: .default) { (action) in
                if let appSetings = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(appSetings, options: [:], completionHandler: nil)
                }
            }
            alert.addAction(confirmAction)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showInfo() {
        lbName.text = selectedAnnotaion!.title
        lbAddress.text = selectedAnnotaion!.address
        viInfo.isHidden = false
    }


    // MARK: - Actions
    @IBAction func showRoute(_ sender: UIButton) {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            showMessage(type: .authorizationWarning)
            return
        }
        let request = MKDirectionsRequest()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: selectedAnnotaion!.coordinate))
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: locationManager.location!.coordinate))
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if error == nil {
                if let response = response {
                    self.mapView.removeOverlays(self.mapView.overlays)
                    
                    let route = response.routes.first!
                    
                    self.mapView.add(route.polyline, level: .aboveRoads)
                    var annations = self.mapView.annotations.filter({!($0 is PlaceAnnotaion)})
                    annations.append(self.selectedAnnotaion!)
                    self.mapView.showAnnotations(annations, animated: true)
                }
            } else {
                self.showMessage(type: .routeError)
            }
        }
    }
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        seacrBar.resignFirstResponder()
        seacrBar.isHidden = !seacrBar.isHidden
    }
    
}

//MARK: Extensions
extension mapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is PlaceAnnotaion) {
            return nil
        }
        let type = (annotation as! PlaceAnnotaion).type
        let identifier = "\(type)"
        var annotaionView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotaionView == nil {
            annotaionView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotaionView?.annotation = annotation
        annotaionView?.canShowCallout = true
        annotaionView?.markerTintColor = type == .place ? UIColor(named: "main") : UIColor(named: "poi")
        annotaionView?.glyphImage = type == .place ? #imageLiteral(resourceName: "placeGlyph") : #imageLiteral(resourceName: "poiGlyph") //image in assets as placeGlyph and poiGlyph
        annotaionView?.displayPriority = type == .place ? .required : .defaultHigh
        return annotaionView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let camera = MKMapCamera()
        camera.centerCoordinate = view.annotation!.coordinate
        camera.pitch = 80
        camera.altitude = 100
        mapView.setCamera(camera, animated: true)
        
        selectedAnnotaion = (view.annotation as! PlaceAnnotaion)
        showInfo()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(named: "main")?.withAlphaComponent(0.8)
            renderer.lineWidth = 5.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
}

extension mapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        loading.startAnimating()
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if error == nil {
                guard let response = response else {
                    self.loading.stopAnimating()
                    return
                }
                self.mapView.removeAnnotations(self.poi)
                self.poi.removeAll()
                for item in response.mapItems {
                    let annotaion = PlaceAnnotaion(coordinate: item.placemark.coordinate, type: .poi)
                    annotaion.title = item.name
                    annotaion.subTitle = item.phoneNumber
                    annotaion.address = Place.getFormattedAddress(with: item.placemark)
                    self.poi.append(annotaion)
                }
                self.mapView.addAnnotations(self.poi)
                self.mapView.showAnnotations(self.poi, animated: true)
            }
            self.loading.stopAnimating()
        }
    }
}

extension mapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                mapView.showsUserLocation = true
                mapView.addSubview(btUserLocation)
                locationManager.startUpdatingLocation()
            default:
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last!)
    }
}


