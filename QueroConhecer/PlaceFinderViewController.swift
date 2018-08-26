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
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var viLoading: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: Methods
    func load(show: Bool) {
        viLoading.isHidden = !show
        if show {
            aiLoading.startAnimating()
        } else {
            aiLoading.stopAnimating()
        }
    }

    
    //MARK: Actions
    
    @IBAction func findCity(_ sender: UIButton) {
        tfCity.resignFirstResponder()
        let city = tfCity.text!
        
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
