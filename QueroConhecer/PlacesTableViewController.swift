//
//  PlacesTableViewController.swift
//  QueroConhecer
//
//  Created by Luis Ferreira on 8/25/18.
//  Copyright © 2018 Luis Ferreira. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {

    //Properties
    var places: [Place] = []
    let ud = UserDefaults.standard
    var lbNoPlaces: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPlaces()
        lbNoPlaces = UILabel()
        lbNoPlaces.text = "Cadastre os locais que deseja conhecer\nclicando no botão + acima"
        lbNoPlaces.textAlignment = .center
        lbNoPlaces.numberOfLines = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! != "mapSegue" {
            let viewController = segue.destination as! PlaceFinderViewController
            viewController.delegate = self
        } else {
            let vc = segue.destination as! mapViewController
            switch sender {
                case let place as Place:
                    vc.places = [place]
                default:
                    vc.places = places
            }
        }
    }

    //MARK: Methods
    func loadPlaces() {
        if let placesData = ud.data(forKey: "places") {
            do {
                places = try JSONDecoder().decode([Place].self, from: placesData)
                tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func savePlaces() {
        let json = try? JSONEncoder().encode(places)
        ud.set(json, forKey: "places")
    }
    
    @objc func showAll() {
        performSegue(withIdentifier: "mapSegue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            savePlaces()
        }
    }
    

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if places.count > 0 {
            let btShowAll = UIBarButtonItem(title: "Mostrar todos no mapa", style: .plain, target: self, action: #selector(showAll))
            navigationItem.leftBarButtonItem = btShowAll
            tableView.backgroundView = nil
        } else {
            navigationItem.leftBarButtonItem = nil
            tableView.backgroundView = lbNoPlaces
        }
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

         let place = places[indexPath.row]
        cell.textLabel?.text = place.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        performSegue(withIdentifier: "mapSegue", sender: place)
    }
    
}

    //Extension
extension PlacesTableViewController: PlaceFinderDelegate {
    func addPlace(_ place: Place) {
        if !places.contains(place) {
            places.append(place)
            savePlaces()
            tableView.reloadData()
        }
    }
    
    
}



