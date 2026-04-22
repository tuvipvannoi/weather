import Foundation
import Combine

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var searchedCityText: String = ""
    @Published var countryName: String = ""
    @Published var temperatureText: String = "--°C"
    @Published var humidityText: String = "--%"
    @Published var windSpeedText: String = "-- m/s"
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
            let location = try await geocodingService.searchCity(named: trimmedCity)
            let weather = try await weatherService.fetchWeather(
                latitude: location.latitude,
                longitude: location.longitude
            )

            cityName = weather.name
            countryName = location.country
            temperatureText = "\(Int(weather.main.temp.rounded()))°C"
            humidityText = "\(weather.main.humidity)%"
            windSpeedText = "\(String(format: "%.1f", weather.wind.speed)) m/s"
            conditionText = weather.weather.first?.description.capitalized ?? "Không có mô tả"

            if let icon = weather.weather.first?.icon {
                iconURLString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
            } else {
                iconURLString = ""
            }

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
        windSpeedText = "-- m/s"
        conditionText = "Chưa có dữ liệu"
        iconURLString = ""
        hasWeatherData = false
        errorMessage = nil
    }
}
