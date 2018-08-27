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

    //MARK: Outltes
    @IBOutlet weak var seacrBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viInfo: UIView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    //MARK: Properties
    var places: [Place]!
    var poi: [MKAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seacrBar.isHidden = true
        viInfo.isHidden = true
        mapView.mapType = .mutedStandard
        mapView.delegate = self
        
        if places.count == 1 {
            title = places[0].name
        } else {
            title = "Meu lugares"
        }

        for place in places {
            addToMap(place)
        }
        
        showPlaces()
    }
    
    //MARK: Methods
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


    //MARK: Actions
    @IBAction func showRoute(_ sender: UIButton) {
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


