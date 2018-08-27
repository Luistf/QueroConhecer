//
//  PlaceFinderViewController.swift
//  QueroConhecer
//
//  Created by Luis Ferreira on 8/25/18.
//  Copyright © 2018 Luis Ferreira. All rights reserved.
//

import UIKit
import MapKit

class PlaceFinderViewController: UIViewController {

    enum placeFinderMessageType {
        case error(String)
        case confirmation(String)
    }
    
    //MARK: Outlets
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var viLoading: UIView!
    
    //MARK: Properties
    var place: Place!
    weak var delegate: PlaceFinderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(getLocation(_:)))
        gesture.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(gesture)
    }
    
    //MARK: Methods
    @objc func getLocation(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            load(show: true)
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                self.load(show: false)
                if error == nil {
                    if !self.savePlace(with: placemarks?.first) {
                        self.showMessage(type: .error("Não foi encontrado nenhum local com esse nome"))
                    }
                } else {
                    self.showMessage(type: .error("Erro desconhecido"))
                }
            }
            
        }
    }
    
    func load(show: Bool) {
        viLoading.isHidden = !show
        if show {
            aiLoading.startAnimating()
        } else {
            aiLoading.stopAnimating()
        }
    }
    
    func savePlace(with placemark: CLPlacemark?) -> Bool {
        guard let placemark = placemark, let coordinate = placemark.location?.coordinate else {
            return false
        }
        let name = placemark.name ?? placemark.country ?? "Desconhecido"
        let address = Place.getFormattedAddress(with: placemark)
        place = Place(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude, address: address)
        
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 2500, 2500)
        mapView.setRegion(region, animated: true)
        
        self.showMessage(type: .confirmation(place.name))
        
        return true
    }
    
    func showMessage(type: placeFinderMessageType) {
        let title: String
        let message: String
        var hasConfirmation: Bool = false
        switch type {
            case .confirmation(let name):
                title = "Local encontrado"
                message = "Deseja adicionar \(name)?"
                hasConfirmation = true
        case .error(let errorMessage):
                title = "Error"
                message = errorMessage
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if hasConfirmation {
            let confirmAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.delegate?.addPlace(self.place)
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(confirmAction)
        }
        present(alert, animated: true, completion: nil)
    }

    
    //MARK: Actions
    
    @IBAction func findCity(_ sender: UIButton) {
        tfCity.resignFirstResponder()
        let address = tfCity.text!
        load(show: true)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            self.load(show: false)
            if error == nil {
                if !self.savePlace(with: placemarks?.first) {
                    self.showMessage(type: .error("Não foi encontrado nenhum local com esse nome"))
                }
            } else {
                self.showMessage(type: .error("Local não encontrado"))
            }
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: Protocol
protocol PlaceFinderDelegate: class {
    func addPlace(_ place: Place)
    
}
