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

    //MARK: Outlets
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    //MARK: Actions
   
    @IBAction func findCity(_ sender: UIButton) {
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
