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
    
    

    
    
    //MARK: Properties
    var places: [Place]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for place in places {
            addToMap(place)
        }
        
        showPlaces()
    }
    
    //MARK: Methods
    func addToMap(_ place: Place) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = place.coordinate
        annotation.title = place.name
        mapView.addAnnotation(annotation)
    }
    
    func showPlaces() {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }


    //MARK: Actions
    @IBAction func showRoute(_ sender: UIButton) {
    }
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
    }
    
}
