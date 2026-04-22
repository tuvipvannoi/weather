import Foundation
import Combine

protocol WeatherServiceProtocol {
    func fetchWeather(city: String) async throws -> WeatherAPIResponse
}

final class WeatherService: WeatherServiceProtocol {

    private let apiKey = "YOUR_API_KEY"

    func fetchWeather(city: String) async throws -> WeatherAPIResponse {
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city

        guard let url = URL(
            string: "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(encodedCity)"
        ) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        return try JSONDecoder().decode(WeatherAPIResponse.self, from: data)
    }
}
