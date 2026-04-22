import Foundation

struct OpenWeatherGeocodingItem: Decodable {
    let name: String
    let country: String
    let state: String?
    let lat: Double
    let lon: Double
}
