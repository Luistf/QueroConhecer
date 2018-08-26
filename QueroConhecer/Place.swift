//
//  Place.swift
//  QueroConhecer
//
//  Created by Luis Ferreira on 8/26/18.
//  Copyright © 2018 Luis Ferreira. All rights reserved.
//

import Foundation
import MapKit

struct Place {
    
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let address: String
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func getFormattedAddress(with placemark: CLPlacemark) -> String {
        var address = ""
        if let street = placemark.thoroughfare {
            address += street //Street
        }
        if let number = placemark.subThoroughfare {
            address += " \(number)" //number
        }
        if let subLocality = placemark.subLocality {
            address += ", \(subLocality)" //neighborhood
        }
        if let city = placemark.locality {
            address += "\n\(city)" //city
        }
        if let state = placemark.administrativeArea {
            address += " - \(state)" //state
        }
        if let postalCode = placemark.postalCode {
            address += "\nCPF: \(postalCode)" // postalcode
        }
        if let country = placemark.country {
            address += "\n\(country)" //country
        }
        return address
    }
    
}
