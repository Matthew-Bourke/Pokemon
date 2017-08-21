//
//  ViewController.swift
//  Pokemon
//
//  Created by Matthew Bourke on 21/8/17.
//  Copyright © 2017 Matthew Bourke. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var updateCount = 0
    var manager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    var pokemons : [Pokemon] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add pokemon to CoreData
        pokemons = getAllPokemon()
        
        // Code for setting up usage of MAPS
        manager.delegate = self
        // If authorisation status has already been established, don't ask for permission
        if  CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("Ready to go!")
            // Allows blue dot to appear on map
            mapView.showsUserLocation = true
            // Section starts to zoom in on user location
            manager.startUpdatingLocation()
            
            // Implement a timer to spawn pokemon at regular intervals
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                // This is the code that gets run every interval. We want to spawn a pokemon here.
                // Inserting an annotation into the map
                if let coord = self.manager.location?.coordinate {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coord
                    let randoLat = (Double(arc4random_uniform(100))  - 60.0) / 21000.0
                    let randoLong = (Double(arc4random_uniform(100))  - 60.0) / 21000.0
                    annotation.coordinate.latitude += randoLat
                    annotation.coordinate.longitude += randoLong
                   self.mapView.addAnnotation(annotation)
                }
            })
            // If authorisation status is not confirmed, ask for it
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    // This funciton constantly updates the user location on the map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 5 {
            // define region in maps
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 350, 350)
            // sets the visible region of the map to defined region in above line
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else {
            // Want to stop updating location to save battery
            manager.stopUpdatingLocation()
        }
        
    }
    
    @IBAction func centreTapped(_ sender: Any) {
        // define region in maps
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 350, 350)
            // sets the visible region of the map to defined region in above line
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

