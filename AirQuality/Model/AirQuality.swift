//
//  AirQuality.swift
//  AirQuality
//
//  Created by Dominique Strachan on 1/12/23.
//

import Foundation

struct Country: Decodable {
    
    //data is array -- []data
    //data contains objects --  {}0
    let data: [Object]
    
    //inside objects are country keys with country name values -- country : "Afghanistan"
    struct Object: Decodable {
        let countryName: String
        
        enum CodingKeys: String, CodingKey {
            //countryName used throughout app
            //"country" string needed to identify country key from data
            case countryName = "country"
        }
    }//end of struct
} //end of struct

struct State: Decodable {
    let data: [Object]
    
    struct Object: Decodable {
        let stateName: String
        
        enum CodingKeys: String, CodingKey {
            case stateName = "state"
        }
    }//end of struct
}//end of struct

struct City: Decodable {
    let data: [Object]
    
    struct Object: Decodable {
        let cityName: String
        
        enum CodingKeys: String, CodingKey {
            case cityName = "city"
        }
    }//end of struct
}//end of struct

struct CityData: Decodable {
    //contains city, state and country keys with their values
    let data: Data
    
    struct Data: Decodable {
        let city: String
        let state: String
        let country: String
        
        let location: Location
        //defining Location object
        struct Location: Decodable {
            let coordinates: [Double]
        }
        
        let current: Current
        //defining Current object
        struct Current: Decodable {
            //contains weather object
            let weather: Weather
            struct Weather: Decodable {
                let tp: Int
                let hu: Int
                let ws: Double
            }
            
            //contains pollution object
            let pollution: Pollution
            struct Pollution: Decodable {
                let aqius: Int
            }
        }
    }//end of struct
}//end of struct
