import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(city: String) async throws -> WeatherAPIResponse
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherAPIResponse
}

final class WeatherService: WeatherServiceProtocol {
    private let apiKey = "f6a504c703ab442cbcc230939262204"

    func fetchWeather(city: String) async throws -> WeatherAPIResponse {
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city

        guard let url = URL(
            string: "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(encodedCity)"
        ) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let raw = String(data: data, encoding: .utf8) ?? "No response body"
            throw NSError(domain: "WeatherAPI", code: 1, userInfo: [
                NSLocalizedDescriptionKey: raw
            ])
        }

        return try JSONDecoder().decode(WeatherAPIResponse.self, from: data)
    }

    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherAPIResponse {
        guard let url = URL(
            string: "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(latitude),\(longitude)"
        ) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let raw = String(data: data, encoding: .utf8) ?? "No response body"
            throw NSError(domain: "WeatherAPI", code: 1, userInfo: [
                NSLocalizedDescriptionKey: raw
            ])
        }

        return try JSONDecoder().decode(WeatherAPIResponse.self, from: data)
    }
}
