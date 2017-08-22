//
//  PokedexViewController.swift
//  Pokemon
//
//  Created by Matthew Bourke on 21/8/17.
//  Copyright © 2017 Matthew Bourke. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var pokedexList: UITableView!
    
    var caughtPokemons : [Pokemon] = []
    var uncaughtPokemons : [Pokemon] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        caughtPokemons = getAllCaughtPokemons()
        print("CAUGHT: \(caughtPokemons.count)")
        uncaughtPokemons = getAllUncaughtPokemons()
        print("UNCAUGHT: \(uncaughtPokemons.count)")
        
        pokedexList.delegate = self
        pokedexList.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caughtPokemons.count
        } else {
            return uncaughtPokemons.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon : Pokemon
        
        if indexPath.section == 0 {
            pokemon = caughtPokemons[indexPath.row]
        } else {
            pokemon = uncaughtPokemons[indexPath.row]
        }
        
        let cell = UITableViewCell()
        
        
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.imageName!)
        
        return cell
    }
    
    // Funciton to specify how many sections in a tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Function to specify headings for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Caught"
        } else {
            return "Uncaught"
        }
    }
    
    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
