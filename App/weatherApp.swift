import SwiftUI

@main
struct WeatherAppApp: App {
    private let environment = AppEnvironment.live
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            WeatherView(
                viewModel: WeatherViewModel(
                    geocodingService: environment.geocodingService,
                    weatherService: environment.weatherService
                )
            )
            .environmentObject(router)
        }
    }
}
