//
//  CityDataViewController.swift
//  AirQuality
//
//  Created by Dominique Strachan on 1/13/23.
//

import UIKit

class CityDataViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var cityStateCountryLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var latLongLabel: UILabel!
    
    
    
    //MARK: - Properties
    var country: String?
    var state: String?
    var city: String?

    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCityData()
    }
    
    //MARK: Helper Methods
    func fetchCityData() {
        guard let city = city, let state = state, let country = country else { return }
        AirQualityController.fetchCityData(forCity: city, inState: state, inCountry: country) { result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let cityData):
                    self.updateViews(with: cityData)
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                }
            }
        }
    }
    
    func updateViews(with cityData: CityData) {
        let data = cityData.data
        
        cityStateCountryLabel.text = "\(data.city), \(data.state), \(data.country)"
        
        aqiLabel.text = "AQI: \(data.current.pollution.aqius)"
        
        windspeedLabel.text = "Windspeed: \(data.current.weather.ws)"
        
        tempLabel.text = "Temperature: \(data.current.weather.tp)"
        
        humidityLabel.text = "Humidity: \(data.current.weather.hu)"
        
        let coordinates = data.location.coordinates
        if coordinates.count == 2 {
            latLongLabel.text = "Lat: \(coordinates[1]) \nLong: \(coordinates[0])"
        } else {
            latLongLabel.text = "Coordinates Unknown"
        }
    }
    

}//end of class
