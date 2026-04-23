import Foundation
import Combine

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var searchedCityText: String = ""
    @Published var countryName: String = ""
    @Published var temperatureText: String = "--°C"
    @Published var humidityText: String = "--%"
    @Published var windSpeedText: String = "-- km/h"
    @Published var conditionText: String = "Chưa có dữ liệu"
    @Published var iconURLString: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var hasWeatherData: Bool = false

    private let geocodingService: GeocodingServiceProtocol
    private let weatherService: WeatherServiceProtocol

    init(
        geocodingService: GeocodingServiceProtocol,
        weatherService: WeatherServiceProtocol
    ) {
        self.geocodingService = geocodingService
        self.weatherService = weatherService
    }

    func searchWeather() async {
        let trimmedCity = searchedCityText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedCity.isEmpty else {
            errorMessage = "Vui lòng nhập tên thành phố."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let weather = try await weatherService.fetchWeather(city: trimmedCity)

            cityName = weather.location.name
            countryName = weather.location.country
            temperatureText = "\(Int(weather.current.temp_c.rounded()))°C"
            humidityText = "\(weather.current.humidity)%"
            windSpeedText = "\(String(format: "%.1f", weather.current.wind_kph)) km/h"
            conditionText = weather.current.condition.text
            iconURLString = "https:\(weather.current.condition.icon)"
            hasWeatherData = true
        } catch {
            hasWeatherData = false
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadWeatherForCurrentLocation(latitude: Double, longitude: Double) async {
        isLoading = true
        errorMessage = nil

        do {
            let weather = try await weatherService.fetchWeather(
                latitude: latitude,
                longitude: longitude
            )

            cityName = weather.location.name
            countryName = weather.location.country
            temperatureText = "\(Int(weather.current.temp_c.rounded()))°C"
            humidityText = "\(weather.current.humidity)%"
            windSpeedText = "\(String(format: "%.1f", weather.current.wind_kph)) km/h"
            conditionText = weather.current.condition.text
            iconURLString = "https:\(weather.current.condition.icon)"
            hasWeatherData = true
        } catch {
hasWeatherData = false
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func clearSearch() {
        searchedCityText = ""
        cityName = ""
        countryName = ""
        temperatureText = "--°C"
        humidityText = "--%"
        windSpeedText = "-- km/h"
        conditionText = "Chưa có dữ liệu"
        iconURLString = ""
        hasWeatherData = false
        errorMessage = nil
    }
}
