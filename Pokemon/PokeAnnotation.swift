//
//  PokeAnnotation.swift
//  Pokemon
//
//  Created by Matthew Bourke on 22/8/17.
//  Copyright © 2017 Matthew Bourke. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// In order for the map to display random pokemon, we have to add a subclass to MKAnnotation
class PokeAnnotation : NSObject, MKAnnotation {
    // The following is initialisation for an MKAnnotation subclass
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    init(coord: CLLocationCoordinate2D, pokemon : Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
    
    
}
