//
//  CoreDataHelp.swift
//  Pokemon
//
//  Created by Matthew Bourke on 21/8/17.
//  Copyright © 2017 Matthew Bourke. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
    createPokemon(name: "Mew", imageName: "mew")
    createPokemon(name: "Meowth", imageName: "meowth")
    createPokemon(name: "Abra", imageName: "abra")
    createPokemon(name: "Charmander", imageName: "charmander")
    createPokemon(name: "Bullbasaur", imageName: "bullbasaur")
    createPokemon(name: "Eevee", imageName: "eevee")
    createPokemon(name: "Jigglypuff", imageName: "jigglypuff")
    createPokemon(name: "Pikachu", imageName: "pikachu-2")
    createPokemon(name: "Psyduck", imageName: "psyduck")
    createPokemon(name: "Squirtle", imageName: "squirtle")
    createPokemon(name: "Zubat", imageName: "zubat")
    createPokemon(name: "Caterpie", imageName: "caterpie")
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    print("ADDED!")
}

func createPokemon(name : String, imageName : String) {
    // CoreData stuff here
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageName = imageName
}

// Function to get pokemon OUT of CoreData
func getAllPokemon() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        if pokemons .count == 0 {
            addAllPokemon()
            return getAllPokemon()
        }
        return pokemons
    } catch {}
    return []
}

func getAllCaughtPokemons() -> [Pokemon] {
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Creating custom fetch request to only get the caught pokemon out of CoreData
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    // Predicate lets us define a parameter to choose objects in CoreData
    fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)
    
    do{
        let pokemons = try context.fetch(fetchRequest)
        return pokemons
    } catch {}
    
    return []
}


func getAllUncaughtPokemons() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Creating custom fetch request to only get the caught pokemon out of CoreData
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    // Predicate lets us define a parameter to choose objects in CoreData
    fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
    
    do{
        let pokemons = try context.fetch(fetchRequest)
        return pokemons
    } catch {}
    
    return []
}

