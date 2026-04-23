import Foundation

struct WeatherAPIResponse: Codable {
    let location: WeatherLocation
    let current: WeatherCurrent
}

struct WeatherLocation: Codable {
    let name: String
    let country: String
}

struct WeatherCurrent: Codable {
    let temp_c: Double
    let humidity: Int
    let wind_kph: Double
    let condition: WeatherCondition
}

struct WeatherCondition: Codable {
    let text: String
    let icon: String
}
