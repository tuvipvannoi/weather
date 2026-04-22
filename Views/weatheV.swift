import SwiftUI

struct WeatherView: View {
    @StateObject var viewModel: WeatherViewModel
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    SearchBarView(
                        text: $viewModel.searchedCityText,
                        onSearch: {
                            router.lastSearchedCity = viewModel.searchedCityText
                            Task {
                                await viewModel.searchWeather()
                            }
                        },
                        onClear: {
                            viewModel.clearSearch()
                        }
                    )

                    if viewModel.isLoading {
                        ProgressView("Đang tải dữ liệu thời tiết...")
                            .padding(.top, 40)
                    } else if viewModel.hasWeatherData {
                        WeatherCardView(
                            cityName: viewModel.cityName,
                            countryName: viewModel.countryName,
                            temperatureText: viewModel.temperatureText,
                            humidityText: viewModel.humidityText,
                            windSpeedText: viewModel.windSpeedText,
                            conditionText: viewModel.conditionText,
                            iconURLString: viewModel.iconURLString
                        )
                    } else {
                        EmptyStateView()
                    }

                    if !router.lastSearchedCity.isEmpty {
                        Text("Tìm kiếm gần nhất: \(router.lastSearchedCity)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Weather")
            .alert(
                "Lỗi",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { newValue in
                        if !newValue {
                            viewModel.errorMessage = nil
                        }
                    }
                )
            ) {
                Button("OK", role: .cancel) {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "Đã có lỗi xảy ra.")
            }
        }
    }
}
