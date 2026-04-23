import Foundation

protocol GeocodingServiceProtocol {
    func searchCity(named city: String) async throws -> CityLocation
}

enum GeocodingServiceError: LocalizedError {
    case invalidURL
    case cityNotFound

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL tìm kiếm thành phố không hợp lệ."
        case .cityNotFound:
            return "Không tìm thấy thành phố bạn nhập."
        }
    }
}

final class GeocodingService: GeocodingServiceProtocol {
    func searchCity(named city: String) async throws -> CityLocation {
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city

        guard let url = URL(
            string: "https://api.openweathermap.org/geo/1.0/direct?q=\(encodedCity)&limit=1&appid=\(APIConfig.openWeatherAPIKey)"
        ) else {
            throw GeocodingServiceError.invalidURL
        }

        print("Geocoding URL:", url.absoluteString)

        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse {
            print("Geocoding status:", httpResponse.statusCode)
        }

        print("Geocoding raw JSON:", String(data: data, encoding: .utf8) ?? "nil")

        let decoded = try JSONDecoder().decode([OpenWeatherGeocodingItem].self, from: data)

        print("Decoded city count:", decoded.count)

        guard let first = decoded.first else {
            throw GeocodingServiceError.cityNotFound
        }

        return CityLocation(
            name: first.name,
            country: first.country,
            latitude: first.lat,
            longitude: first.lon
        )
    }
}
