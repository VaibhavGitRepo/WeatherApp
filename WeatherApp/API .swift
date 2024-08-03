//
//  API .swift
//  WeatherApp
//
//  Created by Vaibhav Sharma on 02/08/24.
//

import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let current: Current
    
    struct Location: Codable {
        let name: String
        let region: String
        let country: String
        let lat: Double
        let lon: Double
        let tz_id: String
        let localtime: String
    }
    
    struct Current: Codable {
        let temp_c: Double
        let temp_f: Double
        let condition: Condition
        let wind_mph: Double
        let wind_kph: Double
        let humidity: Int
        
        struct Condition: Codable {
            let text: String
            let icon: String
        }
    }
}

class WeatherService {
    private let apiKey = "1be1e51061f74fc4b6a174005243007"
    private let baseURL = "http://api.weatherapi.com/v1/current.json"
    
    func fetchWeather(forCity city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let urlString = "\(baseURL)?key=\(apiKey)&q=\(city)&aqi=no"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
