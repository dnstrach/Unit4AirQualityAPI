//
//  StateListTableViewController.swift
//  AirQuality
//
//  Created by Dominique Strachan on 1/13/23.
//

import UIKit

class StateListTableViewController: UITableViewController {
    
    //MARK: - Properties
    var country: String?
    var states: [String] = []
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchStates()
    }
    
    //MARK: - Helper Methods
    func fetchStates() {
        guard let country = country else { return }
        AirQualityController.fetchStates(forCountry: country) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let states):
                    self.states = states
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return states.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)
        
        let state = states[indexPath.row]
        
        cell.textLabel?.text = state
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //identifier
        if segue.identifier == "toCityVC" {
            //indexPath
            guard let indexPath = tableView.indexPathForSelectedRow,
                  //destination
                  let destination = segue.destination as? CityListTableViewController
            else { return }
            
            
            let state = states[indexPath.row]
        
            destination.country = country
            destination.state = state
        }
    }
    
}//end of class
