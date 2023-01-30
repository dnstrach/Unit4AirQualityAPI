//
//  AirQualityController.swift
//  AirQuality
//
//  Created by Dominique Strachan on 1/12/23.
//

import Foundation

class AirQualityController {
    
    //MARK: String Constants
    //when adding components code is smart enough to know to add a slash or not - optional to add or remove a slash
    static let baseURL = URL(string: "https://api.airvisual.com/")
    //components
    //words with slashes at the beginning are components of the URL
    static let versionComponent = "v2"
    static let countriesComponent = "countries"
    static let statesComponents = "states"
    static let citiesComponents = "cities"
    static let cityComponent = "city"
    //keys
    static let countryKey = "country"
    static let stateKey = "state"
    static let cityKey = "city"
    static let apiKey = "key"
    static let apiKeyValue = "1273300b-c7e2-4cc9-89e4-693ce6b63e66"
    
    //MARK: - URL#1
    //http://api.airvisual.com/v2/countries?key={{YOUR_API_KEY}}
    static func fetchCountries(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let countriesURL = versionURL.appendingPathComponent(countriesComponent)
        
        //hit question mark - working with query
        //resolvingAgainstBaseURL used for constructing queries - true if appending to passed in URL or only returning query components
        var components = URLComponents(url: countriesURL, resolvingAgainstBaseURL: true)
        //constructing query items
        let apiQuery = URLQueryItem(name: apiKey, value: apiKeyValue)
        //components are array of queries
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        
        print(finalURL)
        
        //response left blank (wild card) - only need to be concerned if response is not 200
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                //structs in model must conform to Decodable class
                //topLevelObject is country object
                let topLevelObject = try JSONDecoder().decode(Country.self, from: data)
                //cannot access country name because data is an array t4 need to do for loop to access objects within array
                //[country: Afghanistan, ..., ...]
                let countryDicts = topLevelObject.data
                
                //creating array to hold country names
                var listOfCountryNames: [String] = []
                
                for country in countryDicts {
                    //providing value for countryName variable creating in model
                    let countryName = country.countryName
                    listOfCountryNames.append(countryName)
                    
                }
                
                return completion(.success(listOfCountryNames))
                
            } catch {
                //note: either or works and also do not have to include return because function will complete regardless...not sure why
                //return completion(.failure(.thrownError(error)))
                return completion(.failure(.unableToDecode))
            }
            
            
        }.resume()
    }
    
    //MARK: - URL#2
    //http://api.airvisual.com/v2/states?country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    static func fetchStates(forCountry: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let statesURL = versionURL.appendingPathComponent(statesComponents)
        
        var components = URLComponents(url: statesURL, resolvingAgainstBaseURL: true)
        let countryQuery = URLQueryItem(name: countryKey, value: forCountry)
        let apiQuery = URLQueryItem(name: apiKey, value: apiKeyValue)
        components?.queryItems = [countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(State.self, from: data)
                let stateDicts = topLevelObject.data
                
                var listOfStateName: [String] = []
                
                for state in stateDicts {
                    let stateName = state.stateName
                    listOfStateName.append(stateName)
                }
                
                return completion(.success(listOfStateName))
                
                
            } catch {
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
    }
    
    //MARK: - URL#3
    //http://api.airvisual.com/v2/cities?state={{STATE_NAME}}&country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    static func fetchCities (forState: String, inCountry: String, completion: @escaping (Result<[String], NetworkError>) -> Void ) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        
        let versionURL = baseURL.appending(component: versionComponent)
        let citiesURL = versionURL.appending(component: citiesComponents)
        
        var components = URLComponents(url: citiesURL, resolvingAgainstBaseURL: true)
        let stateQuery = URLQueryItem(name: stateKey, value: forState)
        let countryQuery = URLQueryItem(name: countryKey, value: inCountry)
        let apiQuery = URLQueryItem(name: apiKey, value: apiKeyValue)
        components?.queryItems = [stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(City.self, from: data)
                let cityDicts = topLevelObject.data
                
                var listOfCityNames: [String] = []
                
                for city in cityDicts {
                    let cityName = city.cityName
                    listOfCityNames.append(cityName)
                }
                
                return completion(.success(listOfCityNames))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
    }
    
    //MARK: - URL#4
    //http://api.airvisual.com/v2/city?city=Los Angeles&state=California&country=USA&key={{YOUR_API_KEY}}
    static func fetchCityData(forCity: String, inState: String, inCountry: String, completion: @escaping (Result<CityData, NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appending(component: versionComponent)
        let cityURL = versionURL.appending(component: cityComponent)
        
        var components = URLComponents(url: cityURL, resolvingAgainstBaseURL: true)
        let cityQuery = URLQueryItem(name: cityKey, value: forCity)
        let stateQuery = URLQueryItem(name: stateKey, value: inState)
        let countryQuery = URLQueryItem(name: countryKey, value: inCountry)
        let apiQuery = URLQueryItem(name: apiKey, value: apiKeyValue)
        components?.queryItems = [cityQuery, stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let cityData = try JSONDecoder().decode(CityData.self, from: data)
                
                return completion(.success(cityData))
            } catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
} //end of class
