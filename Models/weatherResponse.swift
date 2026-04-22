import Foundation

struct WeatherAPIResponse: Codable {
    let location: Location
    let current: Current
}

struct Location: Codable {
    let name: String
    let country: String
}

struct Current: Codable {
    let temp_c: Double
    let humidity: Int
    let wind_kph: Double
    let condition: Condition
}

struct Condition: Codable {
    let text: String
    let icon: String
}
