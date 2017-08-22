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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
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
            setUp()
            // If authorisation status is not confirmed, ask for it
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setUp()
        }
    }
    
    func setUp() {
        // Allowing images to appear on map instead of pin
        mapView.delegate = self
        // Allows blue dot to appear on map
        mapView.showsUserLocation = true
        // Section starts to zoom in on user location
        manager.startUpdatingLocation()
        
        // Implement a timer to spawn pokemon at regular intervals
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            // This is the code that gets run every interval. We want to spawn a pokemon here.
            // Inserting an annotation into the map
            if let coord = self.manager.location?.coordinate {
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                let annotation = PokeAnnotation(coord: coord, pokemon: pokemon)
                let randoLat = (Double(arc4random_uniform(100))  - 60.0) / 19000.0
                let randoLong = (Double(arc4random_uniform(100))  - 60.0) / 19000.0
                annotation.coordinate.latitude += randoLat
                annotation.coordinate.longitude += randoLong
                self.mapView.addAnnotation(annotation)
            }
        })
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annoView.image = UIImage(named: "player")
            var frame = annoView.frame
            frame.size.height = 50
            frame.size.width = 50
            annoView.frame = frame
            return annoView
        }
        
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        let pokemon = (annotation as! PokeAnnotation).pokemon
        annoView.image = UIImage(named: pokemon.imageName!)
        var frame = annoView.frame
        frame.size.height = 50
        frame.size.width = 50
        annoView.frame = frame
        return annoView
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
    
    
    // Function for tapping annotation in map view
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        if view.annotation is MKUserLocation {
            return
        }
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 150, 150)
        // sets the visible region of the map to defined region in above line
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coord = self.manager.location?.coordinate {
                let pokemon = (view.annotation! as! PokeAnnotation).pokemon
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    pokemon.caught = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    let alertVC = UIAlertController(title: "Congrats!", message: "You caught a \(String(describing: pokemon.name!))!\n😄", preferredStyle: .alert)
                    
                    let pokedexAction = UIAlertAction(title: "Pokédex", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    
                    alertVC.addAction(pokedexAction)
                    
                    let OKaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(OKaction)
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                    mapView.removeAnnotation(view.annotation!)
                } else {
                    let alertVC = UIAlertController(title: "Uh oh", message: "This \(String(describing: pokemon.name!)) is too far away.\n💩", preferredStyle: .alert)
                    let OKaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
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

