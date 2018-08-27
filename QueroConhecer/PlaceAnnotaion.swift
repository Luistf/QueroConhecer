//
//  PlaceAnnotaion.swift
//  QueroConhecer
//
//  Created by Luis Ferreira on 8/26/18.
//  Copyright © 2018 Luis Ferreira. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotaion: NSObject, MKAnnotation {
   
    enum PlaceType {
        case place
        case poi
    }
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subTitle: String?
    var type: PlaceType?
    var address: String?
    
    init(coordinate: CLLocationCoordinate2D, type: PlaceType) {
        self.coordinate = coordinate
        self.type = type
    }
    
}
