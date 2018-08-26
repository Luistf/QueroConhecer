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
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viInfo: UIView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    //MARK: Actions
    @IBAction func showRoute(_ sender: UIButton) {
    }
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
    }
    
}
