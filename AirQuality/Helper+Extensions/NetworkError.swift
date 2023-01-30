//
//  NetworkError.swift
//  AirQuality
//
//  Created by Dominique Strachan on 1/12/23.
//

import Foundation

enum NetworkError: LocalizedError {
    
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case.invalidURL:
            return "Unable to reach the server due to invalid URL"
        case .thrownError(let error):
            return "Error \(error.localizedDescription) -- \(error)"
        case .noData:
            return "The server responded with no data"
        case .unableToDecode:
            return "There was an error trying to decode the data"
        }
        
    }
    
}//end of enum
