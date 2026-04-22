import Foundation

struct AppEnvironment {
    let geocodingService: GeocodingServiceProtocol
    let weatherService: WeatherServiceProtocol

    static let live = AppEnvironment(
        geocodingService: GeocodingService(),
        weatherService: WeatherService()
    )
}
