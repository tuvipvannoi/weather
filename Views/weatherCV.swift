import SwiftUI

struct WeatherCardView: View {
    let cityName: String
    let countryName: String
    let temperatureText: String
    let humidityText: String
    let windSpeedText: String
    let conditionText: String
    let iconURLString: String

    var body: some View {
        VStack(spacing: 20) {
            if let url = URL(string: iconURLString), !iconURLString.isEmpty {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
            }

            VStack(spacing: 6) {
                Text(cityName)
                    .font(.system(size: 28, weight: .bold))

                Text(countryName)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }

            Text(temperatureText)
                .font(.system(size: 52, weight: .heavy))

            Text(conditionText)
                .font(.title3)
                .foregroundColor(.secondary)

            VStack(spacing: 14) {
                weatherRow(icon: "drop.fill", title: "Độ ẩm", value: humidityText)
                weatherRow(icon: "wind", title: "Tốc độ gió", value: windSpeedText)
            }
            .padding(.top, 8)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.blue.opacity(0.12))
        )
    }

    private func weatherRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}
